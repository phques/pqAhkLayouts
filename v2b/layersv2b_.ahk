#InstallKeybdHook
#Warn All, MsgBox

#include util.ahk
#include scancodes.ahk


onKeyEvt(keySC, updn)
{
    OutputDebug("onKeyEvt " . keySC . " " . updn)
    if (keySC == MakeKeySC('Escape'))
    {
        outputdebug('Escape hit : exit app')
        exitapp
    }
}

; keyScancode = 'sc000'
CreateHotkey(keyScancode, func)
{
    fnDn := Func(func).Bind(keyScancode, 'd')
    fnUp := Func(func).Bind(keyScancode, 'u')

    ; create hotKey for press and release of the key
    ; add '*' to hotkeyname (hotkey will work even when other modifiers are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' keyScancode, fnDn
    HotKey '*' keyScancode ' up', fnUp
}

if (0) {
    for idx, scanCode in usKbdScanCodes
    {    
        ; create hotkey
        keySC := 'sc' scanCode
        CreateHotKey(keySC, "onKeyEvt")
    }

}

;;---------------

Hotkey2(key, funcNmUp, funcNmDn, param)
{
    keyScancode := MakeKeySC(key)
    fnDn := Func(funcNmUp).Bind(keyScancode, param)
    fnUp := Func(funcNmDn).Bind(keyScancode, param)

    ; create hotKey for press and release of the key
    ; add '*' to hotkeyname (hotkey will work even when other modifiers are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' keyScancode, fnDn
    HotKey '*' keyScancode ' up', fnUp
}

; ---

class CWaitingDualModeKey
{
    ; holds CWaitingDualModeKey instance of a dualMode key that was just pressed
    static waitingKey := 0

    __New(keySC, tapValue, holdValue)
    {
        this.keySC := keySC
        this.tapValue := tapValue
        this.holdValue := holdValue
    }


    ; -- called for all keys

    /*static*/ 
    CheckWaiting(keySC, updn)
    {
        outputdebug("CheckWaiting")
        if (this.waitingKey) {
            if (updn == "d")
                this.waitingKey.checkOnKeyDn(keySC)
            else
                this.waitingKey.checkOnKeyUp(keySC)
        }
    }

    checkOnKeyDn(keySC) 
    {
        if (keySC != this.keySC) {
            OutputDebug("cancel waiting dualmode " . GetKeyName(this.keySC))
            CWaitingDualModeKey.waitingKey := 0

            OutputDebug("output dualmode hold (dn)" . GetKeyName(this.holdValue))
            Send "{blind}{" . this.holdValue . " Down}"
        }
    }

    checkOnKeyUp(keySC) 
    {
    }


    ;;--- called for dual keys

    /*non static*/
    handleDualTap(keySC)
    {
        ;-- dualMode code
        nm := GetKeyName(this.keySC)
        OutputDebug("output dualmode tap" . nm . " : " . this.tapValue)

        Send "{blind}{" . this.tapValue . " Down}"
        Send "{blind}{" . this.tapValue . " Up}"

        CWaitingDualModeKey.waitingKey := 0
    }

    /*static*/
    OnDualDown(keySC, p)
    {
        ;-- 1st call the 'all keys' method (if a diff dualMode was waiting)
        this.CheckWaiting(keySC, "d")

        ;-- then dualMode code
        if (!this.waitingKey) {
            outputdebug("create dualmode " . GetKeyName(KeySC) . " " . p)
            newWaiting := new CWaitingDualModeKey(keySC, p.tapValue, p.holdValue)
            this.waitingKey := newWaiting            
        }
        ; else : might be repeating key, just skip
    }

    /*static*/
    OnDualUp(keySC, p)
    {
        ;-- 1st call the 'all keys' method (if a diff dualMode was waiting)
        this.CheckWaiting(keySC, "u")

        ;-- then dualMode code
        if (this.waitingKey && this.waitingKey.keySC == keySC) {
            this.waitingKey.handleDualTap(keySC)
        }
        else  {
            OutputDebug("output dualmode hold (up)" . GetKeyName(p.holdValue))
            Send "{blind}{" . p.holdValue . " Up}"
        }
    }
}


; ----

onKeyDown(keySC, p)
{
    OutputDebug("onKeyDown " . keySC)

    CWaitingDualModeKey.CheckWaiting(keySC, "d")

    Send "{blind}{" . keySC . " Down}"
}

onKeyUp(keySC, p)
{
    OutputDebug("onKeyUp " . keySC)

    CWaitingDualModeKey.CheckWaiting(keySC, "u")

    Send "{blind}{" . keySC . " Up}"
}

; ----

onDualKeyDown(keySC, p)
{
    OutputDebug("onDualKeyDown " . keySC)
    CWaitingDualModeKey.OnDualDown(keySC, p)
}

onDualKeyUp(keySC, p)
{
    OutputDebug("onDualKeyUp " . keySC)
    CWaitingDualModeKey.OnDualUp(keySC, p)
}

;;--------------

if (1) {
    for idx, scanCode in usKbdScanCodes
    {    
        ; create hotkey
        keySC := 'sc' scanCode
        HotKey2(keySC, "onKeyDown", "onKeyUp", 0)
    }

}

onEscapeExit(sc, p)
{
    outputdebug('Escape hit : exit app')
    exitapp
}

Hotkey2("Escape", "onEscapeExit", "onEscapeExit", 0)
Hotkey2("a", "onKeyDown", "onKeyUp", 0)
Hotkey2("LShift", "onDualKeyDown", "onDualKeyUp", {tapValue:"k", holdValue:"LShift"})
Hotkey2("b", "onDualKeyDown", "onDualKeyUp", {tapValue:"k", holdValue:"LShift"})

/*

aakkaakak

*/