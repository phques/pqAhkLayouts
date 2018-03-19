#include util.ahk

; modifierKeys['sc999']
global modifierKeys := {}

class Modifier
{
    _keyScan := '' ; 'sc000'
    _keyName := ''
    _isShift := 0
    _isAlt := 0
    _isControl := 0

    __New(keyScan_) 
    {
        this.KeyScan := keyScan_
        this.KeyName := GetKeyName(keyScan_)
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
            return this._isShift
        }
    }
    
    IsAlt 
    { 
        get {
            return this._isAlt
        }
    }

    IsControl 
    { 
        get {
            return this._isControl
        }
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
        mod := modifierKeys[sc] := new Modifier(sc)
    
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
        mod.IsControl := 1
}

DefineAltKey(key)
{
    mod := FindModifier(key)
    if (mod)
        mod.IsAlt := 1
}


_CreateControl(keyScan_)
{
    mod := new Modifier(keyScan_)
    mod._isControl := 1
    return mod
}

Modifier.CreateControl := Func('_CreateControl')

;mod := Modifier.CreateControl('sc123')
fn := Func('_CreateControl')
outputdebug('fn ' fn)

; mod := fn('sc123')
; outputdebug('s ' mod.KeyScan)
; outputdebug('n ' mod.KeyName)
; outputdebug(mod.IsShift)
; outputdebug(mod.IsAlt)
; outputdebug(mod.IsControl)


