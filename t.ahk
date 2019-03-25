

global lastSp := 0
global spaceActive := false
global spaceDown := false
global raltDown := false

space::
	OutputDebug "sapce dn"
	if (!spaceActive) {
		OutputDebug "set lastsp"
		spaceActive := true
		lastSp := A_TickCount
	}
return

*space Up::
	OutputDebug "sapce up"
	if (raltDown)
		SendInput "{blind}{RAlt up}"
	if (spaceDown)
		SendInput "{blind}{Space up}"
	spaceDown := false
	raltDown := false
	spaceActive := false
	lastSp := 0
return


checkSp() 
{
	val := substr(A_ThisHotkey,2)

	if (lastSp) {
		if ((A_TickCount - lastSp) < 100) {
			OutputDebug "< timeout"
			SendInput "{blind}{space down}"
			spaceDown := true
			lastSp := 0
		}
		else {
			OutputDebug "ralt down"
			SendInput "{RAlt down}"
			raltDown := true
		}
	}

	OutputDebug  "SendInput {blind}{" val " down}"
	SendInput "{blind}{" val " down}"
}

; space::RALT
escape::exitapp

; *a::
; *b::
; *c::
; *d::
; *e::
; *f::
; *g::
; *h::
; *i::
; *j::
; *k::
; *l::
; *m::
; *n::
; *o::
; *p::
; *q::
; *r::
; *s::
; *t::
; *u::
; *v::
; *w::
; *x::
; *y::
; *z::
; *0::
; *1::
; *2::
; *3::
; *4::
; *5::
; *6::
; *7::
; *8::
; *9::
; *.::
; *,::
; *`;::
; *`::
; *'::
; */::
; *\::
; *[::
; *]::
; *-::
; *=::
; *Up::
; *Down::
; *Left::
; *Right::
; *Home::
; *End::
; *PgUp::
; *PgDn::
; *Insert::
; *Delete::
; *Backspace::
; *Space::
; *Enter::
; *Tab::
; *F1::
; *F2::
; *F3::
; *F4::
; *F5::
; *F6::
; *F7::
; *F8::
; *F9::
; *F10::
; *F11::
; *F12::
; 	checkSp()
; return
