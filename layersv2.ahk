; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#InstallKeybdHook
#Warn All, MsgBox

#include util.ahk
#include scancodes.ahk
#include modifiers.ahk

; key, output
global keydefs := {}

global composeKey := 0
global composeKeyPairs := {}
global waitingCompose2ndKey := 0

global waitingForKeyUp := 0



; to handle deadkeys, compose, dual mode modifier
; we must get uninterrupted dn/up of same key (1 or multiple *)
class CExpectUpDown
{
    class Result
    {
        __New(eat, cancel)
        {
            this.eat := eat
            this.cancel := cancel
        }
    }
    
    waitingFor := ''
    upDown := ''      ; 'u' 'd'    
    completed := []
    nbrRequired := 0
    
    OnDown(keydef, upDown)
    {
        if (this.waitingFor != keydef.key)
        {
            ; didnt get needed key, eat & cancel
            res := new CExpectUpDown.Result(1,1)
            return res
        }
    }
}

toto()
{
ex := new CExpectUpDown()
ex.waitingFor := 'sc000'
ex.upDown := 'u'

kd := {}
kd.key := 'sc999'
res := ex.OnDown(kd, 'd')
msgbox('eat ' res.eat ' cancel ' res.cancel)
}

toto()
exitapp

; called on key press / release
; all our mapping logic goes here
;   scancode 'sc000'
;   upDown 'u' / 'd'
onKeyEvt(scancode, upDown)
{
; outputdebug scancode ' ' upDown 
        
    ; get key def
    keydef := keydefs[scancode]
    ; debug
    if (!keydef)
        keydef := {}
    
    ; 1st if modifier, mark up/down
    ; 2nd check for chord
    ;   on down, if part of possible chord
    
    if (waitingForKeyUp)
    {
        if (waitingForKeyUp.key == keydef.key)
        {
            if (upDown == 'd')
                return ;; skip successive key downs
            
            ; key up, process this case
            waitingForKeyUp.fn.Call(keydef, upDown)
            waitingForKeyUp := 0
            return
        }
        
        ; didnt get down/up of this key, reset & eat 2nd key
        waitingForKeyUp := 0
        return
    }
    else 
    {
        if (upDown == 'd')
        {
            if (keydef.key == composeKey)
            {
                waitingForKeyUp := {}
                waitingForKeyUp.key := keydef.key
                waitingForKeyUp.fn := Func('onComposeKeyUp')
            }
        }
    }
    
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

; 'sc000'
GetComposed(sc1, sc2)
{
    out := 0
    if (composeKeyPairs[sc1])
        out := composeKeyPairs[sc1][sc2]
        
    return out
}

CheckComposeKeyEvt(keyDef, upDown)
{
    ; no pending compose key, normal processing
    if (!waitingCompose2ndKey)
    {
        ; is this a compose key
        if (composeKey == keyDef.key)
        {
            ; got a compose initiating key, save and skip
            waitingCompose2ndKey := keyDef.key
            return 1
        }
        
        ; continue normal processing
        return 0
    }
    else ; have a pending compose key
    {
        if (upDown == 'u')
        {
            ; not expecting up here, reset & skip
            waitingCompose2ndKey := 0
            return 1
        }
        else
        {
            ; recvd a key down with a pending compose
            ; get the composed result and output if ok
            toOutput := GetComposed(waitingCompose2ndKey, keyDef.output)
            if (toOutput)
                doSend(toOutput)

            ; no more processing
            return 1
        }
    }
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

; '`', [['a', 'à'], ['e', 'è']..]
AddComposeKeyPairs(initialKey, composePairs*)
{
    sc1 := FormatAsScancode(initialKey)
    
    pairs := composeKeyPairs[sc1]
    if (!pairs)
        composeKeyPairs[sc1] := pairs := {} 

    for idx, pair in composePairs
    {
        ; pairs['a'] := 'à'
        ; but in sc000 format
        pairs[FormatAsScancode(pair[1])] := FormatAsScancode(pair[2])
    }
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
m := {}
m.key := FormatAsScancode('``')
m.output := m.key
keydefs[m.key] := m

m := {}
m.key := FormatAsScancode('^')
m.output := m.key
keydefs[m.key] := m

composeKey := m.key

; create a compose key
; m := {}
; m.key := FormatAsScancode('^')
; m.output := m.key
; keydefs[m.key] := m

AddComposeKeyPairs('``', ['a', 'à'], ['e', 'è'])
AddComposeKeyPairs('^', ['a', 'â'], ['e', 'ê'])




; temp dbg, ctrl-win-q to exit
#^x::
  ; msgbox 'exiting'
  ExitApp()
