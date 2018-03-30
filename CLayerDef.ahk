
class CLayerDef
{
    static nextIndex := 1
    
    ; accessKeydef2 is used for example for shift : lshift & rshift
    __New(name, accessKeydef1, accessKeydef2 := 0)
    {
        this.Index := CLayerDef.nextIndex++ ; use as internal unique Id
        this.Name := name
        this.accessKeydef1 := accessKeydef1
        this.accessKeydef2 := accessKeydef2
    }
    
    IsAccessKey(keydef)
    {
        ; outputdebug(this.accessKeydef1.keysc ' ' keydef.keysc)
        if (this.accessKeydef1 && this.accessKeydef1.keysc = keydef.keysc)
            return 1

        if (this.accessKeydef2 && this.accessKeydef2.keysc = keydef.keysc)
            return 1
            
        return 0
    }
    
    IsSameLayer(layerdef)
    {
        return layerdef.Index == this.Index
    }
}

