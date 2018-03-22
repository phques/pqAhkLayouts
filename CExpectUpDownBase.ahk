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
    upDown := ''      ; waiting for 'u' 'd'    
    nbrRequired := 0
    completed := []
    
    ;-----
    
    __New(waitingFor, upDown, nbrRequired)
    {
        this.waitingFor := waitingFor
        this.upDown := upDown
        this.nbrRequired := nbrRequired
    }

    ; base methods
    OnKey(keydef, upDown)
    {
        outputdebug('expect updn OnKey ' keydef.key ' ' upDown)
        
        ; didn't get expected key, eat & cancel
        if (this.waitingFor != keydef.key)
        {
            res := new CExpectUpDownBase.Result(1,1)
            return this.OnCancel(keydef, upDown, res)
        }
        
        ; same key, skip succesive key down
        if (this.upDown == 'u' && upDown == 'd')
        {
            outputdebug('CExpectUpDn OnKey skip extra dn ' keydef.key)
            res := new CExpectUpDownBase.Result(1,0)
            return res
        }
        
        ; same key,got key up, complete !
        if (this.upDown == 'u' && upDown == 'u')
        {
            this.completed.push(keydef)
            res := new CExpectUpDownBase.Result(1,0)
            res := this.OnCompleteKey(keydef, upDown, res)
            if (res.cancel)
                return res

            ; check for completed sequence
            if (this.completed.Length() == this.nbrRequired)
            {
                res.cancel := 1 ; we are done, stop this one
                return this.OnCompleteSequence(keydef, res)
            }
        }
        
        ;;pq todo expect 'd' ! (on following compose / deadkey keys
        
        ;;pq debug
        outputdebug('expect onkey fall through')
            res := new CExpectUpDownBase.Result(1,1)
            return res
    }
    
    ;-- user, overridables--
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
