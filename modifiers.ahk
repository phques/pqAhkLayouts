
; modifierKeys['sc999']
global modifierKeys := {}

class Modifier
{
    _isShift := 0
    _isAlt := 0
    _isControl := 0
    
    IsShift 
    { 
        set {
            return this._isShift := 1 
        }
        get {
            return this._isShift
        }
    }
    SetIsControl() 
    { 
        this.isControl := 1 
    }
    SetIsAlt() 
    { 
        this.isAlt := 1 
    }
}


FindModifier(key)
{
    sc := FormatAsScancode(key)
    if (sc == 'sc000')
    {
        msgBox('DefineShiftKey, unkown key ' key)
        return 0
    }

    mod := modifierKeys[sc]
    if (!mod)
        mod := modifierKeys[sc] := new Modifier
    
    return mod
}

DefineShiftKey(key)
{
    mod := FindModifier(key)
    if (mod)
        mod.IsShift := 1
}

DefineControlKey(key)
{
    mod := FindModifier(key)
    if (mod)
        mod.SetIsControl()
}

DefineAltKey(key)
{
    mod := FindModifier(key)
    if (mod)
        mod.SetIsAlt()
}

