

class CLayout
{
    
    __New()
    {
        this.keydefs := {}  ; CKeydef
        this.layerdefs := {} ; CLayerDef
        this.modifiers := new CModifiers
        this.composer := new CComposer()
        this.composeKey := 0
        this.activeLayer := 0
        
        ; keydefs need to exist before we create layerdefs !
        this.CreateKeydefsForUsKbd()
        this.CreateHotkeysForUsKbd()
        this.CreateModifiers()
        
        ; create the main layers
        this.activeLayer := this.CreateLayer(CLayerDef.MainNm, 0)
        
        ; 'shift' is a special case of layer access, it can be accessed by both l/rshift
        this.CreateLayer(CLayerDef.MainNm . CLayerDef.ShiftSuffix, 'shift')
        

    }

    ; create keydef for each key scancode of US kbd, no output
    CreateKeydefsForUsKbd()
    {
        for idx, scanCode in usKbdScanCodes
        {    
            ; create keydef
            keysc := 'sc' scanCode
            keydef := new CKeydef(keysc)
            this.AddKeydef(keydef)
        }
    }
    
    ; create a hotkey foreach key scancode of US kbd
    CreateHotkeysForUsKbd()
    {
        for idx, scanCode in usKbdScanCodes
        {    
            ; create hotkey
            keysc := 'sc' scanCode
            CreateHotKey(keysc)
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

    ; add new key mappings for a layer
    ; when 'fromKey' is hit on this layer, will output 'toKey'
    ; _from/_to are space separated
    ; noKeyChar indicates an empty spot in 'to'
    AddMappings(layerName, isShiftedLayer, _from, _to, noKeyChar := '')
    {
        ; get layer def
        actualLayerName := layerName
        if (isShiftedLayer)
            actualLayerName .= CLayerDef.ShiftSuffix

        layerDef := this.GetLayer(actualLayerName)
        if (!layerDef) {
            MsgBox "AddMappings, layer " actualLayerName " does not exist"
            ExitApp
        }

        ; trim pre/post spaces and compress multi spaces into one
        from := Trim(_from)
        from := RegExReplace(from, "\s{2,}", " ")

        to := Trim(_to)
        to := RegExReplace(to, "\s{2,}", " ")

        ; split from / to into into array (separ = space)
        froms := StrSplit(from, A_Space)
        tos := StrSplit(to, A_Space)

        if (froms.Length() != tos.Length()) 
        {
            msg := Format("AddMappings, From/to not same length {} {}!`n{} `n{}"
                            , froms.Length(), tos.Length()
                            ; , _from, _to, )
                            , SubStr(_from, 1, 16), SubStr(_to, 1, 16))
            MsgBox(msg)
            ExitApp
        }

        ; loop on froms / tos, create mappings in layer
        Loop froms.Length()
        {
            f := froms[A_Index]
            t := tos[A_Index]
            
            ; nothing to see here, move along
            if (t == noKeyChar)
                continue
                
            if (f == 'SP')
                f := 'Space'
            
            if (t == 'SP')
                t := 'Space'
                
           
            ; leading @ indicates dual mode key (in 'from')
            ; (single click generates 'to' key, held down is modifier)
            isDualModeKey := 0
            if (SubStr(f,1,1) == '@') {
                f := SubStr(f,2) ; strip @
                isDualModeKey := 1
            }
        
            ; flag indicating if the char to output is shifted (ie ? is Shift-/)
            isShifted := 0
            shiftedChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
            shiftedChars .='~!@#$`%^&*()_+{}|:"<>?'
            if (InStr(shiftedChars, t)) ; splitTo.key
                isShifted := 1
                
            keydef := this.GetKeydef(f)
            if (!keydef)
            {
                OutputDebug('AddMappings cannot find key ' f)
                continue
            }
            
            keydef.isDualMode := isDualModeKey
            keydef.isShifted := isShifted
            keydef.output[actualLayerName] := t
            
        }
    }
    
}

