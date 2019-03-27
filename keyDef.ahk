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
    ; see code below for "~key"
    __New(outStr)
    {
        this.mods := ""     ; modifiers
        this.val := ""      ; output val
        this.needBlindShift := false
        
        this.isShiftKey := false
        this.isCtrlKey := false
        this.isAltKey := false
        this.isWinKey := false

        ; if has ~ prefix, indicates we need to use Send {Blind+}
        ; to mask out any down Shift 
        ; eg, to send ';' (a non-shifted value) on a shifted layer
        if (StrLen(outStr) > 1 && SubStr(outStr,1,1) == '~') {
            outStr := SubStr(outStr,2)
            this.needBlindShift := true
        }

        ; split modifiers / val
        this.splitModsAndKey(outStr)

        ; replace abbreviations with real value
        this.val := ApplyAbbrev(this.val)

        ; set modifier flags
        name := GetKeyName(this.val)
        this.isShiftKey := (name ~= "i)shift")
        this.isCtrlKey := (name ~= "i)ctrl|control")
        this.isAltKey := (name ~= "i)alt")
        this.isWinKey := (name ~= "i)win")
        this.isModifier := this.isShiftKey || this.isCtrlKey
        this.isModifier |= this.isAltKey   || this.isWinKey
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
    static waitingDual := 0         ; CKeyDef of a dualMode key for possible Tap
    static downKeys := {}           ; CKeyDef[keysc], currently down keys
    static downDualModifiers := {}  ; CKeyDef[keysc], currently down dual modifier keys

    ; key: 'a', "LShift", "Escape", "sc020" ..
    ; outXyz are COutput[2], outXyz[2] is shifted value
    __New(key, canRepeat, isDual, outValues, outTapValues)
    {
        this.name := GetKeyName(key)
        this.sc := MakeKeySC(key)
        this.canRepeat := canRepeat
        this.isDual := isDual
        this.currDualMode := ""  ; tap / mod
        this.restoreDualOnUp := false
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

        if (this.isDual)  {
            ; add to list of down dual modifiers
            CKeyDef.waitingDual := this
            CKeyDef.downDualModifiers[this.sc] := this
            this.currDualMode := "tap"  ; start in tap mode, until other key hit

            ; (dont ouput dual mode modifiers down)
            ; we get missing keys up when we do this
            if (this.isLayerAccess) {
                ; call keys holdDown action, in this case it's layer change
                this.onHoldDn()
            }
        }
        else {
            ; call keys holdDown action
            this.onHoldDn()
        }
    }


    OnKeyUp()
    {
        ; do this 1st (mark key not down, remove from list of keys down)
        this.isDown := 0
        this.currDualMode := ""

        ; remove from list of down keys & dual modifiers
        CKeyDef.downKeys.Delete(this.sc)
        CKeyDef.downDualModifiers.Delete(this.sc)


        if (this.isDual) {
            ; call key's holdUp action, in this case it's layer change
            ; do this 1st, so that if the key onTap is a layer toggle we dont overwrite it !
            if (this.isLayerAccess) {
                this.onHoldUp()
            }
            ; dualMode key 'tap' success: output its tap value
            ; note that if a different key had been pressed after this one, 
            ; we would have removed CKeyDef.waitingDual
            if (CKeyDef.waitingDual == this) {
                this.onTap()
                CKeyDef.waitingDual := 0
            }
        }
        else {
            this.onHoldUp()
            if (this.restoreDualOnUp) {
	            this.isDual := true
	            this.restoreDualOnUp := false
            }
        }

        ; this.isDown := 0
        ; CKeyDef.downKeys.Delete(this.sc)
    }

    ;----

    tempRemoveDual()
    {
    	; outputdebug "tempRemoveDual()"
        CKeyDef.downDualModifiers.Delete(this.sc)
        this.isDual := false
        this.restoreDualOnUp := true
        
        ; layer access key might be dual but have not outval (just tap val)
        if (this.outValues[1] && this.outValues[1].val) {
            Send "{blind}{" this.outValues[1].val " downr}" ; key up will send the up event
            ; outputdebug "Send {blind}{" this.outValues[1].val " downr}" 
        }
    }

    /*static*/
    ; check to cancel waiting potential dualMode key Tap
    checkOnDualDn(isMouseClick := false)
    {
        waiting := CKeyDef.waitingDual

        if (waiting && waiting.sc != this.sc) {
            ; waiting dual mode key, tap interrupted by other key / mouse click,
            ; cancel Tap possiblity
            waiting.currDualMode := "mod"
            CKeyDef.waitingDual := 0

            if (isMouseClick) {
            	waiting.tempRemoveDual()
            }
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
        k1 := new CKeyDef(key, true, false, [outValue,outValue], [])
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
        outTapValue := (!outTapStr ? 0 : new COutput(outTapStr))
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
        k1 := new CKeyDef(key, false, true, [], [outTapValue,outTapValue])
        
        ; save layerId !
        k1.layerId := layerId
        k1.isLayerAccess := True

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

    /*static*/
    ; returns list of currently down dual mode modifiers (as key strings, ie "LShift")
    ; [dualModDn, dualModUp]
    GetDownDualModifiers()
    {
        dualModDn := ""
        dualModUp := ""
        downDualMods := []
        for idx, keydef in CKeyDef.downDualModifiers {
            if (keydef.outValues[1]) {
            	dualModDn .= "{" keydef.outValues[1].val " down}"
            	dualModUp .= "{" keydef.outValues[1].val " up}"
               ; downDualMods.Push(keydef.outValues[1].val)
            }
        }
        return [dualModDn, dualModUp]
    }
}


