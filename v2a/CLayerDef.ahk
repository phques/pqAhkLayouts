
class CLayerDef
{
    static nextIndex := 1
    static MainNm := 'main'
    static ShiftSuffix := '.shifted'

    
    ; special case for 'Shift' : will match either lshift or rshift
    __New(name, accessKeyName, accessKeydef)
    {
        this.Index := CLayerDef.nextIndex++ ; use as internal unique Id
        this.Name := name
        this.accessKeydef  := accessKeydef
        this.accessKeyName := accessKeyName
    }
    
    IsAccessKey(keydef)
    {
        ; outputdebug(this.accessKeydef1.keysc ' ' keydef.keysc)
        
        ; main layer has no access key !
        if (!this.accessKeydef)
            return 0
            
        if (this.accessKeydef.keysc == keydef.keysc)
            return 1

        ; special case for 'Shift' : will match either lshift or rshift
        ; lshift will actually be matched in the test above since scancode(lshift) = scancode(shift )
        if (this.accessKeyName = 'shift' && keydef.keyName = 'rshift')
            return 1
            
        return 0
    }
    
    IsSameLayer(layerdef)
    {
        return layerdef.Index == this.Index
    }
}

