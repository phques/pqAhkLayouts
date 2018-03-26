; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#include util.ahk

class CModifier
{
    KeyScan := ''  ; 'sc000'
    KeyName := ''
    DualModeOut := ''    ; what this outputs when not a modifier
    ; IsShift | IsControl | IsAlt set in __New : 
    Type := '' ; cf new

    ; type is one of +^! which will set IsShift | IsControl | IsAlt
    ; or returns 0
    __New(key, type, dualModeOut := '') 
    {
        this.KeyScan := FormatAsScancode(key)
        this.KeyName := GetKeyName(key)
        this.DualModeOut := dualModeOut

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
    
}


class CModifiers
{
    ; defined modifier keys, key saved as 'sc000'
    _modifiers := {}

    ; finds 
    ; key = 'sc000'
    Find(key)
    {
        sc := FormatAsScancode(key)
        mod := this._modifierKeys[sc]
        return mod
    }

    ; create a CModifier object
    ; key = 'sc000'
    ; typeToCreate = one of !^+ (alt,control,shift)
    Create(key, typeToCreate, dualModeOut := '')
    {
        sc := FormatAsScancode(key)
        if (!sc)
            return 0

        mod := this._modifierKeys[sc] := new CModifier(sc, typeToCreate, dualModeOut)
        return mod
    }

    CreateShiftMod(key, dualModeOut := 0)
    {
        return this.Create(key, '+', dualModeOut)
    }

    CreateControlMod(key, dualModeOut)
    {
        return this.Create(key, '^', dualModeOut)
    }

    CreateAltMod(key, dualModeOut)
    {
        return this.Create(key, '!', dualModeOut)
    }
}

