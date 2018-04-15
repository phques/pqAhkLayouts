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
global modifiersDown := {}
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
    
    if (eatKey)
        return
        
    ; ... processing for compose / deadkeys / dualmode ---]
    
    
    ; check for modifiers / layer access
    if (keydef.modifier)
    {
        mod := keydef.modifier

        if (upDown == 'd')
        {
            ; is this key a modifier that accesses a layer?
            layerdef := layout.IsLayerAccessKey(keydef)
            if (layerdef && !layout.IsActiveLayer(layerdef))
            {
                ; set new active layer
                layout.SetActiveLayer(layerdef)
                
                ; save current output according to current layer in keydef
                layerName := layerdef.name
                keydef.SetCurrOutput(layerName)

                ; this modifier  is being used as layer access, 
                ; dont consider it 'down'
                ;## actually, we send it ! so DO consider it down
            }
            ; else
            {
                if (!modifiersDown[mod.KeySC])
                {
                    modifiersDown[mod.KeySC] := 1
                    modifiersDown[mod.Type]++
                }
            }
        }
        else 
        {
            ; up modifier, changing out of layer?
            ; is this key a modifier that accesses a layer?
            layerdef := layout.IsLayerAccessKey(keydef)
            if (layerdef && layout.IsActiveLayer(layerdef))
            {
                ; re-select main layer
                layerdef := layout.GetLayer('main')
                layout.SetActiveLayer(layerdef)
                
                ; save current output according to current layer in keydef
                layerName := layerdef.name
                keydef.SetCurrOutput(layerName)
                
                ; we did not mark this modifier sa down when used as layer access,
                ; so dont try to remove it fro our mods down data
                ;## actually, we send it ! so DO consider it down
            }
            ; else
            {
                if (modifiersDown[mod.KeySC])
                {
                    ; track that modofier was released
                    modifiersDown[mod.KeySC] := 0
                    modifiersDown[mod.Type]--
                }
            }
        }
    }
    
    ; 2nd check for chord
    ;   on down, if part of possible chord
    
   
; temp .. todo (we will handle modifiers ourselves)
    output := scancode ; debug, default to original key
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
    modsToRelease := ''
    
    if (!isModifier)
    {
        if (modifiersDown['!'])
            modsToRelease .= '!'
            
        if (modifiersDown['#'])
            modsToRelease .= '#'
            
        if (modifiersDown['^'])
            modsToRelease .= '^'
            
        if (modifiersDown['+'])
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
            ; dualModer := new CDualModer(keydef.keysc, keydef.output[layout.activeLayer.name])
            ; DONT eat modifier down
            return 0
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

InitModifiersDown()
{
    modifiersDown['!'] := 0
    modifiersDown['^'] := 0
    modifiersDown['+'] := 0
    modifiersDown['#'] := 0
}

;---------------------

; this is how to setup / startup the thing ;-)
layout := new CLayout()
layout.CreateHotkeysForUsKbd(1)
layout.CreateModifiers()
InitModifiersDown()

;;-- test

; 'shift' is a special case of layer access, it can be accessed by both l/rshift
shiftLayerNm := 'main.shifted'
layout.CreateLayer(shiftLayerNm, 'shift')

altGrLayerNm := 'altGr'
layout.CreateLayer(altGrLayerNm, 'RAlt')

; test dual mode modifier
k := layout.GetKeydef("LShift")
k.SetDualMode('main', 'j')
k.SetDualMode(shiftLayerNm, 'J')

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

k := layout.GetKeydef("^") ; 6 !
k.SetOutput(shiftLayerNm, '^') 

k := layout.GetKeydef("a")
k.SetOutput(shiftLayerNm, '=') ; note this is an unshifted char
k.SetOutput(altGrLayerNm, '/')

k := layout.GetKeydef("e")
k.SetOutput(shiftLayerNm, 'E')

return

