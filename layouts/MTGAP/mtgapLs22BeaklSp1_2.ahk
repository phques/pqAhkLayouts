/*

2020-03-01
ls22spv1.2
space on main

MTGAP ansi angleZ BEAKL
22 keys (+space + 2shifts)
LaSalle fingering
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls24Beakl19"
global ImgWidth := 164
global ImgHeight := 94
global CenterOnCurrWndMonitor := 1

; for easyDragWindow script
global DoubleAlt := 0


#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../punxLayer.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

; ----

CreateLayers()
{
	; try both hands a std pos
	qwertyMask24_std := "
	(Join`r`n
	      w e r      u i o 
	    a s d f g  h j k l ; 
	      z x c      m , . 
	)"
	qwertyMask24_wid := "
	(Join`r`n
	      w e r        i o p
	    a s d f g    j k l ; '
	      z x c        , . / 
	)"
	qwertyMask24 := qwertyMask24_wid

	layerMain_2 := "
	(Join`r`n
	    a SP i      h t s   
	  c o  r e y  f n d l g 
	    !  q u      m v j   
	)"

	layerAlt := "
	(Join`r`n
	    , . "      x w k   
	  ' - _ p /  = b ) ( z 
	    ? } ;      : { *   
	)"

	; need backspace (and delete) ?
	layerEdit2 := "
	(Join`r`n
		  . . .         ^z   Up  Right 
	 Ctrl Sh . . .  ^x Left Home Down End
		  . . c         ^c   .     ^v
	)"

	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask24,
	     	map: layerMain_2, 
	     	;mapSh: layerMainSh
	    },

	    {id: "alt", key: "Space", ; tap: "Space",
	    	qwertyMask: qwertyMask24, 
	    	map: layerAlt, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	qwertyMask: qwertyMask24, 
	    	map: layerEdit2, 
	    	; map: extendLayer, 
		},

		; would've liked  to use V here, but it screws up??
	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.thumbOnB, 
		},

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

	; for use w. both hands at std pos
	; trying not to use dualMode lshift, so try caps=lshift
	;#pq not working (under linux VM though which has probs remapping capsl)
	; main.AddMappingsFromTo("cl", "lshift", false)
	; main.AddMappingsFromTo("cl", "cl", true)
	if (qwertyMask24 == qwertyMask24_std) {
		main.AddMappingsFromTo("p", "Backspace", false)
		main.AddMappingsFromTo("p", "~Delete", true)
		main.AddMappingsFromTo("'", "Enter", false)
		main.AddMappingsFromTo("'", "Enter", true)
	}
	else {
		;main.AddMappingsFromTo("[", "Backspace", false)
		;main.AddMappingsFromTo("[", "~Delete", true)
		main.AddMappingsFromTo("m", "Backspace", false)
		main.AddMappingsFromTo("m", "~Delete", true)
	}
	; add Space on altGr  (hold will repeat! vs spacebar dual mode layer access which doesnt)
	altGr := layerDefsById["alt"]
	altGr.AddMappings("v  Space", false)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
