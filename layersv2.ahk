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
    CreateHotkeysForUsKbd()
    {
        for idx, scanCode in usKbdScanCodes
        {    
            keysc := 'sc' scanCode
            createHotKey(keysc)
            ; outputdebug(keysc ' name ' getkeyname(keysc))
            
            keydef := new CKeydef(keysc)
            this.AddKeydef(keydef)
        }
    }


    CreateLayer(name, accessKey)
    {
        layerdef := new CLayerDef(name, accessKey)
        this.layerdef[name] := layerdef
        return layerdef
    }
    
    AddKeydef(keydef)
    {
        this.keydefs[keydef.keysc] := keydef
        return keydef
    }
    
    GetKeydef(key)
    {
        return layout.keydefs[KeySC(key)]
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
        this.composeKey := KeySC(key)
    }

}

class CKeydef
{
    __New(key)
    {
        this.char := GetKeyName(key)
        this.keysc := KeySC(key)
        this.output := [] ; indexed by layer
        this.isDeadKey := 0
        this.isDualMode := 0
        this.modifier := 0  ; CModifier
    }
    
    SetDeadKey(isDeadKey := 1)
    {
        this.isDeadKey := isDeadKey
    }    
    
    SetDualMode(output, layer)
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
    
    __New(name, accessKey)
    {
        ; idx := CLayerDef.layerDefs.Length() + 1
        ; this.Index := idx
        ; CLayerDef.layerDefs[idx] := this
        CLayerDef.layerDefs[name] := this
        this.Name := name
        this.AccessKey := AccessKey
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
    if (scancode == KeySC('Escape'))
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
        
        if (ret.eatKey)
            return
    }
    else
    {
        if (checkForNewExpectUpDown(keydef, upDown))
            return
    }
    
    ; 1st if modifier, mark up/down
    ; 2nd check for chord
    ;   on down, if part of possible chord
    
   
; temp .. todo (we will handle modifiers ourselves)
    output := scancode
    if (keydef.output[layout.activeLayer.name])
        output := keydef.output[layout.activeLayer.name]
        
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
            expectUpDown := new CDualModer(keydef.keysc)
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

;--------

; create a hotkey foreach key scancode of US kbd
CreateHotkeysForUsKbd()
{
    for idx, scanCode in usKbdScanCodes
    {    
        keysc := 'sc' scanCode
        createHotKey(keysc)
        ; outputdebug(keysc ' name ' getkeyname(keysc))
    }
}



;---------------------

layout := new CLayout()

layout.CreateHotkeysForUsKbd()

;;-- test


; define modifier keys
; modifiers.CreateShiftMod('LShift')
; modifiers.CreateShiftMod('RShift')

; modifiers.CreateControlMod('LCtrl')
; modifiers.CreateControlMod('RCtrl')

; modifiers.CreateAltMod('LAlt')
; modifiers.CreateAltMod('RAlt')


k := layout.GetKeydef("``")
k.SetDeadKey()

k := layout.GetKeydef("^")
k.SetDeadKey()

; test kindof dual mode modifier
k := layout.GetKeydef("LShift")
k.SetDualMode('j', 'main')

layout.SetComposeKey('.')

; layout.AddComposePairsList('``', ['a', 'à'], ['e', 'è'])
; layout.AddComposePairsList('^', ['a', 'â'], ['e', 'ê'])
layout.AddComposePairs("``", "aà eè")
layout.AddComposePairs("^", "aâ eê iî")

return

; temp dbg, ctrl-win-q to exit
; #^x::
  ; ExitApp()
