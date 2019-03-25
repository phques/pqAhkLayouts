
class CDualKey
{
	static dualKeys := []

	__New(modVal, tapVal, modToMask := "", tooFast := 100)
	{
		this.modVal := modVal
		this.tapVal := tapVal
		this.tooFast := tooFast
		this.modToMask := modToMask
		this.reset()
	}

	reset()
	{
		this.needTapUp := false
		this.needModifierUp := false
		this.active := false
		this.downTick := 0
	}

	mySendUp(val)
	{
		OutputDebug "SendInput {blind" this.modToMask "}{" val " up}"
		SendInput "{blind" this.modToMask "}{" val " up}"
	}
	mySendDown(val)
	{
		OutputDebug "SendInput {blind" this.modToMask "}{" val " down}"
		SendInput "{blind" this.modToMask "}{" val " down}"
	}

	OnDualDown()
	{
		OutputDebug "on dual dn " A_ThisHotkey
		if (!this.active) {
			OutputDebug "set active / downTick " A_ThisHotkey
			this.active := true
			this.downTick := A_TickCount
		}
	}

	OnDualUp()
	{
		OutputDebug "on dual up " A_ThisHotkey

		if (this.active) {
			; simple tap of the key: output tap val
			if (!this.needTapUp && !this.needModifierUp) {
				OutputDebug "dualup send tap"
				this.mySendDown(this.tapVal)
				this.mySendUp(this.tapVal)
			}

			if (this.needModifierUp)
				SendInput "{blind}{" this.modVal " down}"
				; this.mySendUp(this.modVal)

			if (this.needTapUp)
				this.mySendUp(this.tapVal)
		}
		this.reset()
	}

	; called on other keys down
	CheckDualOnHotkey() 
	{
		if (this.active) {
			if (this.downTick) {
				; typing fast, we sometimes type the next key before releasing the prev
				; this would cause unintended modifier + next key iso tap + next key
				if ((A_TickCount - this.downTick) < this.tooFast) {
					OutputDebug "CheckDualOnHotkey, < tooFast, send tapval down"
					this.mySendDown(this.tapVal)
					this.needTapUp := true
				}
				else {
					OutputDebug "CheckDualOnHotkey, send modifier down"
					; this.mySendDown(this.modVal)
					SendInput "{blind}{" this.modVal " down}"
					this.needModifierUp := true
				}

				; no need for this anymore
				this.downTick := 0
			}
		}
	}

	;----------

	;; static
	; each key should call this, to check for dualmode keys 
	OnHotkey()
	{
		OutputDebug "onhotk " A_ThisHotkey

		; check all dual keys
		for idx, dkey in CDualKey.dualKeys {
			dkey.CheckDualOnHotkey()
		}

		; output the hotkey that called this
		val := substr(A_ThisHotkey,2)
		OutputDebug  "OnHotkey, send hotkey {" val " down}"
		SendInput "{blind}{" val " down}"
	}

	;; static
	CreateNewDual(modVal, tapVal, modToMask:= "", tooFast := 100)
	{
		dkey := new CDualKey(modVal, tapVal, modToMask, tooFast)
		CDualKey.dualKeys.Push(dkey)

		return dkey
	}
}


global spaceDual :=  CDualKey.CreateNewDual("Ralt", "space")
global lctrlDual :=  CDualKey.CreateNewDual("LControl", "escape", "^")

;; ## end of code

;-------------

; restore normal win or alt - space !
#space::SendInput "{blind}#{space}"
!space::SendInput "{blind}!{space}"

; dual mode space
*space::	spaceDual.OnDualDown()
*space Up:: spaceDual.OnDualUp() 

*LControl:: lctrlDual.OnDualDown()
*LControl Up:: lctrlDual.OnDualUp() 

; hotkey to stop script
#End::exitapp

*a::
*b::
*c::
*d::
*e::
*f::
*g::
*h::
*i::
*j::
*k::
*l::
*m::
*n::
*o::
*p::
*q::
*r::
*s::
*t::
*u::
*v::
*w::
*x::
*y::
*z::
*0::
*1::
*2::
*3::
*4::
*5::
*6::
*7::
*8::
*9::
*.::
*,::
*`;::
*`::
*'::
*/::
*\::
*[::
*]::
*-::
*=::
*Up::
*Down::
*Left::
*Right::
*Home::
*End::
*PgUp::
*PgDn::
*Insert::
*Delete::
*Backspace::
; *Space::
*Enter::
*Tab::
*F1::
*F2::
*F3::
*F4::
*F5::
*F6::
*F7::
*F8::
*F9::
*F10::
*F11::
*F12::
	CDualKey.OnHotkey()
return
