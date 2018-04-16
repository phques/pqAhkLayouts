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
#include CDualModer.ahk
#include CComposer.ahk
#include CLayout.ahk
#include CLayerDef.ahk
#include CKeyDef.ahk

global layout := 0
global expectUpDown := 0 ; phasing out ..
global downAccessMods := {} ; layer access modifiers currently down
global dualModer := 0



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
    
    
    ;[--- processing for compose / deadkeys / dualmode ...
    
    eatKey := 0
    if (dualModer)
    {
        ret := dualModer.OnKeyEvt(keydef, upDown)
        if (ret.cancel || ret.completed)
        {
            if (ret.completed && ret.outputOnComplete)
            {
                doSend(ret.outputOnComplete, 'd')
                doSend(ret.outputOnComplete, 'u')
            }
            
            outputdebug('remove dmoder')
            dualModer := 0
        }
        
        eatKey := ret.eatKey
    }

    ; recheck for dualModer, can be reset above and we might need to check for another 'waitFor' !
    if (!dualModer)
    {
        eatKey := checkForNewExpectUpDown(keydef, upDown)
    }
    
    ; go through layer access processing before eating
    ; this is touchy / tricky
    
    ; if (eatKey)
        ; return
        
    ; ... processing for compose / deadkeys / dualmode ---]
    
    
    ; check for modifiers / layer access
    if (keydef.modifier)
    {
        mod := keydef.modifier

        if (upDown == 'd')
        {
            ; is this key a modifier that accesses a layer?
            layerdef := layout.IsLayerAccessKey(keydef)
            if (layerdef)
            {
                if (!layout.IsActiveLayer(layerdef))
                {
                    ; set new active layer
                    outputdebug('changing to layer ' layerdef.name)
                    layout.SetActiveLayer(layerdef)
                    
                    ; save current output according to current layer in keydef
                    layerName := layerdef.name
                    keydef.SetCurrOutput(layerName)

                    ; this modifier  is being used as layer access, 
                    ; dont consider it 'down'
                    if (!downAccessMods[mod.KeySC])
                    {
                        downAccessMods[mod.KeySC] := 1
                        downAccessMods[mod.Type]++
                    }
                }
                
                ; dont send the modifier
                eatKey := 1
            }
        }
        else 
        {
            ; up modifier, changing out of layer?
            ; is this key a modifier that accesses a layer?
            layerdef := layout.IsLayerAccessKey(keydef)
            if (layerdef)
            {
                if (layout.IsActiveLayer(layerdef))
                {
                    ; re-select main layer
                    outputdebug('changing to layer main')
                    layerdef := layout.GetLayer(CLayout.MainNm)
                    layout.SetActiveLayer(layerdef)
                    
                    ; save current output according to current layer in keydef
                    layerName := layerdef.name
                    keydef.SetCurrOutput(layerName)
                    
                    ; this layer access modifier is not down anymore
                    if (downAccessMods[mod.KeySC])
                    {
                        ; track that modofier was released
                        downAccessMods[mod.KeySC] := 0
                        downAccessMods[mod.Type]--
                    }
                }
                
                ; dont send the modifier
                eatKey := 1
            }
        }
    }
    
   
    ; output
    if (eatKey)
        return
    
    
    output := ''
    ; output := scancode ; debug, default to original key
    
    isModifier := 0
    if (keydef.modifier)
    {
        output := keydef.modifier.KeySC
        isModifier := 1
    }
    else
    {
        if (keydef.currOutput)
            output := keydef.currOutput
    }
    
    ; send the output
    doSend(output, upDown, isModifier)
}


; 
doSend(output, upDown, isModifier := 0)
{
    if (output == '')
        return
    
    modsToRelease := ''
    
    if (!isModifier && 0)
    {
        if (downAccessMods['!'])
            modsToRelease .= '!'
            
        if (downAccessMods['#'])
            modsToRelease .= '#'
            
        if (downAccessMods['^'])
            modsToRelease .= '^'
            
        if (downAccessMods['+'])
            modsToRelease .= '+'
    }
    
    if (upDown == 'd')
        toSend := '{blind' modsToRelease '}{' output ' Down}'
    else
        toSend := '{blind' modsToRelease '}{' output ' Up}'
        
    OutputDebug('dosend ' toSend)
    Send toSend
}


; starts a new 'expectUpDown' if we got a compose/deadkey/dualMode key
; returns 1 to 'eat' the key (ie dont send it)
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
            dualModer := new CDualModer(keydef.keysc, keydef.currOutput)
            return 1
        }
    }
    
    return 0
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

InitdownAccessMods()
{
    downAccessMods['!'] := 0
    downAccessMods['^'] := 0
    downAccessMods['+'] := 0
    downAccessMods['#'] := 0
}

;---------------------

InitdownAccessMods()


;;-- test

; this is how to setup / startup the thing ;-)
layout := new CLayout()

; debug
assignKeydefOut()
{
    for idx, scanCode in usKbdScanCodes
    {    
        ; get keydef
        keysc := 'sc' scanCode
        keydef := layout.GetKeydef(keysc)
        
        ; set output on main = keyname 
        keydef.SetOutput(CLayout.MainNm, GetKeyName(keysc))
    }
}

; assignKeydefOut()

altGrLayerNm := 'altGr'
layout.CreateLayer(altGrLayerNm, 'RAlt')

k := layout.GetKeydef("6") 
k.SetOutput(CLayout.ShiftNm, '^') 

k := layout.GetKeydef("a")
k.SetOutput(CLayout.ShiftNm, '=') ; note this is an unshifted char
k.SetOutput(altGrLayerNm, '/')

k := layout.GetKeydef("e")
k.SetOutput(CLayout.ShiftNm, 'E')
k.SetOutput(altGrLayerNm, 'u')

; test dual mode modifier
k := layout.GetKeydef("LShift")
k.SetDualMode(CLayout.MainNm, 'j')
k.SetDualMode(CLayout.ShiftNm, 'J')

; dead keys / compose
; k := layout.GetKeydef("``")
; k.SetDeadKey()

; k := layout.GetKeydef("^")  ; actually 6
; k.SetDeadKey()

layout.SetComposeKey('.')

; layout.AddComposePairsList('``', ['a', 'à'], ['e', 'è'])
; layout.AddComposePairsList('^', ['a', 'â'], ['e', 'ê'])
layout.AddComposePairs("``", "aà eè AÀ")
layout.AddComposePairs("^", "aâ eê iî")


return

