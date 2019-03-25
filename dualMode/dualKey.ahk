; testing a simple dualMode class
; a key can then behave as a modifier when hel down
; or output a value when tapped

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
		this.mode := "tap"	; tap or mod (modifier)
		this.active := false
		this.downTick := 0
	}

	sendTap()
	{
		SendInput "{blind" this.modToMask "}{" this.tapVal " up}"
		SendInput "{blind" this.modToMask "}{" this.tapVal " down}"
	}

	OnDualDown()
	{
		OutputDebug "on dual dn " A_ThisHotkey
		if (!this.active) {
			OutputDebug "set active / downTick " A_ThisHotkey
			this.active := true
			this.mode := "tap" 	; until proven otherwise ;-)
			this.downTick := A_TickCount
		}
	}

	OnDualUp()
	{
		OutputDebug "on dual up " A_ThisHotkey

		if (this.active) {
			; simple tap of the key: output tap val
			if (this.mode == "tap") {
				OutputDebug "dualup send tap"
				this.sendTap()
			}
		}

		this.reset()
	}

	; called on other keys down
	CheckDualOnHotkey(mods) 
	{
		if (this.active) {
			if (this.mode == "tap") {
				if (this.downTick) {
					; typing fast, we sometimes type the next key before releasing the prev
					; this would cause unintended modifier + next key iso tap + next key
					if ((A_TickCount - this.downTick) < this.tooFast) {
						OutputDebug "CheckDualOnHotkey, < tooFast, send tapval"
						this.sendTap()
						this.reset()  ; not active after sending tap val
					}
					else {
						; got a key down while holding down dual mode key,
						; it is now behaving as a modifier
						this.mode := "mod"
					}
					this.downTick := 0
				} ;; else .. internal error !?
			}

			; behaving as a modifier, add modifier value to array
			if (this.mode == "mod") {
				mods.push(this.modVal)
			}
		}
	}

	;----------

	;; static
	; each key should call this, to check for dualmode keys combo
	OnHotkey()
	{
		OutputDebug "onhotk " A_ThisHotkey

		; check all dual keys, returns modifiers to use if any
		mods := []
		for idx, dkey in CDualKey.dualKeys {
			dkey.CheckDualOnHotkey(mods)
		}

		; 1st output any (dualmode) modifiers that are down
		for idx, mod in  mods {
			SendInput "{blind}{" mod " down}"
		}

		; output the hotkey that called this.
		val := substr(A_ThisHotkey,2)
		SendInput "{blind}" mods "{" val " down}"

		; and realease modifiers
		for idx, mod in  mods {
			SendInput "{blind}{" mod " up}"
		}
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

;; ## end of code, hotkeys follow

;-------------

; restore normal win or alt + space functions !
#space::SendInput "{blind}#{space}"
!space::SendInput "{blind}!{space}"

; dual mode space
*space::	spaceDual.OnDualDown()
*space Up:: spaceDual.OnDualUp() 

*LControl:: lctrlDual.OnDualDown()
*LControl Up:: lctrlDual.OnDualUp() 

; win-end hotkey to stop script
#End::
  OutputDebug ëxiting script
  exitapp
return

; hookup all keys (modifiers not hooked here)
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
*Space::
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
