
class CKeydef
{
    __New(key)
    {
        this.keyName := GetKeyName(key) ; note that this chgd '^' to '6' 
        this.keysc := MakeKeySC(key)
        this.output := [] ; indexed by layer
        this.currOutput := 0    ; output as of current layer, set for access in other classes
        this.isDeadKey := 0
        this.isDualMode := 0
        this.isShifted := 0 ; is a shifted key ? ie '?' is Shift-/
        this.modifier := 0  ; CModifier
    }
    
    GetOutput(layer)
    {
        return this.output[layer]
    }
    
    ; save the output for this keydef on layer
    ; ie the 'mapping'
    SetOutput(layer, output)
    {
        this.output[layer] := output
    }    

    ; calls SetOutput for shifted version layer
    SetOutputSh(layer, output)
    {
        this.SetOutput(layer . CLayerDef.ShiftSuffix, output )
    }

    SetCurrOutput(layer)
    {
        this.currOutput := this.GetOutput(layer)
    }
    
    SetModifier(modifier)
    {
        this.modifier := modifier  ; CModifier
    }
    
    SetDeadKey(isDeadKey := 1)
    {
        this.isDeadKey := isDeadKey
    }    
    
    SetDualModeSh(layer, output)
    {
        this.SetDualMode(layer . CLayerDef.ShiftSuffix, output)
    }
    
    SetDualMode(layer, output)
    {
        if (!this.modifier)
        {
            outputdebug('SetDualMode ' this.char ' is not a modifier')
            return
        }
        
        this.modifier.SetDualMode()
        this.isDualMode := 1
        this.output[layer] := output
    }
    
}

