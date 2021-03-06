﻿/* BEAKL15 mod PQ (based on latest BEAKL15)

2019-03-12 (2019-02-08)

http://shenafu.com/code/keyboard/beakl/index.php
http://shenafu.com/smf/index.php?topic=89.msg2221#msg2221

(US ansi kbd AngleZ !)
- ** swapped GW !! (G also added on N of punx layer for easy access on Microsoft Sculpt)
- adjusted symbols layer 

- couple small changes for main layer syms:
"intl", use with "deadKeys.klc" to enter accented chars (ie french, works pretty well!)

*/

; code only includes (not hotkeys)

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
; NB: 2019-03-12, images are not exactly th mappings found in this file!
global ImgsDir := A_ScriptDir . "\imgs"
global ImgWidth := 174
global ImgHeight := 50
global CenterOnCurrWndMonitor := 1

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../punxLayer.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

; ----

CreateLayers()
{
	; using AngleZ ergo mod (lower left hand shifted left by 1, pinky on dualmode Shift)
	; dualMode '/' : hold is RShift | tap is V
	layerMain := "
	(Join`r`n
	     q w e r t   y u i o p [     q h o u x  w c r f z ``
	  CL a s d f g   h j k l ; '   ; y i e a .  d s t n b BS
	  @LSh z x c v   n m , . @/      j , / k '  g m l p @>+v    
	  @LControl                      Escape
	)"

	layerMainsh := "
	(Join`r`n
	    q w e r t   y u i o p [      q h o u x  w c r f z ^
	 CL a s d f g   h j k l ; '  ~CL y i e a @  d s t n b ~Del
	 @LSh z x c v   n m , . @/       j ! ? k _  g m l p v
	)"

	layerFrench := "
	(Join`r`n
	    q w e r t   y u i o p [      : ï ô û ù  | ç [ ] + ~
	 CL a s d f g   h j k l ; '    % - î é à =  * { " } ; #
	 @LSh z x c v   n m , . /        < è ê â \  & ( $ ) >
	)"

	layerFrenchSh := "
	(Join`r`n
	    q w e r t   y u i o p [      : Ï Ô Û Ù  | Ç { } + ~
	 CL a s d f g   h j k l ; '    % _ Î É À +  * { " } : #
	 @LSh z x c v   n m , . /        < È Ê Â |  & ( $ ) >
	)"

	punxLayers := PunxLayerMappings()
	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
	    	map: punxLayers.layerAZ, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	map: extendLayer, ;mapSh: extendLayer
		},

	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.indexOnB, 
		},

	    {id: "french", ;key: "AppsKey", tap: "AppsKey", 
	    	map: layerFrench, 
	    	mapSh: layerFrenchSh
	    },
	]

	; dont create layout hotkey for Left Win
	; we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	; add W on punc layer on N for easier access 
	; (is on Y, pretty tough reach on Microsoft Sculpt)
	punx := layerDefsById["punx"]
	punx.AddMappings("n  w", false)
	punx.AddMappings("n  W", true)

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx.AddMappings("b  Space", false)

	SetMouseDragKeys("space", "control")

}

swapFrenchAndPunx()
{
	; get punx layer access keydef, on main layer 
    mainLayer := layerDefsById["main"]
	punx := layerDefsById["punx"]
	french := layerDefsById["french"]

    punxAccessKeydef := mainLayer.GetKeydef(punx.key)
    ; frenchAccessKeydef := mainLayer.GetKeydef(french.key)

    if (punxAccessKeydef.layerId == "punx") {
    	punxAccessKeydef.layerId := "french"
	    ; frenchAccessKeydef.layerId := "punx"
    }
    else {
    	punxAccessKeydef.layerId := "punx"
	    ; frenchAccessKeydef.layerId := "french"
    }

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

LWin & Insert::swapFrenchAndPunx()

