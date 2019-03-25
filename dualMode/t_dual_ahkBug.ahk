;; ahk bug ?
; trying to do dualMode keys
; here space behaves as RAlt when held down,
; in this test, 'E' is the only key that is spported
; it does work, so we do output RAlt-E .. but
; we never receive Space Up !!
; so RAlt stays stuck down :(

global spaceActive := false

space::
	OutputDebug "space dn"
	spaceActive := true
return

space Up::
	OutputDebug "space up"
	if (spaceActive)
		SendInput "{blind}{ralt up}"
return


*e::
	val := substr(A_ThisHotkey,2)

	if (spaceActive) 
		SendInput "{blind}{ralt down}"


	SendInput "{blind}{" val " down}"
return


; space::RALT
escape::exitapp
