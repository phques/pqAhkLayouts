/* BEAKL19

2019-03-12 (2019-02-08)


*/

; code only includes (not hotkeys)

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
; NB: 2019-03-12, images are not exactly th mappings found in this file!
global ImgsDir := A_ScriptDir . "\imgs"
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
	; dualMode '/' : hold is RShift | tap is V
	layerMain := "
	(Join`r`n
	     q w e r t   y u i o p [     q . o u j   w d n m , BS  
	  CL a s d f g   h j k l ; '   ; h a e i k   g s r t p ``
	  @LSh z x c v   n m , . @/      z ' / y x   b c l f @>+v
	)"

	layerMainsh := "
	(Join`r`n
	    q w e r t   y u i o p [      Q @ O U J    W D N M ! BS
	    a s d f g   h j k l ; '      H A E I K    G S R T P ^
	 @LSh z x c v   n m , . @/       Z _ ? Y X    B C L F @>+V
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

	]

	; dont create layout hotkey for Left Win
	; we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	; add W on punc layer on N for easier access 
	; (is on Y, pretty tough reach on Microsoft Sculpt)
	punx := layerDefsById["punx"]
	punx.AddMappings("n  w", false)
	punx.AddMappings("n  W", true)

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx.AddMappings("b  Space", false)
}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
