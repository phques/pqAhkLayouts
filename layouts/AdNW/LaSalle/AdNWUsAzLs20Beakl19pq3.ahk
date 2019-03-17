/*

2019-03-17
AdNW ansi angleZ BEALK19 pq3
20 keys (+space + 2shifts)
LaSalle fingering

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls20Beakl19pq3"
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
	; feels better too
	layerMain_2 := "
	(Join`r`n
		  o e u       d s n   
		g h a i p   f t l r c 
		b     y       m     w 
	)"
	layerMain_3 := "
	(Join`r`n
		  o e u       d t n  
		p h i a g   c s l r m
		b     y       f     w
	)"

	layerPunx := "
	(Join`r`n
		  ' , z       ) . k  
		? " q - :   ( v j x $
		%     ;       !     &
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
	     	map: layerMain_2, 
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

