/*

2019-03-17
'French' AdNW ansi angleZ BEALK19 pq3
20 keys (+space + 2shifts)
LaSalle fingering
Corpus is Jeanne D'Arc from KLA latest

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs"
global ImgWidth := 164
global ImgHeight := 94
global CenterOnCurrWndMonitor := 1

; for easyDragWindow script
global DoubleAlt := 0


#include ../../../fromPkl/pkl_guiLayers.ahk
#include ../../../layersv2c.ahk
#include ../../punxLayer.ahk
#include ../../extendLayer.ahk
#include ../../numpadLayer.ahk
#include qwerty20Masks.ahk

; ----

CreateLayers()
{
	lsh := true
	rsh := true
	qwertyMask20 := GetQwerty20Mask(lsh, rsh)

	; -3 seems to have better scrore (lower same finger than -2)
	; feels better too
	layerMain_2 := "
	(Join`r`n
		  a e é      c s n   
		g o u i '  m t l r p 
		f     ,      d     v 
	)"
	layerMain_3 := "
	(Join`r`n
		  a e u      d s n  
		g é o i '  c t l r p
		f     ,      m     v
	)"

	layerPunx := "
	(Join`r`n
		  è . (      ) h b  
		ô y - j â  ç q à x z
		w     ê      :     k
	)"

	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	punxKey := (rsh ? "RAlt" : "Space")
	punxTap := (rsh ? 0      : "Space")
	punxKey := "Space"
	punxTap := "Space"
	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask20,
	     	map: layerMain_3, 
	     	;mapSh: layerMainSh
	    },

	    {id: "punx", key: punxKey, tap: punxTap,
	    	qwertyMask: qwertyMask20, 
	    	map: layerPunx, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	map: extendLayer, 
		},

	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.indexOnB, 
		},

	]

	; dont create layout hotkeys for these
	; for eg, we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	main := layerDefsById["main"]
	main.AddMappings("@LControl  Escape", false)

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx := layerDefsById["punx"]
	punx.AddMappings("b  Space", false)

	if (rsh)
	    main.AddMappings(", Enter", false)
	    ; main.AddMappings("m Enter", false)

	; SetMouseDragKeys("space", "control")
}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk

