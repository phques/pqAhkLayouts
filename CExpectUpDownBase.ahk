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
            outputdebug('oops calling on cancel')
                    
                        res := this.OnCancel(keydef, upDown, res)
                    }
                    else
                    {
                        ; check for completed sequence
                        if (this.completedKeys.Length() == this.nbrRequired)
                        {
            outputdebug('oops calling on complete')
                        
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
outputdebug('oops expect down')
        
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


class CDualModer extends CExpectUpDownBase
{
    ; called on key down of a dual mode modifier
    ; we will wait for key up 
   
    __New(waitingFor)
    {
        ; wait for up of same modifier, if not interrupted, output alternative char
        ; else it will just be cancelled
        this._init(waitingFor, 'u', 1)
        
    }

    OnCancel(keydef, upDown, result)
    {
        outputdebug('oncancel ' keydef.key)
        ; do any extra action on cancel
        ; ? possibly modify result
        result.eatKey := 0 ; DONT eat modifier up
        return result
    }

    OnCompleteSequence(keydef, result)
    {
        outputdebug('CDualModer.OnCompleteSequence ' keydef.char)
        
        ; successfully recvd uninterrupted dn/up of this dual mode modifier
        ; output its alternative char
        result.outputOnComplete := keydef.char
        result.eatKey := 0 ; DONT eat modifier up
        return result
    }
}
