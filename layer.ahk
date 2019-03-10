;-- CLayer --

#include util.ahk


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
            ; split line into into array (separ = space)
            line := Trim(A_LoopField)
            line := RegExReplace(line, "\s{2,}", " ")
            fromAndTo := StrSplit(line, A_Space)

            nbrOfMappings := fromAndTo.Length() // 2
            if (nbrOfMappings * 2 != fromAndTo.Length()) {
                msg := Format("AddMappings, From/to not same length !`n{}", line )
                MsgBox(msg)
                ExitApp
            }

            ; process this Line
            this.AddMappingsOne(fromAndTo, isShiftedLayer)

        }
    }

    ; fromAndTo is a mapping: ['a', 's', 'd',   'y', 'i', 'e'"]
    ;  a:y s:i e:d
    AddMappingsOne(fromAndTo, isShiftedLayer)
    {
        nbrOfMappings := fromAndTo.Length() // 2

        Loop nbrOfMappings
        {
            from := fromAndTo[A_Index]
            to := fromAndTo[A_Index + nbrOfMappings]

            ; OutputDebug "AddMappingsOne " . from . " -> " . to

            ; leading @ indicates dual mode key (in 'from')
            ; (single click generates 'to' key, held down is modifier)
            if (SubStr(from,1,1) == '@') {
                this.mapDual(from, to, isShiftedLayer)
                continue
            }

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

    ; from begins with '@', indiciating a dualMode key
    mapDual(from, to, isShiftedLayer)
    {
        OutputDebug "mapDual " from " " to

        from := SubStr(from,2) ; strip leading @
        from := ApplyAbbrev(from)
        dualHold := from                    ; for now, assume from is modifier
        dualTap := ApplyAbbrev(to)     ; and to is tap val

        fromsc := MakeKeySC(from)
        fromKeydef := this.keyDefs[fromsc]

        toLen := StrLen(to)
        toPrefix := SubStr(to, 1, 1)
        if (toPrefix == "@" && toLen > 1) {
            ; "@^v"  : hold is ctrl (^), tap is v
            ; "@>+a" : hold is RShift, tap is a
            if (toLen < 3) {
                MsgBox("dual mode key " from ", 'to' is not valid (len < 3): " to)
                ExitApp
            }

            ; tap val
            dualTap := SubStr(to, toLen, 1)  ; last char is tap val 

            ; hold val
            dualHold := SubStr(to, 2, toLen-2) ; "<+"
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
        ; note that if mappings had already been created for this keysc they will be lost here            
        if (!fromKeyDef || !fromKeyDef.isDual) {
            OutputDebug "creating dual modifier for " from
            fromKeyDef := CKeyDef.CreateDualModifier(from, dualHold, dualTap)
            this.keyDefs[fromsc] := fromKeyDef
        }
        else {
            fromKeyDef.AddMapping(dualTap, isShiftedLayer, true)
        }
    }


    GetKeydef(key)
    {
        keysc := MakeKeySC(key)
        return this.keyDefs[keysc]
    }            
}