#include util.ahk

class Modifier
{
    _keyScan := ''  ; 'sc000'
    _keyName := ''
    _type := 0      ; one of !^+ (alt,control,shift)

    __New(key_, type_) 
    {
        this.KeyScan := FormatAsScancode(key_)
        this.KeyName := GetKeyName(key_)
        this._type := type_
    }
    
    KeyScan
    {
        get {
            return _keyScan
        }
    }
    KeyName
    {
        get {
            return _keyName
        }
    }
    IsShift 
    { 
        get {
            return this._type == '+'
        }
    }
    
    IsAlt 
    { 
        get {
            return this._type == '!'
        }
    }

    IsControl 
    { 
        get {
            return this._type == '^'
        }
    }
}


class Modifiers
{
    ; defined modifier keys, key saved as 'sc000'
    _modifiers := {}

    ; finds or create a Modifier object
    ; key = 'sc000'
    ; typeToCreate = one of !^+ (alt,control,shift)
    FindModifier(key, typeToCreate)
    {
        sc := FormatAsScancode(key)
        if (sc == 'sc000')
        {
            outputDebug('FindModifier, unknown key ' key)
            return 0
        }

        mod := this._modifierKeys[sc]
        if (!mod)
            mod := this._modifierKeys[sc] := new Modifier(sc, typeToCreate)
        
        return mod
    }

    CreateShiftMod(key)
    {
        return this.FindModifier(key, '+')
    }

    CreateControlMod(key)
    {
        return this.FindModifier(key, '^')
    }

    CreateAltMod(key)
    {
        return this.FindModifier(key, '!')
    }
}

