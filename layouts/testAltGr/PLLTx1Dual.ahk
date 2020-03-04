; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

; small example of use of dualKey.ahk

; create dualMode key defs
#include ../../dualMode/dualKey.ahk
global spaceDual :=  CDualKey.CreateNewDual("Ralt", "w")
; global lctrlDual :=  CDualKey.CreateNewDual("LControl", "escape", "^")
; global lshDual :=  CDualKey.CreateNewDual("LShift", "k", "+")

;-------------
;; ## end of code, hotkeys follow

#include ../../dualMode/dualHook.ahk

; to avoid dup key errors vs dualHook:
#If True

; restore normal win or alt + space functions !
; #space::SendInput "{blind}#{space}"
; !space::SendInput "{blind}!{space}"

; dual mode space
*space::	spaceDual.OnDualDown()
*space Up:: spaceDual.OnDualUp() 

>!d::	Send '-'

; disable normal RAlt
; *RAlt::

; win-end hotkey to stop script
#End::
  OutputDebug ëxiting script
  exitapp
return


#If
