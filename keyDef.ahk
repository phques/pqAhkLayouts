;-- CKeyDef --

#include util.ahk


global keyAbbrevs := { "SP" : "Space", "CL" : "CapsLock", "LSh" : "LShift", "RSh" : "RShift" }

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
        if (keyAbbrevs[this.key])
            this.key := keyAbbrevs[this.key]

        this.isShiftKey := (this.key ~= "i)shift")
        this.isCtrlKey := (this.key ~= "i)ctrl|control")
        this.isAltKey := (this.key ~= "i)alt")
        this.isWinKey := (this.key ~= "i)win")
        this isModifier := this.isShiftKey || this.isCtrlKey || 
                           this.isAltKey ||this.isWinKey

        ; set flag indicating if the char to output is shifted (ie ! is Shift-1)
        shiftedChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        shiftedChars .='~!@#$`%^&*()_+{}|:"<>?'
        if (InStr(shiftedChars, this.key))
            this.isShifted := true
    }

    ;-----

    ; '^Z' => '^', 'Z'
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
    ;CKeyDef
    static waitingDual := 0

    ; key: 'a', "LShift", "Escape", "sc020" ..
    ; outXyz are COutput
    __New(key, canRepeat, isDual, outValue, outValueSh, outTapValue)
    {
        this.name := GetKeyName(key)
        this.sc := MakeKeySC(key)
        this.canRepeat := canRepeat
        this.isDual := isDual
        this.isLayerAccess := false
        ; this.isModifier := outValue.isShiftKey || outValue.isCtrlKey || 
        ;                    outValue.isAltKey || outValue.isWinKey
        
        this.isDown := false
        this.outValue := outValue
        this.outValueSh := outValueSh
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

    ;;------ mappings ----

    AddMapping(outStr, isShiftedLayer)
    {
        ; setup output object
        outValue := new COutput(outStr)
            
        if (isShiftedLayer) 
            this.outValueSh := outValue
        else 
            this.outValue := outValue
    }

    ;---

    ; IsShiftModifier()
    ; {
    ;     return (this.isModifier && this.outValue.isShiftKey 
    ; }

    CreateStdKeydef(key, outStr)
    {
        outValue := new COutput(outStr)
        k1 := new CKeyDef(key, true, false, outValue, 0, 0)
        k1.onHoldDn := Func("sendOutValueDn")
        k1.onHoldUp := Func("sendOutValueUp")

        return k1
    }

    ; outStr should be a modifier !! eg "LShift", "RAlt"
    /*static*/
    CreateDualModifier(key, outStr, outTapStr)
    {
        outValue := new COutput(outStr)
        outTapValue := new COutput(outTapStr)
        k1 := CreateEmptyDualModifier(key)
        k1.outValue := outValue
        k1.outTapValue := outTapValue

        return k1
    }

    /*static*/
    CreateEmptyDualModifier(key)
    {
        k1 := new CKeyDef(key, false, true, outValue, outTapValue)
        k1.onHoldDn := Func("sendOutValueDn")
        k1.onHoldUp := Func("sendOutValueUp")
        k1.onTap := Func("sendTap")
        k1.isModifier := true

        return k1
    }
}


