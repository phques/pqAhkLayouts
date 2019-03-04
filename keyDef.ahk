;-- CKeyDef --

#include util.ahk


global keyAbbrevs := { "SP" : "Space", "CL" : "CapsLock", "LSh" : "LShift", "RSh" : "RShift" }

class COutput
{
    ; outStr: 'a', '^c' (ctrl-c), "LShift", "CL"
    ; can be one of abbrevs above
    __New(outStr)
    {
        ; replace abbreviations with real value
        if (keyAbbrevs[outStr])
            outStr := keyAbbrevs[outStr]
            
        ; split modifiers / key
        this.splitModsAndKey(outStr)

        ; set flag indicating if the char to output is shifted (ie ! is Shift-1)
        shiftedChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        shiftedChars .='~!@#$`%^&*()_+{}|:"<>?'
        if (InStr(shiftedChars, this.key))
            this.isShifted := 1
        else
            this.isShifted := 0
    }

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
        this.isDown := false
        this.outValue := outValue
        this.outValueSh := outValueSh
        this.outTapValue := outTapValue
        this.isLayerAccess := false
        this.isModifier := false
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
        if (isShiftedLayer)
            this.outValueSh := new COutput(outStr)
        else
            this.outValue := new COutput(outStr)
    }
}


