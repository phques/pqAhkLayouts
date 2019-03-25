; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

; small example of use of dualKey.ahk

; create dualMode key defs
#include dualKey.ahk
global spaceDual :=  CDualKey.CreateNewDual("Ralt", "space")
global lctrlDual :=  CDualKey.CreateNewDual("LControl", "escape", "^")
global lshDual :=  CDualKey.CreateNewDual("LShift", "k", "+")

;-------------
;; ## end of code, hotkeys follow

#include dualHook.ahk

; to avoid dup key errors vs dualHook:
#If True

; restore normal win or alt + space functions !
#space::SendInput "{blind}#{space}"
!space::SendInput "{blind}!{space}"

; dual mode space
*space::	spaceDual.OnDualDown()
*space Up:: spaceDual.OnDualUp() 

; disable normal RAlt
; *RAlt::

; dual mode left control
*LControl:: lctrlDual.OnDualDown()
*LControl Up:: lctrlDual.OnDualUp() 

; dual mode left shift
;## warning: does not check mouse!
;## so lshift+click will not work and will output the tap value!
*LShift:: lshDual.OnDualDown()
*LShift Up:: lshDual.OnDualUp() 


; win-end hotkey to stop script
#End::
  OutputDebug ëxiting script
  exitapp
return


#If
