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
        this.keydefs := {}
        this.modifiers := new CModifiers
        this.composer := new CComposer()
        this.composeKey := 0
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
        this.composeKey := FormatAsScancode(key)
    }

}

class CKeydef
{
    __New(key)
    {
        this.char := GetKeyName(key)
        this.key := FormatAsScancode(key)
        this.output := [] ; indexed by layer
    }
}

class CLayerDef
{
    static layerDefs := []
    
    __New(accessKey)
    {
        idx := CLayerDef.layerDefs.Length() + 1
        this.Index := idx
        this.AccessKey := AccessKey
        CLayerDef.layerDefs[idx] := this
    }
}

; called on key press / release
; all our mapping logic goes here
;   scancode 'sc000'
;   upDown 'u' / 'd'
onKeyEvt(scancode, upDown)
{
; outputdebug scancode ' ' upDown 
        
    ; get key def
    keydef := layout.keydefs[scancode]
    if (!keydef)
    {
        ;debug
        if (scancode == FormatAsScancode('Escape'))
            exitapp
            
        return
    }
    
    if (!expectUpDown)
    {
        if (checkForNewExpectUpDown(keydef, upDown))
            return
    }
    else
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
    
    ; 1st if modifier, mark up/down
    ; 2nd check for chord
    ;   on down, if part of possible chord
    
   
; temp .. just output the input
    if (upDown == 'd')
        Send '{blind}{' scancode ' Down}'
    else
        Send '{blind}{' scancode ' Up}'
}


; starts a new 'expectUpDown' if we got a compose/deadkey/dualMode key
checkForNewExpectUpDown(keydef, upDown)
{
    if (upDown == 'd')
    {
        if (keydef.key == layout.composeKey)
        {
            outputdebug('onKeyEvt create ccomposer ' keydef.key)
            expectUpDown := layout.composer
            expectUpDown.StartNew(keydef.key)
            return 1
        }
        if (keydef.isDeadKey)
        {
            outputdebug('onKeyEvt create ccomposer for deadkey ' keydef.key)
            expectUpDown := layout.composer
            expectUpDown.StartNew(keydef.key, 1)
            return 1
        }
        if (keydef.isDualModeMod)
        {
            outputdebug('onKeyEvt create CDualModer ' keydef.key)
            expectUpDown := new CDualModer(keydef.key)
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
        ; outputdebug(keysc ' name ' getkeyname(keysc))
        createHotKey(keysc)
    }
}



;---------------------

CreateHotkeysForUsKbd()
layout := new CLayout()

;;-- test

; test create some keydefs / keydefs
createkey(ch)
{
    local m := {}
    m.char := ch
    m.key := FormatAsScancode(ch)
    m.output := m.key
    layout.keydefs[m.key] := m
    return m
}

; define modifier keys
; modifiers.CreateShiftMod('LShift')
; modifiers.CreateShiftMod('RShift')

; modifiers.CreateControlMod('LCtrl')
; modifiers.CreateControlMod('RCtrl')

; modifiers.CreateAltMod('LAlt')
; modifiers.CreateAltMod('RAlt')


createKey('a')
createKey('b')
createKey('c')
createKey('d')
createKey('e')
createKey('.')
m := createKey('``')
m.isDeadKey := 1
m := createKey('^')
m.isDeadKey := 1

; test kindof dual mode modifier
m := {}
m.char := 'j'
m.key := FormatAsScancode('LShift')
m.output := m.key
m.dualModeOutput := FormatAsScancode(m.char)
m.isDualModeMod := 1
layout.keydefs[m.key] := m

layout.SetComposeKey('.')

; layout.AddComposePairsList('``', ['a', 'à'], ['e', 'è'])
; layout.AddComposePairsList('^', ['a', 'â'], ['e', 'ê'])
layout.AddComposePairs("``", "aà eè")
layout.AddComposePairs("^", "aâ eê iî")

return

; temp dbg, ctrl-win-q to exit
; #^x::
  ; ExitApp()
