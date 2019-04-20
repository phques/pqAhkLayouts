/*

2019-04-19
AdNW ansi angleZ BEALK19 pq4
22 keys
LaSalle fingering

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls22Beakl19pq4"
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
	qwertyMask22_std := "
	(Join`r`n
	        q w e r      u i o p
	        a s d f g  h j k l ; 
	  @LShift     c      m     /
	)"
	qwertyMask22_wide := "
	(Join`r`n
	        q w e r      i o p [
	        a s d f g  j k l ; '
	  @LShift     c      ,     @RShift
	)"

	qwertyMask22 := qwertyMask22_wide

	layerMain_2 := "
	(Join`r`n
        b o e u      d s n w 
        g h a i p  c t l r f 
        k     y      m     v 
	)"
	layerMain_3 := "
	(Join`r`n
		b o e u      d t n w 
		p h i a g  c s l r m 
		k     y      f     v 
	)"

	; created this one based on my std punxLayer, 
	; adding jxz, moving stuff around a bit.
	; use .,'@!_  on shift&main
	; NOTE: NOT 26 keys lasalle (copied from adnw29 pq2)
	; layerJxzPunx := "
	; (Join`r`n
	;         q w e r t    u i o p     $ < - > ~     x [ ] z
	;      CL a s d f g  h j k l ;   \ / ( " ) !   % { = } ;
	;      @LSh z x c v    m , . /     # : * + ``    j ^ & | 
	; )"

	; need backspace (and delete) ?
	layerEdit1 := "
	(Join`r`n
		  . . . .       Home  Up  End .
	 Ctrl Sh . . .  ^z Left Down Right ^x
		.     Alt        ^c            ^v
	)"
	layerEdit2 := "
	(Join`r`n
		  . . . .       ^z   Up  Right .
	 Ctrl Sh . . .  ^x Left Home Down End
		.     Alt       ^c            ^v
	)"

	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask22,
	     	map: layerMain_3, 
	     	;mapSh: layerMainSh
	    },

	    ; {id: "alt", key: "Space", tap: "Space",
	    ; 	qwertyMask: qwertyMask22, 
	    ; 	map: layerAlt, 
	    ; },

	    {id: "edit", key: "LAlt", toggle: true,
	    	qwertyMask: qwertyMask22, 
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
	if (qwertyMask22 == qwertyMask22_wide) {
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
	; altGr := layerDefsById["alt"]
	; altGr.AddMappings("v  Space", false)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
