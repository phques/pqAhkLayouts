;-- CLayer --
; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#include util.ahk

; holds keydefs for a layer
class CLayer
{
    __New(id, key)
    {
        this.id := id
        this.key := key
        this.keyDefs := {}

        this.CreateKeydefsForUsKbd()
    }

    ; create std keydef for each key scancode of US kbd, no output
    CreateKeydefsForUsKbd()
    {
        for idx, scanCode in usKbdScanCodes
        {    
            ; create keydef
            keysc := MakeKeySC("sc" . scanCode)

            ;# PQ debug, create real key
            ; keydef := new CKeydef(keysc, true, false, 0,0, 0)
            keydef := CKeydef.CreateStdKeydef(keysc, keysc)
            this.AddKeyDef(keydef)
        }
    }

    AddKeyDef(keyDef)
    {
        this.keyDefs[keyDef.sc] := keyDef
    }

    ; fromAndTos is a multiline string
    ; each line is a mapping: "a s d   y i e"
    ;  a:y s:i e:d
    AddMappings(fromAndTos, isShiftedLayer)
    {
        ; loop on Lines
        Loop Parse fromAndTos, '`r`n'
        {
            ; split line into array (separ = space)
            line := Trim(A_LoopField)
            line := RegExReplace(line, "\s{2,}", " ")
            fromAndToArray := StrSplit(line, A_Space)

            nbrOfMappings := fromAndToArray.Length() // 2
            if (nbrOfMappings * 2 != fromAndToArray.Length()) {
                msg := Format("AddMappings, From/to not same length !`n{}", line )
                MsgBox(msg)
                ExitApp
            }

            ; process this Line
            this.AddMappingsOne(fromAndToArray, isShiftedLayer)

        }
    }

    ; fromAndTo is a mapping in an array: ['a', 's', 'd',   'y', 'i', 'e'"]
    ;  a:y s:i e:d
    ; This method does the actual mapping creation
    ; handles dual mode keys
    AddMappingsOne(fromAndTo, isShiftedLayer)
    {
        nbrOfMappings := fromAndTo.Length() // 2

        Loop nbrOfMappings
        {
            from := fromAndTo[A_Index]
            to := fromAndTo[A_Index + nbrOfMappings]

            ; OutputDebug "AddMappingsOne " . from . " -> " . to

            ; leading @ indicates dual mode key (in 'from')
            ; (single tap generates tap value, held down is modifier)
            if (SubStr(from,1,1) == '@') {
                this.mapDual(from, to, isShiftedLayer)
                continue
            }

            ; Not dual mode..

            ; replace abbreviations with real value
            from := ApplyAbbrev(from)
            to := ApplyAbbrev(to)

            ; get 'from' keydef that will contain the output
            fromKeyDef := this.GetKeydef(from)

            ; add mapping
            if (fromKeyDef) {
                fromKeyDef.AddMapping(to, isShiftedLayer, false)
            }
            else {
                MsgBox "No keyDef for " from " / " GetKeyName(from)
                ExitApp
            }
        }
    }

    ; handles mapping for dualmode keys
    ; 'from' begins with '@', indiciating a dualMode key
    ; 'to' could be in the form "@^v" (holdDown is Ctrl modifier, tap outputs v)
    ;  or "@<+Q" for Left Shift modifier / Q tap val
    mapDual(from, to, isShiftedLayer)
    {
        OutputDebug "mapDual " from " " to

        from := SubStr(from,2) ; strip leading @
        from := ApplyAbbrev(from)
        dualHold := from               ; for now, assume from is modifier
        dualTap := ApplyAbbrev(to)     ; and to is tap val

        fromsc := MakeKeySC(from)
        fromKeydef := this.keyDefs[fromsc]

        ; is To in the form "@#q" ?
        toLen := StrLen(to)
        toPrefix := SubStr(to, 1, 1)
        if (toPrefix == "@" && toLen > 1) {
            ; "@^v"  : hold is ctrl (^), tap is v
            ; "@>+a" : hold is RShift, tap is a
            if (toLen < 3) {
                MsgBox("dual mode key " from ", 'to' is not valid (len < 3): " to)
                ExitApp
            }

            ; last char is tap val
            dualTap := SubStr(to, toLen, 1)  

            ; hold val
            dualHold := SubStr(to, 2, toLen-2) ; "#" / "<+"

            ; < > indicate left or right versino of modifier (as in Autohotkey keys)
            side := ""
            if (SubStr(dualHold, 1, 1) == "<") {
                side := "L"
                dualHold := SubStr(dualHold, 2)
            }
            if (SubStr(dualHold, 1, 1) == ">") {
                side := "R"
                dualHold := SubStr(dualHold, 2)
            }

            if (dualHold == "#")
                dualHold := side "Win"
            if (dualHold == "!")
                dualHold := side "Alt"
            if (dualHold == "^")
                dualHold := side "Control"
            if (dualHold == "+")
                dualHold := side "Shift"
        }

        ; create new dualMode modifier keydef if required
        ; if non dual mappings had already been created for this keysc they are lost here            
        if (!fromKeyDef || !fromKeyDef.isDual) {
            OutputDebug "creating dual modifier for " from
            fromKeyDef := CKeyDef.CreateDualModifier(from, dualHold, dualTap)
            this.keyDefs[fromsc] := fromKeyDef
        }
        else {
            ; or add this dual mode value
            fromKeyDef.AddMapping(dualTap, isShiftedLayer, true)
        }
    }

    ; get a keydef in this layer
    GetKeydef(key)
    {
        keysc := MakeKeySC(key)
        return this.keyDefs[keysc]
    }            
}