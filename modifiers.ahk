; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#include util.ahk

class CModifier
{
    KeySC := ''  ; 'sc000'
    KeyName := ''
    ; IsShift | IsControl | IsAlt set in __New : 
    Type := '' ; cf new
    IsDualMode := 0

    ; type is one of +^! which will set IsShift | IsControl | IsAlt
    ; or returns 0
    __New(key, type := '') 
    {
        this.KeySC := KeySC(key)
        this.KeyName := GetKeyName(key)

        this.Type := type ; save type
        if (type == '+')
            this.IsShift := 1
        else if (type == '!')
            this.IsAlt := 1
        else if (type == '^')
            this.IsControl := 1
        else
            return 0        
    }
    
    SetDualMode()
    {
        IsDualMode := 1
    }
}


class CModifiers
{
    ; defined modifier keys, key saved as 'sc000'
    _modifiers := {}

    ; finds 
    ; key = 'sc000'
    Find(key)
    {
        sc := KeySC(key)
        mod := this._modifierKeys[sc]
        return mod
    }

    ; create a CModifier object
    ; key = 'sc000'
    ; typeToCreate = one of !^+ (alt,control,shift)
    Create(key, typeToCreate := '')
    {
        sc := KeySC(key)
        if (!sc)
            return 0

        mod := this._modifierKeys[sc] := new CModifier(sc, typeToCreate)
        return mod
    }

    CreateShiftMod(key)
    {
        return this.Create(key, '+')
    }

    CreateControlMod(key)
    {
        return this.Create(key, '^')
    }

    CreateAltMod(key)
    {
        return this.Create(key, '!')
    }
}

