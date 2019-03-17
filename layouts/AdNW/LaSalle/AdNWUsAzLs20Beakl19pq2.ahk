/*

2019-03-17
AdNW ansi angleZ BEALK19 pq2
20 keys (+space + 2shifts)
LaSalle fingering
see pq3 preferrably. pq2 had not adjusted weight for the moved up 2mid fingers
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs"
global ImgWidth := 176
global ImgHeight := 54
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
	; note that 'std' right hand is still shifted right by 1
	qwertyMask20Std := "
	(Join`r`n
	          w e r      i o p
	        a s d f g  j k l ; '
	  @LShift    c       ,     @RShift
	)"

	qwertyMask20Lsh := "
	(Join`r`n
	             q w e      i o p
	    CapsLock a s d f  j k l ; '
	    @LShift      x      ,     @RShift
	)"

	qwertyMask20LRSh := "
	(Join`r`n
	             q w e      o p [
	    CapsLock a s d f  k l ; ' Enter
	    @LShift      x      .     @RShift
	)"

	lsh := true
	rsh := true

	if (lsh & rsh)
	  qwertyMask20 := qwertyMask20LRsh
	else if (lsh)
	  qwertyMask20 := qwertyMask20Lsh
	; else if (rsh)
	;   qwertyMask20 := qwertyMask20Rsh
	else 
	  qwertyMask20 := qwertyMask20Std

	; -2 seems to have better scrore (lower same finger than -3)
	layerMain_2 := "
	(Join`r`n
		  o e y       c t n   
		g h a i p   m s l r f 
		b     u       d     w 
	)"
	layerMain_3 := "
	(Join`r`n
		  o e y       c t n  
		p h i a g   f s l r m
		b     u       d     w
	)"

	layerPunx := "
	(Join`r`n
		  ' , $       ? . v  
		( " ; - !   ) k q z :
		&     x       j     %
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

#include ../winHotkeys.ahk

