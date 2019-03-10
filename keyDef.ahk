;-- CKeyDef --

#include util.ahk


class COutput
{
    ; outStr: 'a', '^c' (ctrl-c), "LShift", "CL"
    ; can be one of abbrevs above
    __New(outStr)
    {
        this.mods := ""
        this.key := ""
        this.isShifted := false  ;; see below
        
        this.isShiftKey := false
        this.isCtrlKey := false
        this.isAltKey := false
        this.isWinKey := false

        ; split modifiers / key
        this.splitModsAndKey(outStr)

        ; replace abbreviations with real value
        this.key := ApplyAbbrev(this.key)

        ; check for invalid key
        sc := GetKeySC(this.key)
        if (!sc) {
            msg := "Cannot find scancode for '" . this.key . "' outStr: <" . outStr . ">"
            outputdebug(msg)
            if (MsgBox(msg, "Error", "O/C") = "Cancel")
                ExitApp
        }

        ; set modifier flags
        name := GetKeyName(this.key)
        this.isShiftKey := (name ~= "i)shift")
        this.isCtrlKey := (name ~= "i)ctrl|control")
        this.isAltKey := (name ~= "i)alt")
        this.isWinKey := (name ~= "i)win")
        this.isModifier := this.isShiftKey || this.isCtrlKey
        this.isModifier |= this.isAltKey ||this.isWinKey

        ; set flag indicating if the char to output is shifted (ie '!' is Shift-1)
        shiftedChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        shiftedChars .='~!@#$`%^&*()_+{}|:"<>?'
        if (InStr(shiftedChars, this.key, 1))
            this.isShifted := true
    }

    ;-----

    ; '^Z' => mods='^', key='Z'
    splitModsAndKey(key)
    {
        this.mods := ""
        this.key := key
        foundPos := RegExMatch(key, "^([#!+^<>]+)(.{1,})", match)
        if (foundPos) {
            ; found prefix modifiers (shift: +,ctrl: ^ etc) in key
            ; separate them
            this.mods := match[1]
            this.key := match[2]
        }
    }
}


;; ------------

class CKeyDef
{
    static waitingDual := 0     ; CKeyDef
    static downKeys := {}       ; CKeyDef[keysc]

    ; key: 'a', "LShift", "Escape", "sc020" ..
    ; outXyz are COutput[2], [2] for shifted value
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

        CKeyDef.checkOnDualDn()

        ; mark key as down, save in down keys 'list'
        this.isDown := true
        CKeyDef.downKeys[this.sc] := this

        if (this.isDual) 
            CKeyDef.waitingDual := this

        this.onHoldDn()
    }

    OnKeyUp()
    {
        ; do this 1st
        this.isDown := 0
        CKeyDef.downKeys.Delete(this.sc)

        ; Always need to do this
        ; For a waiting dualMode that will do a Tap also ! 
        ;   (normally a modifier, so it's ok to send its Up key)
        this.onHoldUp()

        if (this.isDual) {
            ; dualMode key 'tap', output its tap value
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
    checkOnDualDn()
    {
        waiting := CKeyDef.waitingDual

        if (waiting && waiting.sc != this.sc) {
            ; waiting dual mode key, tap interrupted by other key,
            ; stay in 'hold dn' (dn already sent) / cancel Tap possiblity
            CKeyDef.waitingDual := 0
        }
    }

    ;;------ mappings ----

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
    CreateDualModifier(key, outStr, outTapStr)
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
    CreateLayerAccess(key, layerId, outTapStr)
    {
        ; always isDual, ignored if no outTapValue
        outTapValue := (outTapStr ? new COutput(outTapStr) : 0)
        outTapValueSh := (outTapStr ? new COutput("+" outTapStr) : 0)
        k1 := new CKeyDef(key, false, true, 0, [], [outTapValue,outTapValueSh])
        
        ; save layerId !
        k1.layerId := layerId

        k1.onHoldDn := Func("layerAccessDn")
        k1.onHoldUp := Func("layerAccessUp")
        k1.onTap := Func("sendTap")

        return k1
    }

    ;---

    /*static*/
    IsShiftDown()
    {
        ; is any of the currently 'down' keys a shift key ?
        For keysc, keydef in CKeyDef.downKeys {
            ; OutputDebug "+dn " keydef.name
            ; OutputDebug " " keydef.outValues[1].key
            ; OutputDebug " " GetKeyName(keydef.outValues[1].key)
            ; OutputDebug " " keydef.outValues[1].isShiftKey
            if (keydef.outValues[1] ) {                
                if (keydef.outValues[1].isShiftKey) {
                    ; OutputDebug "found shift dn " . keydef.name
                    Return True
                }
            }
            else {
                OutputDebug "IsShiftDown no outval[1] " . keydef.name
            }
        }

        ; non found
        return False
    }
}


