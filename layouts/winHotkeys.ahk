
;-- common hotkeys, on Win-XX --
; these will work only if we use
;  dontCreateHotkeys := [MakeKeySC("LWin")]
;  InitLayout(layers, dontCreateHotkeys)


;-- suspend / resume and turn off/on help image
#SuspendExempt true

LWin & PgUp::
    Suspend  "toggle"
    if (A_IsSuspended)
        DisplayHelpImageSuspendOn()
    else 
        DisplayHelpImageSuspendOff()
return

;-- stop script
LWin & End:: ExitApp

#SuspendExempt false



; toggle help img on/off
; LWin & PgDn::DisplayHelpImageToggle()

; close current active window
LWin & Delete:: WinClose "A"

; LWin-p qwerty
LWin & sc019:: Send 'philippe.quesnel'

; LWin-q qwerty
LWin & sc010::Send 'philippe.quesnel@gmail.com'


;## PQ hotkeys like these dont work with my layersv2c.ahk :-(
; #^sc019::Send 'philippe.quesnel'