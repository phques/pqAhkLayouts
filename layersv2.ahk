; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

; doc says default=70
#MaxHotkeysPerInterval 140
#InstallKeybdHook
#Warn All, MsgBox

#include util.ahk
#include scancodes.ahk
#include modifiers.ahk
#include CComposer.ahk

global layout := 0
global expectUpDown := 0
global modifiersDown := {}


class CLayout
{
    __New()
    {
        this.keydefs := {}  ; CKeydef
        this.modifiers := new CModifiers
        this.layerdefs := {} ; CLayerDef
        this.composer := new CComposer()
        this.composeKey := 0
        this.activeLayer := 0
        
        ; create the main layer !
        this.activeLayer := this.CreateLayer('main', 0)
        
    }

    ; create a hotkey foreach key scancode of US kbd
    ; also creates the keydefs w. output = keyname on main layer
    CreateHotkeysForUsKbd(initializeKeydefs)
    {
        for idx, scanCode in usKbdScanCodes
        {    
            keysc := 'sc' scanCode
            createHotKey(keysc)
            
            if (initializeKeydefs)
            {
                ; create a keydef
                keydef := new CKeydef(keysc)
                this.AddKeydef(keydef)
                
                ; set output on main = keyname 
                keydef.SetOutput('main', GetKeyName(keysc))
            }
        }
    }
    
    CreateModifiers()
    {
        this.CreateModifier('LShift', '+')
        this.CreateModifier('RShift', '+')

        this.CreateModifier('LCtrl', '^')
        this.CreateModifier('RCtrl', '^')

        this.CreateModifier('LAlt', '!')
        this.CreateModifier('RAlt', '!')

    }

    CreateModifier(key, type)
    {
        mod := this.modifiers.Create(key, type)
        keydef := this.GetKeydef(key)
        keydef.SetModifier(mod)
    }
    
    CreateLayer(name, accessKeyName)
    {
    outputdebug('createlayer, nae = ' accessKeyName)
        if (accessKeyName)
            keydef := this.GetKeydef(accessKeyName)
        else
            keydef := 0
        layerdef := new CLayerDef(name, keydef)
        this.layerdefs[name] := layerdef
        return layerdef
    }
    
    AddKeydef(keydef)
    {
        this.keydefs[keydef.keysc] := keydef
        return keydef
    }
    
    GetKeydef(key)
    {
        return layout.keydefs[MakeKeySC(key)]
    }
    
    AddComposePairsList(initialKey, newComposePairs*)
    {
        this.composer.AddComposePairs(initialKey, newComposePairs*)
    }
    
    AddComposePairs(initialKey, pairsStr)
    {
        this.composer.AddComposePairs(initialKey, pairsStr)
    }
    
    SetComposeKey(key)
    {
        this.composeKey := MakeKeySC(key)
    }
    
    IsLayerAccessKey(keydef)
    {
        for idx, layerdef in this.layerdefs
        {
        outputdebug(idx ' ' layerdef)
            if (layerdef.IsAccessKey(keydef))
                return layerdef
        }
        return 0
    }
    
    SetActiveLayer(layerdef)
    {
        this.activeLayer := layerdef
    }

}

class CKeydef
{
    __New(key)
    {
        this.keyName := GetKeyName(key) ; note that this chgd '^' to '6' 
        this.keysc := MakeKeySC(key)
        this.output := [] ; indexed by layer
        this.currOutput := 0    ; output as of current layer, set for access in other classes
        this.isDeadKey := 0
        this.isDualMode := 0
        this.modifier := 0  ; CModifier
    }
    
    GetOutput(layer)
    {
        return this.output[layer]
    }
    
    ; save the output for this keydef on layer
    ; ie the 'mapping'
    SetOutput(layer, output)
    {
        this.output[layer] := output
    }    
    
    SetCurrOutput(layer)
    {
        this.currOutput := this.GetOutput(layer)
    }
    
    SetModifier(modifier)
    {
        this.modifier := modifier  ; CModifier
    }
    
    SetDeadKey(isDeadKey := 1)
    {
        this.isDeadKey := isDeadKey
    }    
    
    SetDualMode(layer, output)
    {
        if (!this.modifier)
        {
            outputdebug('SetDualMode ' this.char ' is not a modifier')
            return
        }
        
        this.modifier.SetDualMode()
        this.isDualMode := 1
        this.output[layer] := output
    }
    
}

class CLayerDef
{
    static layerDefs := []
    
    ; accessKeydef2 is used for example for shift : lshift & rshift
    __New(name, accessKeydef1, accessKeydef2 := 0)
    {
        ; idx := CLayerDef.layerDefs.Length() + 1
        ; this.Index := idx
        ; CLayerDef.layerDefs[idx] := this
        CLayerDef.layerDefs[name] := this
        this.Name := name
        this.accessKeydef1 := accessKeydef1
        this.accessKeydef2 := accessKeydef2
    }
    
    IsAccessKey(keydef)
    {
        ; outputdebug(this.accessKeydef1.keysc ' ' keydef.keysc)
        if (this.accessKeydef1 && this.accessKeydef1.keysc = keydef.keysc)
            return 1

        if (this.accessKeydef2 && this.accessKeydef2.keysc = keydef.keysc)
            return 1
            
        return 0
    }
    
}



; called on key press / release
; all our mapping logic goes here
;   scancode 'sc000'
;   upDown 'u' / 'd'
onKeyEvt(scancode, upDown)
{
; outputdebug scancode ' ' upDown 
        
    ;debug
    if (scancode == MakeKeySC('Escape'))
    {
        outputdebug('Escape hit : exit app')
        exitapp
    }
        
    ; get key def
    keydef := layout.keydefs[scancode]
    if (!keydef)
    {
        return
    }
    
    ; save current output according to current layer in keydef
    layerName := layout.activeLayer.name
    keydef.SetCurrOutput(layerName)
    
    eatKey := 0
    if (expectUpDown)
    {
        ret := expectUpDown.OnKey(keydef, upDown)
        if (ret.cancel || ret.completed)
        {
            if (ret.completed && ret.outputOnComplete)
            {
                doSend(ret.outputOnComplete)
            }
            
            outputdebug('reset expectUpDown')
            expectUpDown.Reset()
            expectUpDown := 0
        }
        
        eatKey := ret.eatKey
        ; if (ret.eatKey)
            ; return
    }

    ; recheck for expectUpDown, can be reset above and we might need to check for another 'waitFor' !
    ; eg: deadkey '^' (shift-6), lshift=dualMode : 
    ;  lshift dn -> start waitFor dualmode on lshift
    ;  '6' dn  -> cancel lshift waitFor dualmode AND exit... need to check for dead key
    if (!expectUpDown)
    {
        eatKey := checkForNewExpectUpDown(keydef, upDown)
    }
    
    if (eatKey)
        return
    
    ; 1st if modifier, mark up/down
    if (keydef.modifier)
    {
        ; ##TODO keep track of pressed modifers
        
        ; is this key a modifier that accesses a layer?
        layerdef := layout.IsLayerAccessKey(keydef)
        if (layerdef)
        {
            ; set new active layer
            this.SetActiveLayer(layerdef)
            
            ; save current output according to current layer in keydef
            layerName := layerdef.name
            keydef.SetCurrOutput(layerName)

        }
    }
    
    ; 2nd check for chord
    ;   on down, if part of possible chord
    
   
; temp .. todo (we will handle modifiers ourselves)
    output := scancode ; debug, default to original key
    
    if (keydef.modifier)
    {
        output := keydef.modifier.KeySC
    }
    else
    {
        if (keydef.currOutput)
            output := keydef.currOutput
    }
     
    if (upDown == 'd')
        Send '{blind}{' output ' Down}'
    else
        Send '{blind}{' output ' Up}'
}


; starts a new 'expectUpDown' if we got a compose/deadkey/dualMode key
checkForNewExpectUpDown(keydef, upDown)
{
    if (upDown == 'd')
    {
        if (keydef.keysc == layout.composeKey)
        {
            outputdebug('onKeyEvt create ccomposer ' keydef.keysc)
            expectUpDown := layout.composer
            expectUpDown.StartNew(keydef.keysc)
            return 1
        }
        if (keydef.isDeadKey)
        {
            outputdebug('onKeyEvt create ccomposer for deadkey ' keydef.keysc)
            expectUpDown := layout.composer
            expectUpDown.StartNew(keydef.keysc, 1)
            return 1
        }
        if (keydef.isDualMode)
        {
            outputdebug('onKeyEvt create CDualModer ' keydef.keysc)
            expectUpDown := new CDualModer(keydef.keysc, keydef.output[layout.activeLayer.name])
            ; DONT eat modifier down
            return 0
        }
    }
    
    return 0
}

; 'sc000'
doSend(scKey)
{
    Send '{' scKey ' Down}'
    Send '{' scKey ' Up}'
}

;--------

; keyScancode = 'sc000'
createHotkey(keyScancode)
{
    fnDn := Func("onKeyEvt").Bind(keyScancode, 'd')
    fnUp := Func("onKeyEvt").Bind(keyScancode, 'u')

    ; create hotKey for press and release of the key
    ; add '*' to hotkeyname (hotkey will work even when other modifiers are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' keyScancode, fnDn
    HotKey '*' keyScancode ' up', fnUp
}



;---------------------

; this is how to setup / startup the thing ;-)
layout := new CLayout()
layout.CreateHotkeysForUsKbd(1)
layout.CreateModifiers()

;;-- test

k := layout.GetKeydef("``")
k.SetDeadKey()

k := layout.GetKeydef("^")  ; actually 6
k.SetDeadKey()

; test kindof dual mode modifier
k := layout.GetKeydef("LShift")
k.SetDualMode('main', 'j')

layout.SetComposeKey('.')

; layout.AddComposePairsList('``', ['a', 'à'], ['e', 'è'])
; layout.AddComposePairsList('^', ['a', 'â'], ['e', 'ê'])
layout.AddComposePairs("``", "aà eè")
layout.AddComposePairs("^", "aâ eê iî")

; this is a special case, it can be accessed by both l/rshift
shftLayer :='shifted'
layout.CreateLayer(shftLayer, 'lshift', 'rshift')

k := layout.GetKeydef("a")
k.SetOutput(shftLayer, '+')

return

