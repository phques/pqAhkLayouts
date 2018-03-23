; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#InstallKeybdHook
#Warn All, MsgBox

#include util.ahk
#include scancodes.ahk
#include modifiers.ahk
#include CComposer.ahk

; key, output
global keydefs := {}

global composeKey := 0
global composer := 0

global expectUpDown := 0



; called on key press / release
; all our mapping logic goes here
;   scancode 'sc000'
;   upDown 'u' / 'd'
onKeyEvt(scancode, upDown)
{
; outputdebug scancode ' ' upDown 
        
    ; get key def
    keydef := keydefs[scancode]
    if (!keydef)
    {
        ;debug
        if (scancode == FormatAsScancode('Escape'))
            exitapp
            
        return
    }
    
    if (!expectUpDown)
    {
        if (keydef.key == composeKey && upDown == 'd')
        {
            outputdebug('onKeyEvt create ccomposer ' keydef.key)
            expectUpDown := composer
            expectUpDown.StartNew(keydef.key)
            return
        }
        if (keydef.isDeadKey && upDown == 'd')
        {
            outputdebug('onKeyEvt create ccomposer for deadkey ' keydef.key)
            expectUpDown := composer
            expectUpDown.StartNew(keydef.key, 1)
            return
        }
        if (keydef.isDualModeMod && upDown == 'd')
        {
            outputdebug('onKeyEvt create CDualModer ' keydef.key)
            expectUpDown := new CDualModer(keydef.key)
            ; DONT eat modifier down
        }
        
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
    
   
    ; if CheckComposeKeyEvt(keydef, upDown)
        ; return

    ; check dual mode modifiers
    ; if (CheckDualModeKeyEvt(keydef, upDown))
        ; return

; temp .. just output the input
    if (upDown == 'd')
        Send '{blind}{' scancode ' Down}'
    else
        Send '{blind}{' scancode ' Up}'
}


; 'sc000'
doSend(scKey)
{
    Send '{' scKey ' Down}'
    Send '{' scKey ' Up}'
}

onComposeKeyUp(keydef, upDown)
{
msgbox(keydef.key ' ' upDown)
    return 1
}


;;; dual mode modifiers key evt processing
; returns true if we processed the key and caller must ignore it.
CheckDualModeKeyEvt(keyDef, upDown)
{
    ;
    ; - how does 'dual mode' layer access key fits in this !?
/*
    ; last key evt was dualMode mod initial key down
    if last.firstDualModeDown {
        ; skip multi key downs of dualMode modifier
        if last.key == keyDef.key && 'd' {
            return 
        }
        
        ; press/release of dualMode
        if last.key == keyDef.key && 'u' {
            output dwn/up mapping
            last.firstDualModeDown := 0
            return
        }
        
        ; initial dualMode keyDwn followed by other key
        ; for now only support immediate dwn/up, 
        ; but could be scenarios w. intermediate keys that make sense.
        ; eg: we want keyX dualMode dwn/up on altGr layer
        ;   - keyX  dwn
        ;   - oops, wanted AltGr .. so AltGr dwn <===
        ;   - keyX up
        ; eg: vice versa, was on altGr, want main layer
        ;   - altGr dwn
        ;   - keyA dwn/up
        ;   - keyX dwn
        ;   - oops wanted keyX dual on main, so altGr up <===
        ;   - keyX up
        if last.key != keyDef.key {
            ; last (dual mode) is being used as modifier
            last.firstDualModeDown := 0
            process last as modifier
            'goto' process key normally
        }
    }
    else {
        ; detect initial dual mode modifier dwn
        if keyDef.isDual {
            keyDef.firstDualModeDown := 1
            return
        }
    }
*/
    return 0
}


;;; key evt processing for dead keys
;; simplified mode:
; 
; MUST press / release the dead key 1ST,
; then a second key
; Will not support more complex cases, like Windows does.
; And only registered compose outputs will work, others will be skipped
;
; returns true if we processed the key and caller must ignore it.
CheckDeadKeyKeyEvt(recvd, upDown)
{
    /*
    key := recvd.key
    
    ; no waiting deadkey
    if (waitingDkUp == 0)
    {
        if (recvd.deadKey)
        {
            ; ignore key up (?) of deadkey here
            ; got deadkey 1st down evt, chg state & skip
            if (upDown == 'd')
                waitingDkUp := recvd
                
            return 1
        }
        else 
        {
            ; normal processing
            return 0
        }
    }

    ; waiting for deadkey up
    if (waitingDkUp.key != key)
    {
        ; not key dn / up of deadkey, ignore
        waitingDkUp := 0
        return 1;
    }

    ; skip successive deadkey down
    if (upDown == 'd')
        return 1
        
    ; got deadkey up evt, goto wait for 2nd compoe key state & skip
    waitingCompose2ndKey := recvd.output
    waitingDkUp := 0
    return 1
    
    */
}

; keyScancode = 'sc000'
CreateHotkey(keyScancode)
{
    fnDn := Func("onKeyEvt").Bind(keyScancode, 'd')
    fnUp := Func("onKeyEvt").Bind(keyScancode, 'u')

    ; create hotKey for press and release of the key
    ; add '*' to hotkeyname (hotkey will work even when other mods are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' keyScancode, fnDn
    HotKey '*' keyScancode ' up', fnUp
}

; create a hotkey foreach key scancode of US kbd
CreateHotkeysForUsKbd()
{
    for idx, scanCode in usKbdScanCodes 
        CreateHotKey('sc' scanCode)
}


SetComposeKey(key)
{
    composeKey := FormatAsScancode(key)
}


;---------------------

CreateHotkeysForUsKbd()

;;-- test
; mods := new Modifiers

; define modifier keys
; mods.CreateShiftMod('LShift')
; mods.CreateShiftMod('RShift')

; mods.CreateControlMod('LCtrl')
; mods.CreateControlMod('RCtrl')

; mods.CreateAltMod('LAlt')
; mods.CreateAltMod('RAlt')

; test create some keydefs / keydefs
createkey(ch)
{
    local m := {}
    m.char := ch
    m.key := FormatAsScancode(ch)
    m.output := m.key
    keydefs[m.key] := m
    return m
}

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
keydefs[m.key] := m

SetComposeKey('.')

composer := new CComposer()
composer.AddComposePairs('``', ['a', 'à'], ['e', 'è'])
composer.AddComposePairs('^', ['a', 'â'], ['e', 'ê'])


return

; temp dbg, ctrl-win-q to exit
#^x::
  ; msgbox 'exiting'
  ExitApp()
