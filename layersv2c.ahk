#InstallKeybdHook
#Warn All, MsgBox

#include util.ahk
#include scancodes.ahk


class CKeyDef
{
    ;CKeyDef
    static waitingDual := 0

    ; keyNm: 'a', "LShift", "Escape", "sc020" ..
    __New(keyNm, canRepeat, isDual, outValue, outTapValue)
    {
        this.keyNm := GetKeyName(keyNm)
        this.sc := MakeKeySC(keyNm)
        this.canRepeat := canRepeat
        this.isDual := isDual
        this.isDown := false
        this.outTapValue := outTapValue
        this.outValue := outValue
    }

    ; overridables
    onDn() { 
    }
    onUp() { 
    }
    onHoldDn() { 
    }
    onHoldUp() { 
    }
    onTap() { 
    }
    onCancelledTap() {
    }

    ; base key mechanics
    OnKeyDn()
    {
        if (this.isDown && !this.canRepeat)
            return

        this.checkOnDualDn()

        ; wasDn := this.isDown
        this.isDown := true

        if (this.isDual) {
            CKeyDef.waitingDual := this
            this.onHoldDn()
        }
        else {
            this.OnDn()
        }
    }

    OnKeyUp()
    {
        this.checkOnDualUp()

        if (this.isDual) {
            waiting := CKeyDef.waitingDual

            if (waiting && waiting.sc == this.sc)
                waiting.onTap()  ; nb waiting == this !
            else
                this.onHoldUp()

            CKeyDef.waitingDual := 0
        }
        else {
            this.onUp()
        }

        this.isDown := 0
    }

    ;----

    checkOnDualDn()
    {
        waiting := CKeyDef.waitingDual

        if (waiting && waiting.sc != this.sc) {
            outputdebug "checkOnDualDn cancel waiting " waiting.keyNm
            waiting.onCancelledTap(this)
            CKeyDef.waitingDual := 0
        }
    }

    checkOnDualUp()
    {
    }
}

;--------

; CKeyDef, idx = keyScancode
global keydefs := {}

onKeyDn(sc)
{
    OutputDebug "onKeyDn '" . sc . "' " . GetKeyName(sc)
    keydef := keydefs[sc]
    keydef.OnKeyDn()
}

onKeyUp(sc)
{
    OutputDebug "onKeyUp '" . sc . "' " . GetKeyName(sc)
    keydef := keydefs[sc]
    keydef.OnKeyUp()
}


Hotkey2(sc)
{
    fnDn := Func("onKeyDn").Bind(sc)
    fnUp := Func("onKeyUp").Bind(sc)

    ; create hotKey for press and release of the key
    ; add '*' to hotkeyname (hotkey will work even when other modifiers are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' sc, fnDn
    HotKey '*' sc ' up', fnUp
}

;--------

class CStdKey extends CKeyDef
{
    ; overrides
    onDn() { 
        Send "{blind}{" . this.outValue . " Down}"
    }
    onUp() { 
        Send "{blind}{" . this.outValue . " Up}"
    }
}

;--------

class CDualModeModifier extends CKeyDef
{
    ; overrides
    onHoldDn() { 
    }
    onHoldUp() { 
        Send "{blind}{" . this.outValue . " Up}"
    }
    onTap() { 
        Send "{blind}{" . this.outTapValue . " Down}"
        Send "{blind}{" . this.outTapValue . " Up}"
    }
    onCancelledTap() {
        Send "{blind}{" . this.outValue . " Down}"
    }
}

;-------

class CDualModeLayerAccess extends CKeyDef
{
    ; always isDual, ignored if no outTapValue
    __New(keyNm, layerIdx, outTapValue)
    {
        base.__New(keyNm, false, true, 0, outTapValue)
        this.layerIdx := layerIdx
    }

    ; overrides
    onHoldDn() { 
        outputdebug "layer on : " this.layerIdx
    }
    onHoldUp() { 
        outputdebug "layer off : " this.layerIdx
    }
    onTap() { 
        if (this.outTapValue) {
            Send "{blind}{" . this.outTapValue . " Down}"
            Send "{blind}{" . this.outTapValue . " Up}"
        }
        this.onHoldUp()
    }
}

;-------

AddStdKeydef(keyNm, canRepeat, outValue)
{
    k1 := new CStdKey(keyNm, canRepeat, false, outValue, 0)
    keydefs[k1.sc] := k1
    Hotkey2(k1.sc)
}

AddDualModifier(keyNm, outValue, outTapValue)
{
    k1 := new CDualModeModifier(keyNm, false, true, outValue, outTapValue)
    keydefs[k1.sc] := k1
    Hotkey2(k1.sc)
}

AddLayerAccess(keyNm, layerIdx, outTapValue)
{
    ; always isDual, ignored if no outTapValue
    k1 := new CDualModeLayerAccess(keyNm, layerIdx, outTapValue)
    keydefs[k1.sc] := k1
    Hotkey2(k1.sc)
}


toto()
{
    AddStdKeydef('a', true, 'i')
    AddStdKeydef('LCtrl', true, 'j')

    AddDualModifier('LShift', 'LShift', 'k')
    AddDualModifier('b', 'LShift', 'l')
    AddDualModifier('v', 't', 'r') ;;hihi makes no sense

    AddLayerAccess("Space", 1, 0)
    AddLayerAccess("RAlt", 1, 'q')
}

toto()

; ---

Escape::exitapp

/* todo
- need shifted outValue etc
- 'add mappings' funcs
- implement actual layers
  -> 1 layer = dictio of key 
  -> or have mappings in keydef, ie outValue[layerIdx]
  ?-> could implement chording by assigning layerAccess on a layer !
      eg: space for punc layer, on punc layer, shift (or other key) accesses numpad

- how to have different / new action on up/dn ?
  -> action key, recv func in new
     eg switch to numpad layer, 'macro': send text, etc
  -> layerAccess w. action on Tap
     eg hold for numpad, tap to switch to numpad
  -> dualModeModifier w. action on Tap
     eg hold for Ctrl, tap for macro/send text
*/