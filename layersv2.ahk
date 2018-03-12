#InstallKeybdHook

#include scancodes.ahk

global Mappings := {}

; called on key press / release
; all our mapping logic goes here
onKeyEvt(scancode, upDown)
{
;outputdebug scancode ' ' upDown
        
    ; get key def
    key := {}
    
    ; check dual mode modifiers
    if (CheckDualModeKeyEvt(key, upDown))
        return

; temp .. just output the input
    if (upDown == 'd')
        Send '{' scancode ' Down}'
    else
        Send '{' scancode ' Up}'
}


;;; dual mode modifiers key evt processing
; returns true if we processed the key and caller must ignore it.
CheckDualModeKeyEvt(key, upDown)
{
    ;
    ; - how does 'dual mode' layer access key fits in this !?
/*
    ; last key evt was dualMode mod initial key down
    if last.firstDualModeDown {
        ; skip multi key downs of dualMode modifier
        if last = key && 'd' {
            return 
        }
        
        ; press/release of dualMode
        if last = key && 'u' {
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
        if last != key {
            ; last (dual mode) is being used as modifier
            last.firstDualModeDown := 0
            process last as modifier
            'goto' process key normally
        }
    }
    else {
        ; detect initial dual mode modifier dwn
        if key.isDual {
            key.firstDualModeDown := 1
            return
        }
    }
*/
    return 0
}


; key => 'sc000'
FormatAsScancode(key)
{
	return Format("sc{:03x}", GetKeySC(key))
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
    for idx, scanCode in usKbdScanCodes {
        CreateHotKey('sc' scanCode)
    }
}


CreateHotkeysForUsKbd()
return
