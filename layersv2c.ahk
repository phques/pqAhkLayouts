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
        this.outValue := outValue
        this.outTapValue := outTapValue
    }

    ; overridables
    onHoldDn() { ; action when 1st pressed down / on repeat
    }

    onHoldUp() { ; action on release: cancel onHoldDn action
    }

    onTap() { ; action on press/release (dualMode keys only)
    }

    ; ---- base key mechanics ---

    OnKeyDn()
    {
        if (this.isDown && !this.canRepeat)
            return

        this.checkOnDualDn()

        ; wasDn := this.isDown
        this.isDown := true

        if (this.isDual) 
            CKeyDef.waitingDual := this

        this.onHoldDn()
    }

    OnKeyUp()
    {
        if (this.isDual) {
            if (CKeyDef.waitingDual == this) {
                ; cancel hold dn 1st
                this.onHoldUp() 

                this.onTap()
                CKeyDef.waitingDual := 0
            }
            else {
                this.onHoldUp()
            }
        }
        else {
            this.onHoldUp()
        }

        this.isDown := 0
    }

    ;----

    checkOnDualDn()
    {
        waiting := CKeyDef.waitingDual

        if (waiting && waiting.sc != this.sc) {
            ; waiting dual mode key, tap interrupted by other key,
            ; goto hold dn / up mode (dn already sent)
            CKeyDef.waitingDual := 0
        }
    }
}

;--------

; CKeyDef, idx = keyScancode
global keydefs := {}

onHotkeyDn(sc)
{
    ; OutputDebug "onHotkeyDn '" . sc . "' " . GetKeyName(sc)
    keydef := keydefs[sc]
    keydef.OnKeyDn()
}

onHotkeyUp(sc)
{
    ; OutputDebug "onHotkeyUp '" . sc . "' " . GetKeyName(sc)
    keydef := keydefs[sc]
    keydef.OnKeyUp()
}


Hotkey2(sc)
{
    fnDn := Func("onHotkeyDn").Bind(sc)
    fnUp := Func("onHotkeyUp").Bind(sc)

    ; create hotKey for press and release of the key
    ; add '*' to hotkeyname (hotkey will work even when other modifiers are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' sc, fnDn
    HotKey '*' sc ' up', fnUp
}

;-------

;; action funcs for keydefs

sendOutValueDn(keydef) 
{ 
    Send "{blind}{" . keydef.outValue . " Down}"
}

sendOutValueUp(keydef) 
{ 
    Send "{blind}{" . keydef.outValue . " Up}"
}

sendTap(keydef) 
{
    if (keydef.outTapValue) {
        Send "{blind}{" . keydef.outTapValue . " Down}"
        Send "{blind}{" . keydef.outTapValue . " Up}"
    }
}

layerAccessDn(keydef) 
{   ;TODO
    ; outValue is layer idx
    outputdebug "layer on : " keydef.outValue
}

layerAccessUp(keydef) 
{   ;TODO
    ; outValue is layer idx
    outputdebug "layer off : " keydef.outValue
}

;--

AddStdKeydef(keyNm, outValue)
{
    ; k1 := new CStdKey(keyNm, true, false, outValue, 0)
    k1 := new CKeyDef(keyNm, true, false, outValue, 0)
    k1.onHoldDn := Func("sendOutValueDn")
    k1.onHoldUp := Func("sendOutValueUp")

    keydefs[k1.sc] := k1
    Hotkey2(k1.sc)
    return k1
}

AddDualModifier(keyNm, outValue, outTapValue)
{
    ; k1 := new CDualModeModifier(keyNm, false, true, outValue, outTapValue)
    k1 := new CKeyDef(keyNm, false, true, outValue, outTapValue)

    k1.onHoldDn := Func("sendOutValueDn")
    k1.onHoldUp := Func("sendOutValueUp")
    k1.onTap := Func("sendTap")

    keydefs[k1.sc] := k1
    Hotkey2(k1.sc)
    return k1
}

AddLayerAccess(keyNm, layerIdx, outTapValue)
{
    ; always isDual, ignored if no outTapValue
    ; k1 := new CDualModeLayerAccess(keyNm, layerIdx, outTapValue)
    ; save layerIdx in outValue
    k1 := new CKeyDef(keyNm, false, true, layerIdx, outTapValue)

    k1.onHoldDn := Func("layerAccessDn")
    k1.onHoldUp := Func("layerAccessUp")
    k1.onTap := Func("sendTap")

    keydefs[k1.sc] := k1
    Hotkey2(k1.sc)
    return k1
}

;-------

toto()
{
    AddStdKeydef('a', 'i')
    AddStdKeydef('LCtrl', 'j')

    AddDualModifier('LShift', 'LShift', 'k')
    AddDualModifier('b', 'LShift', 'l')
    ; AddDualModifier('v', 't', 'r') ;;hihi makes no sense

    AddLayerAccess("RAlt", 2, 0)
    AddLayerAccess("n", 3, 'q')
    AddLayerAccess("Space", 4, "Space")

}

Init(layers, mappings)
{
    ; create all hotkeys

    ; create layers, 1st is main
    for idx, val in layers {
        outputdebug idx . ' ' . val.lid ' ' val.key ' ' val.tap
    }

    ;  create layer access keys (keydefs in main)
    ; for idx, val in layers {
    ; }

    ; create mappings (keydefs in layers)
    for idx, val in mappings {
        outputdebug idx . ' ' . val.lid
        outputdebug '   ' . val.map
    }
    for idx, val in mappings {
        outputdebug idx . ' ' . val.lid 'Sh'
        outputdebug '   ' val.mapSh
    }

}

tata()
{
    layers := [
        {lid: "main"},
        {lid: "punx", key: "Space", tap: "Space"},
        {lid: "edit", key: "LAlt"}
    ]
    mappings := [
        {lid: "main", map: "a s d  i e a", mapSh: "a s d  I E A"},
        {lid: "punx", map: "a s d  , `; ." },
    ]

    Init(layers, mappings)
}

tata()
; toto()

; ---

; debug, hit Esc to stop script
Escape::exitapp

/* todo
- must register hotkey for all keys 
  -> eg dualmode Shift : 
     shift+F2, we won't see F2 press/rel and will sendTap for dual shift
- need shifted outValue etc
- output code (handle modifiers, ie shift ..)
- 'add mappings' funcs
- implement actual layers
  -> 1 layer = dictio of key 
  -> or have mappings in keydef, ie outValue[layerIdx]
  ?-> could implement chording by assigning layerAccess on a layer !
      eg: space for punc layer, on punc layer, shift (or other key) accesses numpad

*/