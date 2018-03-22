; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0


; to handle deadkeys, compose, dual mode modifier
; we must get uninterrupted dn/up of same key (1 or multiple *)
class CExpectUpDownBase
{
    class Result
    {
        __New(eatKey, cancel)
        {
            this.eatKey := eatKey
            this.cancel := cancel
        }
    }
    
    ;--------
    
    waitingFor := ''
    waitingUpDown := ''      ; waiting for 'u' 'd'    
    nbrRequired := 0
    completedKeys := []
    completed := 0
    
    ;-----
    
    __New(waitingFor, upDown, nbrRequired)
    {
        this._init(waitingFor, upDown, nbrRequired)
    }
    
    _init(waitingFor, upDown, nbrRequired)
    {
        this.waitingFor := waitingFor
        this.waitingUpDown := upDown
        this.nbrRequired := nbrRequired
        this.completedKeys := []
        this.completed := 0
    }

    ; base methods
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
                    this.completedKeys.push(keydef)
                    res := new CExpectUpDownBase.Result(1,0)
                    
                    ; call OnCompleteKey
                    res := this.OnCompleteKey(keydef, upDown, res)
                    if (!res.cancel)
                    {
                        ; check for completed sequence
                        if (this.completedKeys.Length() == this.nbrRequired)
                        {
                            res.completed := 1 ; we are done, stop this one
                            res := this.OnCompleteSequence(keydef, res)
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
                res := this.OnCancel(keydef, upDown, res)
                res := new CExpectUpDownBase.Result(1,1)
            }
            else
            {
                ; got expected key down, now expect key up of same key
                outputdebug('got down ' keydef.key ', wait for up')
                this.waitingFor := keydef.key
                this.waitingUpDown := 'u'
                res := new CExpectUpDownBase.Result(0,0)
            }
        }
        
        return res
    }

    
    ;-- user, overridables, default does nothing--
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


class CExpectCompose extends CExpectUpDownBase
{
    __New(waitingFor)
    {
        ;;?? how to call base's new ??
        ; wait for compose key up, 2 keys dn/up
        this._init(waitingFor, 'u', 3)
    }

    OnCompleteKey(keydef, upDown, result)
    {
        outputdebug('Compose OnCompleteKey ' keydef.key)
        ; got a complete dn/up,
        ; wait for any key down, will wait for the same key up after
        ;##pq todo: on 1st complete, check for valid 1st compose key, cancel if !valid
        this.waitingFor := 'any'
        this.waitingUpDown := 'd'
        return result
    }
    
    OnCompleteSequence(keydef, result)
    {
        ;##pq todo: check for valid compose keys, cancel if !valid
        outputdebug('compose complete ' this.completedKeys[2].key ' + ' this.completedKeys[3].key)
        return result
    }
}

