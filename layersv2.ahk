#InstallKeybdHook

#include scancodes.ahk

global Mappings := {}

; called on key press / release
; all our mapping logic goes here
onKey(scancode, upDown)
{
outputdebug scancode ' ' upDown
    if (upDown == 'd')
        Send '{' scancode ' Down}'
    else
        Send '{' scancode ' Up}'
}


; key => 'sc000'
FormatAsScancode(key)
{
	return Format("sc{:03x}", GetKeySC(key))
}

; keyScancode = 'sc000'
CreateHotkey(keyScancode)
{
    fnDn := Func("onKey").Bind(keyScancode, 'd')
    fnUp := Func("onKey").Bind(keyScancode, 'u')

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
