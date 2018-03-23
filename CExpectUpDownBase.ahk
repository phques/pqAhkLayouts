; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0


; to handle deadkeys, compose, dual mode modifier
; we must get uninterrupted dn/up of same key (1 or multiple *)
class CExpectUpDownBase
{
    class Result
    {
        __New(eatKey, cancel, complete := 0, outputOnComplete := 0)
        {
            this.eatKey := eatKey
            this.cancel := cancel
            this.outputOnComplete := outputOnComplete
        }
    }
    
    ;--------
    
    waitingFor := ''
    waitingUpDown := ''      ; waiting for 'u' 'd'    
    nbrRequired := 0
    completedKeys := []
    
    ;-----
    
    _init(waitingFor, upDown, nbrRequired)
    {
        this.waitingFor := waitingFor
        this.waitingUpDown := upDown
        this.nbrRequired := nbrRequired
        this.completedKeys := []
    }
    
    ; base methods

    AddCompleteKey(keydef)
    {
        this.completedKeys.push(keydef)
    }
    
    Reset()
    {
        this._init(0,0,0)
    }
    
    IsWaiting 
    {
        get {
            if (this.waitingFor)
                return 1
            else
                return 0
        }
    }

    OnKey(keydef, upDown)
    {
        ; outputdebug('OnKey ' keydef.key ' ' upDown)
        
        if (this.waitingUpDown == 'u')
        {
            ; correct key?
            if (this.waitingFor != keydef.key)
            {
                ; didn't get expected key, eat & cancel 
                res := new CExpectUpDownBase.Result(1,1)
                res := this.OnCancel(keydef, upDown, res)
                this.Reset()
            }
            else
            {
                ; got expected key up or down, process further
                
                ; res := this.onExpectKeyUp(keydef, upDown)
                
                ; correct key, down
                if (upDown == 'd')
                {
                    ; eat successive key down
                    res := new CExpectUpDownBase.Result(1,0)
                }
                else ; recvd key up
                {
                    ; same key, got key up, complete !
                    this.AddCompleteKey(keydef)
                    res := new CExpectUpDownBase.Result(1,0)
                    
                    ; call OnCompleteKey
                    res := this.OnCompleteKey(keydef, upDown, res)
                    if (res.cancel)
                    {
                        res := this.OnCancel(keydef, upDown, res)
                    }
                    else
                    {
                        ; check for completed sequence
                        if (this.completedKeys.Length() == this.nbrRequired)
                        {
                            res.completed := 1 ; we are done, stop this one
                            res := this.OnCompleteSequence(keydef, res)
                            this.Reset()
                        }
                    }
                }                
            }
        }
        else ; expect key down 
        {
            if (upDown == 'u' || (this.waitingFor != 'any' && this.waitingFor != keydef.key))
            {
                ; didn't get expected key evt, eat & cancel 
                res := new CExpectUpDownBase.Result(1,1)
                res := this.OnCancel(keydef, upDown, res)
                this.Reset()
            }
            else
            {
                ; got expected key down, now expect key up of same key
                outputdebug('got down ' keydef.key ', wait for up')
                this.waitingFor := keydef.key
                this.waitingUpDown := 'u'
                res := new CExpectUpDownBase.Result(1, 0)
            }
        }
        
        return res
    }

    
    ;-- user, overridables, default does nothing--
    
    ; derived ones ccan have different signature
    StartNew(waitingFor, upDown, nbrRequired)
    {
        this._init(waitingFor, upDown, nbrRequired)
    }

    OnCompleteKey(keydef, upDown, result)
    {
        outputdebug('OnCompleteKey ' keydef.key)
        ; do any extra action on key complete
        ; ? possibly modify result
        return result
    }
    
    OnCancel(keydef, upDown, result)
    {
        outputdebug('oncancel ' keydef.key)
        ; do any extra action on cancel
        ; ? possibly modify result
        return result
    }

    OnCompleteSequence(keydef, result)
    {
        outputdebug('OnCompleteSequence ' keydef.key)
        ; do any extra action on key complete
        ; ? possibly modify result
        return result
    }
    
}


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
            ; pairs['a'] := 'à'
            ; but in sc000 format
            pairs[FormatAsScancode(pair[1])] := FormatAsScancode(pair[2])
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
        key1 := this.completedKeys[2].key
        key2 := this.completedKeys[3].key
        out := this.GetComposedResult(key1.key, key2.key)
        if (out)
        {
            outputdebug('compose complete ' key1.key ' + ' key2.key)
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



