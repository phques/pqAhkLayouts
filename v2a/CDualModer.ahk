; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#include waitResult.ahk


; called on key down of a dual mode modifier
; we will wait for key up 
class CDualModer 
{
    __New(waitingFor, dualModeOutput)
    {
        ; wait for up of same modifier, if not interrupted, output alternative char
        ; else it will just be cancelled
        this.waitingFor := waitingFor
        this.dualModeOutput := dualModeOutput
    }

    OnKeyEvt(keydef, upDown)
    {
        if (this.waitingFor == keydef.keysc)
        {
            if (upDown == 'd')
            {
                ; skip auto repeat of key
                ; eat successive key down
                OutputDebug('dmod, eat repeat ' keydef.keyName)                
                res := new WaitResult(1,0)
                return res
            }
            else
            {
                ; successful up/down of key,output alternate char
                ; DONT eat modifier up
                OutputDebug('dmod, successful ' keydef.keyName)                
                res := new WaitResult(0,0, this.dualModeOutput)
                res.completed := 1
                return res
            }
        }
        else ; not same key
        {
            if (upDown == 'd')
            {
                ; did not get up/down, cancel
                OutputDebug('dmod, cancle <> key dn ' keydef.keyName)                
                res := new WaitResult(0, 1)
                return res
            }            
            else
            {
                ;  ignore 'up' of other keys,
                ;  it happens when doing "rolls"
                res := new WaitResult(0, 0)
                return res
            }
        }
    }
}
