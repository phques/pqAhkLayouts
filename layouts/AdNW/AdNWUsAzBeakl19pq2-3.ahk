/*

2019-02-20
AdNW ansi angleZ BEALK19
swap vx qz ,.

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\beakl19pq2-3"
global ImgWidth := 176
global ImgHeight := 54
global CenterOnCurrWndMonitor := 1

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../punxLayer.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

; ----

CreateLayers()
{
	; using AngleZ ergo mod (lower left hand shifted left by 1, pinky on dualmode Shift)
	; dualMode '/' : RShift | V
	layerMain := "
	(Join`r`n
	     q w e r t   y u i o p [     z h i , /   v f d r q BS
	  CL a s d f g   h j k l ; '   ; y o e a .   g s t n p ``
	  @LSh z x c v   n m , . @/      j k ' u x   w c m l @>+b 
	)"

	layerMainsh := "
	(Join`r`n
	    q w e r t   y u i o p [      Z H I ! ?   V F D R Q BS
	    a s d f g   h j k l ; '      Y O E A @   G S T N P ^
	 @LSh z x c v   n m , . @/       J K _ U X   W C M L @>+B
	)"

	punxLayers := PunxLayerMappings()
	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
	    	map: punxLayers.layerAZ, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	map: extendLayer, mapSh: extendLayer
		},

	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.indexOnB, 
		},

		; ; this one is used to create Win-XX hotkeys
	 ;    {id: "hotkeys", key: "LWin", tap: "LWin", map: "" }
	]

	; dont create layout hotkeys for these
	; for eg, we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx := layerDefsById["punx"]
	punx.AddMappings("b  Space", false)

}


; CreateHotkeys__()
; {
; 	; manually create hotkeys, on a layer
; 	hotklay := layerDefsById["hotkeys"]

; 	; Win-End: stop script
; 	key := hotklay.GetKeydef("End")
; 	key.onHoldDn := Func("ExitApp")

; 	; Win-Delete to close the current window
; 	key := hotklay.GetKeydef("Del")
; 	key.onHoldDn := Func("WinClose").Bind("A")

; 	; Win-\   suspend / resume hotkeys (help image toggles at same time)
; 	key := hotklay.GetKeydef("\")
; 	key.onHoldDn := Func("SuspendKeysToggle")

; }

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
