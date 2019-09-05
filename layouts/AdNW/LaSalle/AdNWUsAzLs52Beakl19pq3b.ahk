/*

2019-03-29
AdNW ansi angleZ BEALK19 pq3
26 keys (+space + 2shifts)
LaSalle fingering
defined 52 keys ! 
trying to get opt to properly assign chars according to weights .. 
on '2 layers'
--- higher weight on '2nd layer' ---
 to try to have more of the important keys on 1st layer
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls52Beakl19pq3b\circles"
; global ImgWidth := 180
; global ImgHeight := 60
global ImgWidth := 154
global ImgHeight := 100
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
	qwertyMask26_rsh := "
	(Join`r`n
	        q w e r      i o p [
	        a s d f g  j k l ; ' 
	  @LShift z x c      , . / @RShift
	)"
	qwertyMask26 := qwertyMask26_rsh

	layerMain_2 := "
	(Join`r`n
        ; i e u      d r n w  
        h y o a ,  m t s l c  
        : % ) .      f v " b   
	)"
	layerAlt_2 := "
	(Join`r`n
        + $ ' ``     j p g }    
        / ? ( - &  _ k q x #    
        = { @ !      z * ] [    
	)"

       ;prefered
	layerMain_3 := "
	(Join`r`n
        ? i e u      d n r v 
        h y o a ,  p t s l c 
        : $ ) .      f x " w 
	)"
	layerAlt_3 := "
	(Join`r`n
       `` ; ' #      q g m * 
        / ! ( - _  + b k z j 
        @ } { &      % = [ ] 
	)"
    ; #include punxLayer, w/o %` in left mid col
    layerSyms3 := "
	(Join`r`n
		$ < - >      ~ [ ] @ 
		\ ( " ) !  % { = } ;
		# : * +      & ^ _ | 
	)"

	; need backspace (and delete) ?
	layerEdit1 := "
	(Join`r`n
		  . . . .       Home  Up  End BS
	 Ctrl Sh . . .  ^z Left Down Right ^x
		. . . Alt        ^c   .    .   ^v
	)"
	layerEdit2 := "
	(Join`r`n
		  . . . .       ^z   Up  Right BS
	 Ctrl Sh . . .  ^x Left Home Down End
		. . . Alt       ^c   .     .  ^v
	)"

	numpadLayers := NumpadLayerMappings()

	; use thumb to press B, home row is (LaSalle) aWEf, 
	; right hand shifted right by 1
	thumbOnBshr := "
	(Join`r`n
	  w e       i o p [                   + -      7 8 9 BS
	 a  d f   j k l ; '                /   = *   , 4 5 6 0 
	            , . / @RShift                      1 2 3 . 
	)"

	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask26,
	     	map: layerMain_3, 
	     	;mapSh: layerMainSh
	    },

	    {id: "alt", key: "Space", tap: "Space",
	    	qwertyMask: qwertyMask26, 
	    	map: layerAlt_3, 
	    },

	    {id: "syms", key: "m", toggle: true,
	    	qwertyMask: qwertyMask26, 
	    	map: layerSyms3, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	qwertyMask: qwertyMask26, 
	    	map: layerEdit2, 
	    	; map: extendLayer, 
		},

		; would've liked  to use V here, but it screws up??
	    {id: "numpad", key: "b", toggle: true,
	    	map: thumbOnBshr, ;numpadLayers.thumbOnB, 
		},

	]

	; dont create layout hotkeys for these
	; for eg, we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	main := layerDefsById["main"]

	; for use w. both hands at std pos
	; trying not to use dualMode lshift, so try caps=lshift
	;#pq not working (under linux VM though which has probs remapping capsl)
	; main.AddMappingsFromTo("cl", "lshift", false)
	; main.AddMappingsFromTo("cl", "cl", true)
	main.AddMappingsFromTo("t", "Tab", false)
	if (qwertyMask26 == qwertyMask26_rsh) {
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
