
class CKeyDef
{
    ;CKeyDef
    static waitingDual := 0

    ; keyNm: 'a', "LShift", "Escape", "sc020" ..
    __New(keyNm, canRepeat, isDual, outValue, outValueSh, outTapValue)
    {
        this.keyNm := GetKeyName(keyNm)
        this.sc := MakeKeySC(keyNm)
        this.canRepeat := canRepeat
        this.isDual := isDual
        this.isDown := false
        this.outValue := outValue
        this.outValueSh := outValueSh
        this.outTapValue := outTapValue
        this.isLayerAccess := false
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
