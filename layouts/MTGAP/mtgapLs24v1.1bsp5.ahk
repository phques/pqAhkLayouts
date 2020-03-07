/*

2019-03-29

MTGAP ansi angleZ BEALK19 pq3
24 keys (+space + 2shifts)
LaSalle fingering

2020-03-02
try to use spacebar for a key
and move space to main keys
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls24Beakl19pq3"
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
	  @LShift z x c      m , . /
	)"
	qwertyMask24_wid := "
	(Join`r`n
	          w e r        i o p
	        a s d f g    j k l ; '
	  @LShift z x c        , . / @RShift
	)"
	qwertyMask24 := qwertyMask24_wid

	; -2 seems to have better scrore (lower same finger than -3)
	; feels better too
	layerMain_2 := "
	(Join`r`n
           a  e  y         h  t  s   
        g  u  o  i  _   m  n  r  d  Sp
        -  >  !  p         l  q  z  v
	)"
	tapKey := 'c'

	layerAlt := "
	(Join`r`n
		    k  ,  ;         x  w  b   
		 ?  '  (  .  *   =  f  )  "  / 
		 $  +  [  :         j  ]  {  } 
	)"

	; need backspace (and delete) ?
	layerEdit1 := "
	(Join`r`n
		  . . .        Home  Up  End
	 Ctrl Sh . . .  ^z Left Down Right ^x
		. . . Alt        ^c   .    .   ^v
	)"
	layerEdit2 := "
	(Join`r`n
		  . . .         ^z   Up  Right 
	 Ctrl Sh . . .  ^x Left Home Down End
		. . . Alt       ^c   .     .  ^v
	)"
	layerEdit3 := "
	(Join`r`n
		  . . .          ^z   Up  Right 
	 Ctrl Sh . . .   ^x Left Home End Down
		. ^BS BS Alt     ^c   .     .  ^v
	)"

	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask24,
	     	map: layerMain_2, 
	     	;mapSh: layerMainSh
	    },

	    ;{id: "alt", key: "Space", tap: "Space",
	    {id: "alt", key: "Space", tap: tapKey,
	    	qwertyMask: qwertyMask24, 
	    	map: layerAlt, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	qwertyMask: qwertyMask24, 
	    	map: layerEdit3, 
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
		main.AddMappingsFromTo("v", "Backspace", false)
		main.AddMappingsFromTo("v", "~Delete", true)
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
