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
#include CLayout.ahk
#include CLayerDef.ahk
#include CKeyDef.ahk

global layout := 0
global expectUpDown := 0
global modifiersDown := {}




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
            
            ; outputdebug('reset expectUpDown')
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
            }
        }
        else ; up modifier, changing out of layer
        {
            ; re-select main layer
            layerdef := layout.GetLayer('main')
            layout.SetActiveLayer(layerdef)
            
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

