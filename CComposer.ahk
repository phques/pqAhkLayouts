; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0
#include CExpectUpDownBase.ahk

; processing of compose + key1 + key2 => newout
; and deakey + key2 => newout
class CComposer extends CExpectUpDownBase
{
    composePairs := {}

   
    ; called on key down of compose key or deadkey
    ; we will wait for key up and following dn/up keys
    
    StartNew(waitingFor, isDeadKey := 0)
    {
        ; wait for compose key up  + 2 keys dn/up
        ; (dead key is its own compose key, so still 3 keys)
        this._init(waitingFor, 'u', 3)

        ; dead key is its own 1st compose char
        ; rest of code can just work in 'compose mode' from here on 
        if (isDeadKey) 
            this.AddCompleteKey(waitingFor)
    }
    

    ; '`', [['a', 'à'], ['e', 'è']..]
    AddComposePairsList(initialKey, newComposePairs*)
    {
        pairs := this.composePairs[initialKey]
        if (!pairs)
            this.composePairs[initialKey] := pairs := {} 

        for idx, pair in newComposePairs
        {
            ; pairs['a'] := 'à'
            pairs[pair[1]] := pair[2]
        }
    }
    
    ; AddComposePairs('^', 'aâ eê iî')
    AddComposePairs(initialKey, pairsStr)
    {
        pairs := this.composePairs[initialKey]
        if (!pairs)
            this.composePairs[initialKey] := pairs := {} 

        Loop Parse pairsStr, ' '
        {
            from := SubStr(A_LoopField,1,1)
            to   := SubStr(A_LoopField,2,1)
            
            ; pairs['a'] := 'à'
            pairs[from] := to
        }
    }
    
    ;--- internal methods

    GetComposedResult(char1, char2)
    {
        if (this.composePairs[char1])
            return this.composePairs[char1][char2]
        else
            return 0
    }
    
    OnCompleteKey(keydef, upDown, result)
    {
        ; got a complete dn/up,
        ; on 1st complete, check for valid 1st compose key, cancel if !valid
         if (this.completedKeys.Length() == 2) 
         {
            key1 := this.completedKeys[2]
            if (!this.composePairs[key1.char])
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
        ; check for valid compose pair, cancel if !valid
        key1 := this.completedKeys[2]
        key2 := this.completedKeys[3]
        out := this.GetComposedResult(key1.char, key2.char)
        if (out)
        {
            result.outputOnComplete := out
        }
        else
        {
            ; not a valid compose keypair
            result.cancel := 1
            result := this.OnCancel(keydef, result)
        }

        return result
    }
    
}


