
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
            keysc := 'sc' scanCode
            keydef := new CKeydef(keysc, true, false, keysc,0,0)
            ; keydef := new CKeydef(keysc, true, false, 0,0,0)
            this.AddKeyDef(keydef)
        }
    }

    AddKeyDef(keyDef)
    {
        this.keyDefs[keyDef.sc] := keyDef
    }
}