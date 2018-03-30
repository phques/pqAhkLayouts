

class CLayout
{
    __New()
    {
        this.keydefs := {}  ; CKeydef
        this.modifiers := new CModifiers
        this.layerdefs := {} ; CLayerDef
        this.composer := new CComposer()
        this.composeKey := 0
        this.activeLayer := 0
        
        ; create the main layer !
        this.activeLayer := this.CreateLayer('main', 0)
        
    }

    ; create a hotkey foreach key scancode of US kbd
    ; also creates the keydefs w. output = keyname on main layer
    CreateHotkeysForUsKbd(initializeKeydefs)
    {
        for idx, scanCode in usKbdScanCodes
        {    
            keysc := 'sc' scanCode
            createHotKey(keysc)
            
            if (initializeKeydefs)
            {
                ; create a keydef
                keydef := new CKeydef(keysc)
                this.AddKeydef(keydef)
                
                ; set output on main = keyname 
                keydef.SetOutput('main', GetKeyName(keysc))
            }
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
    
    CreateLayer(name, accessKeyName1, accessKeyName2 := 0)
    {
        keydef1 := this.GetKeydef(accessKeyName1)
        keydef2 := this.GetKeydef(accessKeyName2)
        layerdef := new CLayerDef(name, keydef1, keydef2)
        this.layerdefs[name] := layerdef
        return layerdef
    }
    
    AddKeydef(keydef)
    {
        this.keydefs[keydef.keysc] := keydef
        return keydef
    }
    
    GetKeydef(key)
    {
        if (!layout || !layout.keydefs)
            return 0
        return layout.keydefs[MakeKeySC(key)]
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

