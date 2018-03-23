; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#include util.ahk

class Modifier
{
    KeyScan := ''  ; 'sc000'
    KeyName := ''
    ; IsShift | IsControl | IsAlt set in __New : 

    ; type is one of +^! which will set IsShift | IsControl | IsAlt
    ; or returns 0
    __New(key, type) 
    {
        this.KeyScan := FormatAsScancode(key)
        this.KeyName := GetKeyName(key)

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


class Modifiers
{
    ; defined modifier keys, key saved as 'sc000'
    _modifiers := {}

    ; finds or create a Modifier object
    ; key = 'sc000'
    ; typeToCreate = one of !^+ (alt,control,shift)
    Find(key, typeToCreate := 0)
    {
        sc := FormatAsScancode(key)
        if (sc == 'sc000')
        {
            outputDebug('Find, unknown key ' key)
            return 0
        }

        mod := this._modifierKeys[sc]
        if (!mod)
            mod := this._modifierKeys[sc] := new Modifier(sc, typeToCreate)
        
        return mod
    }

    CreateShiftMod(key)
    {
        return this.Find(key, '+')
    }

    CreateControlMod(key)
    {
        return this.Find(key, '^')
    }

    CreateAltMod(key)
    {
        return this.Find(key, '!')
    }
}

