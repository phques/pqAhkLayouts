; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0
#include CExpectUpDownBase.ahk

; processing of compose + key1 + key2 => newout
; and deakey + key2 => newout
class CComposer extends CExpectUpDownBase
{
    composeKeyPairs := {}

    ; called on key down of compose key or deadkey
    ; we will wait for key up and following dn/up keys
    
    StartNew(waitingFor, isDeadKey := 0)
    {
        ; for a deadkey, the deajey itself is the compose key
        this.isDeadKey := isDeadKey
        
        ; wait for compose key up, 2 keys dn/up
        if (isDeadKey) ; dead key is its own 1st compose char
            this._init(waitingFor, 'u', 2)
        else
            this._init(waitingFor, 'u', 3)

        ; dead key is its own 1st compose char
        ; est of code can just work in 'compose mode' from here on 
        if (isDeadKey) 
            this.AddCompleteKey(waitingFor)
    }

    ; '`', [['a', 'à'], ['e', 'è']..]
    AddComposeKeyPairs(initialKey, composePairs*)
    {
        sc1 := FormatAsScancode(initialKey)
        
        pairs := this.composeKeyPairs[sc1]
        if (!pairs)
            this.composeKeyPairs[sc1] := pairs := {} 

        for idx, pair in composePairs
        {
            ; pairs[formatasscan 'a'] := 'à'
            pairs[FormatAsScancode(pair[1])] := pair[2]
        }
    }

    GetComposedResult(sc1, sc2)
    {
        if (this.composeKeyPairs[sc1])
            return this.composeKeyPairs[sc1][sc2]
        else
            return 0
    }
    
    ;--- internal methods
    
    OnCompleteKey(keydef, upDown, result)
    {
        outputdebug('Compose OnCompleteKey ' keydef.key)
        
        ; got a complete dn/up,
        ; on 1st complete, check for valid 1st compose key, cancel if !valid
         if (this.completedKeys.Length() == 2) 
         {
            key1 := this.completedKeys[2]
            if (!this.composeKeyPairs[key1.key])
            {
                ; not a valid compose key pair 1st key
                result.cancel := 1
                return result
            }
        }

        ; ok, everything fine
        ; wait for any key down / up
        this.waitingFor := 'any'
        this.waitingUpDown := 'd'
        return result
    }
    
    OnCompleteSequence(keydef, result)
    {
        outputdebug('Compose OnCompleteSequence ' keydef.key)
       
        ; check for valid compose pair, cancel if !valid
        key1 := this.completedKeys[2]
        key2 := this.completedKeys[3]
        out := this.GetComposedResult(key1.key, key2.key)
        if (out)
        {
            outputdebug('compose complete ' key1.key ' + ' key2.key ' => ' out)
            result.outputOnComplete := out
        }
        else
        {
            ; not a valid compose keypair
            outputdebug('compose cancelled, not valid pair ' key1.key ' + ' key2.key)
            result.cancel := 1
            result := this.OnCancel(keydef, result)
        }

        return result
    }
    
}



