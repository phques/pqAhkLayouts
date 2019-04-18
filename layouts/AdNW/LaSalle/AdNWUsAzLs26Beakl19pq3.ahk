/*

2019-03-29
AdNW ansi angleZ BEALK19 pq3
26 keys (+space + 2shifts)
LaSalle fingering
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls26Beakl19pq3"
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

; ----

CreateLayers()
{
	; try both hands a std pos
	qwertyMask26_std := "
	(Join`r`n
	        q w e r      u i o p
	        a s d f g  h j k l ; 
	  @LShift z x c      m , . /
	)"
	qwertyMask26_wide := "
	(Join`r`n
	        q w e r      i o p [
	        a s d f g  j k l ; '
	  @LShift z x c      , . / @RShift
	)"

	qwertyMask26 := qwertyMask26_wide

	; -2 and -3 have similar scores .. ??
	; but -3 feels better (short test)
	layerMain_2 := "
	(Join`r`n
        k i e g      d s n w 
        h p o a u  f t l r c 
        z j q y      m v x b 
	)"
	layerMain_3 := "
	(Join`r`n
		x i e g      d t n w 
		h y o a k  c s l r f 
		z j q u      m v b p 
	)"

	layerAlt := "
	(Join`r`n
		+ " ' )      ! , . [  
		_ $ : - &  / ; ( # ``  
		* { ] %      ? @ } =  
	)"

	; need backspace (and delete) ?
	layerEdit1 := "
	(Join`r`n
		  . . . .       Home  Up  End .
	 Ctrl Sh . . .  ^z Left Down Right ^x
		. . . Alt        ^c   .    .   ^v
	)"
	layerEdit2 := "
	(Join`r`n
		  . . . .       ^z   Up  Right .
	 Ctrl Sh . . .  ^x Left Home Down End
		. . . Alt       ^c   .     .  ^v
	)"

	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask26,
	     	map: layerMain_3, 
	     	;mapSh: layerMainSh
	    },

	    {id: "alt", key: "Space", tap: "Space",
	    	qwertyMask: qwertyMask26, 
	    	map: layerAlt, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	qwertyMask: qwertyMask26, 
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

	main.AddMappingsFromTo("t", "Tab", false)
	if (qwertyMask26 == qwertyMask26_wide) {
		main.AddMappingsFromTo("v", "Backspace", false)
		main.AddMappingsFromTo("v", "~Delete", true)
	}
	else {
		main.AddMappingsFromTo("'", "Backspace", false)
		main.AddMappingsFromTo("'", "~Delete", true)
		main.AddMappingsFromTo("[", "Enter", false)
		main.AddMappingsFromTo("[", "Enter", true)
	}
	; add Space on altGr  (hold will repeat! vs spacebar dual mode layer access which doesnt)
	altGr := layerDefsById["alt"]
	altGr.AddMappings("v  Space", false)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
