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
            ;#PQ debug, create real key
            ; keydef := new CKeydef(keysc, true, false, keysc,0,0)
            keydef := CreateStdKeydef(keysc, keysc)
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
            Loop nbrOfMappings
            {
                f := fromAndTo[A_Index]
                t := fromAndTo[A_Index + nbrOfMappings]

                ; get 'from' keydef that will contain the output
                fromKeyDef := this.keyDefs[MakeKeySC(f)]
                if (!fromKeyDef) {
                    MsgBox "No keyDef for " f " / " GetKeyName(f)
                    ExitApp
                }

                fromKeyDef.AddMapping(t, isShiftedLayer)
            }
        }

    }
}