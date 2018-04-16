

class CLayout
{
    static MainNm := 'main'
    static ShiftNm := 'main.shifted'

    
    __New()
    {
        this.keydefs := {}  ; CKeydef
        this.modifiers := new CModifiers
        this.layerdefs := {} ; CLayerDef
        this.composer := new CComposer()
        this.composeKey := 0
        this.activeLayer := 0
        
        ; keydefs need to exist before we create layerdefs !
        this.CreateHotkeysForUsKbd()
        this.CreateModifiers()
        
        ; create the main layers
        this.activeLayer := this.CreateLayer(CLayout.MainNm, 0)
        
        ; 'shift' is a special case of layer access, it can be accessed by both l/rshift
        this.CreateLayer(CLayout.ShiftNm, 'shift')
        

    }

    ; create a hotkey foreach key scancode of US kbd
    ; create keydef for each, no output
    CreateHotkeysForUsKbd()
    {
        for idx, scanCode in usKbdScanCodes
        {    
            ; create hotkey
            keysc := 'sc' scanCode
            CreateHotKey(keysc)
            
            ; create keydef
            keydef := new CKeydef(keysc)
            this.AddKeydef(keydef)
        }
    }
    
    CreateModifiers()
    {
        this.CreateModifier('LShift', '+')
        this.CreateModifier('RShift', '+')

        this.CreateModifier('LCtrl', '^')
        this.CreateModifier('RCtrl', '^')

        this.CreateModifier('LAlt', '!')
        this.CreateModifier('RAlt', '!')

    }

    CreateModifier(key, type)
    {
        mod := this.modifiers.Create(key, type)
        keydef := this.GetKeydef(key)
        keydef.SetModifier(mod)
    }
    
    ; special case for 'Shift' : will match either lshift or rshift
    CreateLayer(layerName, accessKeyName)
    {
        keydef := this.GetKeydef(accessKeyName)
        
        layerdef := new CLayerDef(layerName, accessKeyName, keydef)
        this.layerdefs[layerName] := layerdef
        
        return layerdef
    }
    
    AddKeydef(keydef)
    {
        this.keydefs[keydef.keysc] := keydef
        return keydef
    }
    
    ; works with both 'sc999' or 'a' '5'
    GetKeydef(key)
    {
        if (!this.keydefs)
            return 0
            
        return this.keydefs[MakeKeySC(key)]
    }
    
    AddComposePairsList(initialKey, newComposePairs*)
    {
        this.composer.AddComposePairs(initialKey, newComposePairs*)
    }
    
    AddComposePairs(initialKey, pairsStr)
    {
        this.composer.AddComposePairs(initialKey, pairsStr)
    }
    
    SetComposeKey(key)
    {
        this.composeKey := MakeKeySC(key)
    }
    
    GetLayer(layerName)
    {
        for idx, layerdef in this.layerdefs
        {
            if (layerdef.Name == layerName)
                return layerdef
        }
        return 0
    }    
    
    IsLayerAccessKey(keydef)
    {
        for idx, layerdef in this.layerdefs
        {
            if (layerdef.IsAccessKey(keydef))
                return layerdef
        }
        return 0
    }
    
    IsActiveLayer(layerdef)
    {
        return layerdef.IsSameLayer(this.activeLayer)
    }
    
    SetActiveLayer(layerdef)
    {
        ; outputdebug('layout activelayer =  ' layerdef.Name)
        this.activeLayer := layerdef
    }

}

