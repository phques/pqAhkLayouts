; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

global keyAbbrevs := {
	"SP" : "Space", "CL" : "CapsLock", "CR": "Enter", "BS": "BackSpace",
	"LSh" : "LShift", "RSh" : "RShift", "SH" : "Shift",
	"LCt" : "LControl", "RCt" : "RControl", "Ctrl": "Control", 
}

; key => 'sc000'
MakeKeySC(key)
{
    sc := GetKeySC(key)
    if (!sc)
        return 0
        
	return Format("sc{:03x}", sc)
}

; replace abbreviations with real value
ApplyAbbrev(key)
{
    if (keyAbbrevs[key])
        return keyAbbrevs[key]
    return key
}
