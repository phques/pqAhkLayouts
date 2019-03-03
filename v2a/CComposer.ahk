; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#include waitResult.ahk

; todo, we don't use CExpectUpDownBase anymore

; processing of compose + key1 + key2 => newout
; and deakey + key2 => newout
class CComposer ; extends CExpectUpDownBase
{
    composePairs := {}

   
    ; called on key down of compose key or deadkey
    ; we will wait for key up and following dn/up keys
    
    StartNew(waitingFor, isDeadKey := 0)
    {
        ; wait for compose key up  + 2 keys dn/up
        ; (dead key is its own compose key, so still 3 keys)
        this.init(waitingFor, 'u', 3)

        ; dead key is its own 1st compose char
        ; rest of code can just work in 'compose mode' from here on 
        if (isDeadKey) 
            this.AddCompleteKey(waitingFor)
    }
    
    init(waitingFor, upDown, nbrRequired, dualModeOutput := 0)
    {
        this.waitingFor := waitingFor
        this.waitingUpDown := upDown
        this.nbrRequired := nbrRequired
        this.completedKeys := []
        this.dualModeOutput := dualModeOutput
    }

    ; '`', [['a', 'à'], ['e', 'è']..]
    AddComposePairsList(initialKey, newComposePairs*)
    {
        initKeyOrd := Ord(initialKey)
        pairs := this.composePairs[initKeyOrd]
        if (!pairs)
            this.composePairs[initKeyOrd] := pairs := {} 

        for idx, pair in newComposePairs
        {
            ; pairs['a'] := 'à'
            ; indexing is NOT case sensitive, so a['b'] is same as a['B']
            from := Ord(pair[1])
            pairs[from] := pair[2]
        }
    }
    
    ; AddComposePairs('^', 'aâ eê iî')
    AddComposePairs(initialKey, pairsStr)
    {
        initKeyOrd := Ord(initialKey)
        pairs := this.composePairs[initKeyOrd]
        if (!pairs)
            this.composePairs[initKeyOrd] := pairs := {} 

        Loop Parse pairsStr, ' '
        {
            from := SubStr(A_LoopField,1,1)
            to   := SubStr(A_LoopField,2,1)
            
            ; pairs['a'] := 'à'
            ; indexing is NOT case sensitive, so a['b'] is same as a['B']
            from := Ord(from)
            pairs[from] := to
        }
    }
    
    ;--- internal methods

    GetComposedResult(char1, char2)
    {
        if (this.composePairs[Ord(char1)])
            return this.composePairs[Ord(char1)][Ord(char2)]
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
            if (!this.composePairs[Ord(key1.currOutput)])
            {
                ; not a valid compose key pair 1st key
                outputdebug(key1.currOutput ' not a valid compose key pair 1st key')
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
        out := this.GetComposedResult(key1.currOutput, key2.currOutput)
        if (out)
        {
            result.outputOnComplete := out
        }
        else
        {
            ; not a valid compose keypair
            OutputDebug('ccomposer, not a valid keypair ' key1.keyName ' ' key2.keyName)
            OutputDebug(key1.currOutput ' ' key2.currOutput)
            result.cancel := 1
            result := this.OnCancel(keydef, 'u', result)
        }

        return result
    }
    
}


