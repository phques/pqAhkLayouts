; trying to see if I can use a mix of pqAhk and microsoft keyboard layouts
; spacebar is my altGr ..

global ImgsDir := "..\BEAKL PLLT x1\imgsb"
; global ImgsDir := A_ScriptDir . "\imgsb"
global ImgWidth := 160
global ImgHeight := 54
global CenterOnCurrWndMonitor := 1

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk

	layers := [
	    {id: "main", 
	    	; (<^RALt) lctrl ralt = altGr, actually works as ctr-ralt
	     	map: "SP q   ^RALt SP",  
	    },

	    ; {id: "alt", key: "Space", tap: "Space",
	    ; 	map: layerAlt, 
	    ; },

	]

	; dont create layout hotkeys for these
	; for eg, we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	main := layerDefsById["main"]
	; main.AddMappings("@LControl  Escape", false)
	; main.AddMappingsFromTo((rsh ? "]" : "["), "Backspace", false)
	; main.AddMappingsFromTo((rsh ? "]" : "["), "~Delete", true)
	; main.AddMappingsFromTo((rsh ? "," : "m"), "Enter", false)
	; main.AddMappingsFromTo((rsh ? "," : "m"), "Enter", true)

DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

