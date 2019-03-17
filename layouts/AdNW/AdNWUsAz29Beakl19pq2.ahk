/*

2019-03-16
AdNW ansi angleZ BEALK19 pq2
26 keys (+space + 2shifts)

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\beakl19-26pq2"
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
	; using AngleZ ergo mod (lower left hand shifted left by 1, pinky on dualmode Shift)
	; dualMode '/' : RShift | 
	layerMain := "
	(Join`r`n
	     q w e r       u i o p       q u i .       m r c v
	  CL a s d f g   h j k l ; '   ; g h e a ,   w t n s p BS
	  @LSh z x c       m , . @/      k y ' o       d l f @>+b 
	  @LControl                    Escape   
	)"

	layerMainsh := "
	(Join`r`n
	     q w e r       u i o p       Q U I @       M R C V
	  CL a s d f g   h j k l ; ' ~CL G H E A !   W T N S P ~Del
	  @LSh z x c       m , . @/      K Y ? O       D L F @>+B    
	)"

	; created this one based on my std punxLayer, 
	; adding jxz, moving stuff around a bit.
	; use .,'@!_  on shift&main
	layerJxzPunx := "
	(Join`r`n
	        q w e r t    u i o p     $ < - > ~     x [ ] z
	     CL a s d f g  h j k l ;   \ / ( " ) !   % { = } ;
	     @LSh z x c v    m , . /     # : * + ``    j ^ & | 
	)"
	; layerJxzPunxSh := "
	; (Join`r`n
	;         q w e r t    u i o p     $ < - > ~     X [ ] Z
	;      CL a s d f g  h j k l ;   _ \ ( " ) !   % { = } ;
	;      @LSh z x c v    m , . /     # : * + @     J ^ & | 
	; )"

	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
	    	map: layerJxzPunx, 
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

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx := layerDefsById["punx"]
	punx.AddMappings("b  Space", false)

	; SetMouseDragKeys("space", "control")
}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

