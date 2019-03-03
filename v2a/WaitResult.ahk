; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0


class WaitResult
{
    __New(eatKey, cancel, outputOnComplete := 0)
    {
        this.eatKey := eatKey
        this.cancel := cancel
        this.outputOnComplete := outputOnComplete
        this.completed := 0
    }
}
