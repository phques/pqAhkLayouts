;-- CKeyDef / COutput --
; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#include util.ahk

; holds output value for a key
class COutput
{
    ; outStr: 'a', '^c' (ctrl-c), "LShift", "CL"
    ; can be one of abbrevs supported by ApplyAbbrev()
    __New(outStr)
    {
        this.mods := ""     ; modifiers
        this.val := ""      ; output val
        this.needBlindShift := false
        
        this.isShiftKey := false
        this.isCtrlKey := false
        this.isAltKey := false
        this.isWinKey := false

        ; split modifiers / val
        this.splitModsAndKey(outStr)

        ; replace abbreviations with real value
        this.val := ApplyAbbrev(this.val)

        ; PQ: cannot do this, some output might not be a <key>, eg french chars etc
        ; check for invalid key
        ; sc := GetKeySC(this.val)
        ; if (!sc) {
        ;     msg := "Cannot find scancode for '" . this.val . "' outStr: <" . outStr . ">"
        ;     outputdebug(msg)
        ;     if (MsgBox(msg, "Error", "O/C") = "Cancel")
        ;         ExitApp
        ; }

        ; set modifier flags
        name := GetKeyName(this.val)
        this.isShiftKey := (name ~= "i)shift")
        this.isCtrlKey := (name ~= "i)ctrl|control")
        this.isAltKey := (name ~= "i)alt")
        this.isWinKey := (name ~= "i)win")
        this.isModifier := this.isShiftKey || this.isCtrlKey
        this.isModifier |= this.isAltKey   || this.isWinKey

        ; set flag indicating we need to mask Shift key for output that 
        ; is a non-shifted, to avoid sending the wrong thing 
        ; eg: if '[' is on Shifted layer, would send shift-[, which generates {
        /* still not right ! stuff like Delete, Home etc are not detected            
        nonShiftedChars := 'abcdefghijklmnopqrstuvwxyz'
        nonShiftedChars .= "``1234567890-=[]\`;',./"
        if (InStr(nonShiftedChars, this.val, 1))
            this.needBlindShift := true
        */
        shiftedChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        shiftedChars .= '~!@#$%^&*()_+{}|:"<>?'
        if (!InStr(shiftedChars, this.val, 1))
            this.needBlindShift := true
    }

    ;-----

    ; '^Z' => mods='^', val='Z'
    splitModsAndKey(val)
    {
        this.mods := ""
        this.val := val
        foundPos := RegExMatch(val, "^([#!+^<>]+)(.{1,})", match)
        if (foundPos) {
            ; found prefix modifiers (shift: +,ctrl: ^ etc) in val
            ; separate them
            this.mods := match[1]
            this.val := match[2]
        }
    }
}


;; ------------

; holds definition of a key
class CKeyDef
{
    static waitingDual := 0     ; CKeyDef of a dualMode key for possible Tap
    static downKeys := {}       ; CKeyDef[keysc], currently down keys

    ; key: 'a', "LShift", "Escape", "sc020" ..
    ; outXyz are COutput[2], outXyz[2] is shifted value
    __New(key, canRepeat, isDual, outValues, outTapValues)
    {
        this.name := GetKeyName(key)
        this.sc := MakeKeySC(key)
        this.canRepeat := canRepeat
        this.isDual := isDual
        this.isLayerAccess := false
        
        this.isDown := false
        this.outValues := outValues
        this.outTapValues := outTapValues

        ; check that we got a valid key
        sc := GetKeySC(key)
        if (!sc) {
            msg := "Cannot find scancode for '" key "'"
            outputdebug(msg)
            if (MsgBox(msg, "Error", "O/C") = "Cancel")
                ExitApp
        }
    }

    ; overridables
    onHoldDn() { ; action when 1st pressed down / on repeat
    }

    onHoldUp() { ; action on release
    }

    onTap() { ; action on press/release (Tap) (dualMode keys)
    }

    ; ---- base key mechanics ---

    OnKeyDn()
    {
        if (this.isDown && !this.canRepeat)
            return

        ; check to cancel waiting potential dualMode key Tap
        CKeyDef.checkOnDualDn()

        ; mark key as down, save in down keys 'list'
        this.isDown := true
        CKeyDef.downKeys[this.sc] := this

        ; OutputDebug "kdn, " CKeyDef.downKeys.Count() " keys dn"

        if (this.isDual) 
            CKeyDef.waitingDual := this

        ; call keys holdDown action
        this.onHoldDn()
    }

    OnKeyUp()
    {
        ; do this 1st (mark key not down, remove from list of keys down)
        this.isDown := 0
        CKeyDef.downKeys.Delete(this.sc)

        ; Always need to do this
        ; For a waiting dualMode that would succeed to Tap also ! 
        this.onHoldUp()

        if (this.isDual) {
            ; dualMode key 'tap' success: output its tap value
            ; note that if a different had been pressed after this one, 
            ; we would have removed CKeyDef.waitingDual
            if (CKeyDef.waitingDual == this) {
                this.onTap()
                CKeyDef.waitingDual := 0
            }
        }

        ; this.isDown := 0
        ; CKeyDef.downKeys.Delete(this.sc)
    }

    ;----

    /*static*/
    ; check to cancel waiting potential dualMode key Tap
    checkOnDualDn()
    {
        waiting := CKeyDef.waitingDual

        if (waiting && waiting.sc != this.sc) {
            ; waiting dual mode key, tap interrupted by other key / mouse click,
            ; stay in 'hold dn' mode (dn already sent) / cancel Tap possiblity
            CKeyDef.waitingDual := 0
        }
    }

    ;;------ mappings ----

    ; save a mapping / outvalue for this key 
    ; (either: out val/shift out val/tap val/shift tap val)
    AddMapping(outStr, isShiftedLayer, isTapValue)
    {
        ; setup output object
        outValue := new COutput(outStr)
    
        if (isTapValue) {
            if (isShiftedLayer) 
                this.outTapValues[2] := outValue
            else 
                this.outTapValues[1] := outValue
        }
        else {
            if (isShiftedLayer) 
                this.outValues[2] := outValue
            else 
                this.outValues[1] := outValue
        }
    }

    ;----

    ; returns proper outValue (shift/non-shift/tap/normal) according to current key downs etc
    GetValues(isTap)
    {
        out := 0

        values := (isTap ? this.outTapValues : this.outValues)
        if (values) {
            idx := CKeyDef.IsShiftDown() ? 2 : 1
            out := values[idx]
        }
        Else {
            OutputDebug "keydef getValues, no values"
        }

        return out
    }

    ; -------

    /*static*/
    CreateStdKeydef(key, outStr)
    {
        outValue := new COutput(outStr)
        outValueSh := new COutput("+" outStr)
        k1 := new CKeyDef(key, true, false, [outValue,outValueSh], [])
        k1.onHoldDn := Func("sendOutValueDn")
        k1.onHoldUp := Func("sendOutValueUp")

        return k1
    }

    ; outStr should be a modifier !! eg "LShift", "RAlt"
    /*static*/
    CreateDualModifier(key, outStr, outTapStr := 0)
    {
        k1 := CKeyDef.CreateEmptyDualModifier(key)
        outValue := new COutput(outStr)
        outValueSh := new COutput("+" outStr)
        outTapValue := (!outTapStr ? 0 : new COutput(outTapStr))
        outTapValueSh := (!outTapStr ? 0 : new COutput("+" outTapStr))
        k1.outValues := [outValue,outValue]
        k1.outTapValues := [outTapValue, outTapValue]

        return k1
    }

    /*static*/
    CreateEmptyDualModifier(key)
    {
        k1 := new CKeyDef(key, false, true, [], [])
        k1.onHoldDn := Func("sendOutValueDn")
        k1.onHoldUp := Func("sendOutValueUp")
        k1.onTap := Func("sendTap")
        k1.isModifier := true

        return k1
    }

    /*static*/
    CreateLayerAccess(key, layerId, outTapStr := 0)
    {
        ; always isDual, onTap ignored if no outTapValue
        outTapValue := (outTapStr ? new COutput(outTapStr) : 0)
        outTapValueSh := (outTapStr ? new COutput("+" outTapStr) : 0)
        k1 := new CKeyDef(key, false, true, [], [outTapValue,outTapValueSh])
        
        ; save layerId !
        k1.layerId := layerId

        k1.onHoldDn := Func("layerAccessDn")
        k1.onHoldUp := Func("layerAccessUp")
        k1.onTap := Func("sendTap")

        return k1
    }

    ;---

    /*static*/
    ; is any of the currently 'down' keys a shift key ?
    IsShiftDown()
    {
        For keysc, keydef in CKeyDef.downKeys {
            ; OutputDebug "-- +dn " keydef.name
            if (keydef.outValues[1] ) {                
                ; OutputDebug " " keydef.outValues[1].val
                ; OutputDebug " " GetKeyName(keydef.outValues[1].val)
                if (keydef.outValues[1].isShiftKey) {
                    ; OutputDebug "found shift dn " . keydef.name
                    Return True
                }
            }
            else {
                ; OutputDebug "IsShiftDown no outval[1] " . keydef.name
            }
        }

        ; non found
        return False
    }
}


