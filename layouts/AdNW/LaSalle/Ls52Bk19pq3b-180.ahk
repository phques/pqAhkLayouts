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

to use with a std kbd rotated 180 degrees to use Fn keys as thumb keys !!
.. this is going to be crazy ;-p
(not complete .. and very comfortable anyways ;-)

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

#include ../../../fromPkl/pkl_guiLayers.ahk
#include ../../../layersv2c.ahk
#include ../../punxLayer.ahk
#include ../../extendLayer.ahk
#include ../../numpadLayer.ahk

; ----

CreateLayers()
{
	; rotate a std kbd 180, thumbs on f7 / f6
	qwertyMask26_180 := "
	(Join`r`n
	   Cr ' ; l      g f d s
	    ] [ p o i  y t r e w 
	    \ = - 0      5 4 3 2
	)"
	; more to the right.. but right thumb mudt stretch to the left to hit f6 (home=f5)
	qwertyMask26_180_shr := "
	(Join`r`n
	   Cr ' ; l      f d s a
	    ] [ p o i  t r e w q 
	    \ = - 0      4 3 2 1
	)"

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
	     	qwertyMask: qwertyMask26_180,
	     	map: layerMain_3, 
	     	;mapSh: layerMainSh
	    },

	    {id: "alt", key: "f7", tap: "Space",
	    	qwertyMask: qwertyMask26_180, 
	    	map: layerAlt_3, 
	    },

	    {id: "syms", key: "f6", tap: "Enter",
	    	qwertyMask: qwertyMask26_180, 
	    	map: layerSyms3, 
	    },

	    {id: "edit", key: "f8", toggle: true,
	    	qwertyMask: qwertyMask26_180, 
	    	map: layerEdit2, 
	    	; map: extendLayer, 
		},

		; would've liked  to use V here, but it screws up??
	 ;    {id: "numpad", key: "b", toggle: true,
	 ;    	map: numpadLayers.thumbOnB, 
		; },

	]

	; dont create layout hotkeys for these
	; for eg, we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	main := layerDefsById["main"]

	main.AddMappingsFromTo("F5", "LShift", false)
	; main.AddMappingsFromTo("t", "Tab", false)
	; if (qwertyMask26 == qwertyMask26_rsh) {
	; 	main.AddMappingsFromTo("v", "Backspace", false)
	; 	main.AddMappingsFromTo("v", "~Delete", true)
	; }
	; else {
	; 	main.AddMappingsFromTo("'", "Backspace", false)
	; 	main.AddMappingsFromTo("'", "~Delete", true)
	; 	main.AddMappingsFromTo("[", "Enter", false)
	; 	main.AddMappingsFromTo("[", "Enter", true)
	; }
	; ; add Space on altGr  (hold will repeat! vs spacebar dual mode layer access which doesnt)
	; altGr := layerDefsById["alt"]
	; altGr.AddMappings("v  Space", false)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
