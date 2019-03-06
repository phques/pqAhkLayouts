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
                msg := Format("AddMappingsOne, From/to not same length !`n{}", line )
                MsgBox(msg)
                ExitApp
            }

            ; process this Line
            this.AddMappingsOne(fromAndTo, isShiftedLayer)

        }
    }

    ; fromAndTo is a mapping: "a s d   y i e"
    ;  a:y s:i e:d
    AddMappingsOne(fromAndTo, isShiftedLayer)
    {
        nbrOfMappings := fromAndTo.Length() // 2

        Loop nbrOfMappings
        {
            from := fromAndTo[A_Index]
            to := fromAndTo[A_Index + nbrOfMappings]

            ; TODO check for dual mode modifier prefix @
            ; create new keydef for this !
            
            ; leading @ indicates dual mode key (in 'from')
            ; (single click generates 'to' key, held down is modifier)
            isDualModeKey := 0
            if (SubStr(from,1,1) == '@') {
                from := SubStr(from,2) ; strip @
                isDualModeKey := 1
            }

            ; replace abbreviations with real value
            if (keyAbbrevs[from])
                from := keyAbbrevs[from]

            ; get 'from' keydef that will contain the output
            keysc := MakeKeySC(from)

            ; create new dualMode modifier keydef if required
            if (isDualModeKey) {
                this.keyDefs[keysc] := CKeyDef.CreateEmptyDualModifier(from)
            }

            ; add mapping
            fromKeyDef := this.keyDefs[keysc]
            if (fromKeyDef) {
                fromKeyDef.AddMapping(to, isShiftedLayer)
            }
            else {
                MsgBox "No keyDef for " from " / " GetKeyName(from)
                ExitApp
            }

        }
    }            

}