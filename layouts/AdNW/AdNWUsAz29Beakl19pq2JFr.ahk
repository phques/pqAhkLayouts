/*

2019-03-17
AdNW ansi angleZ BEALK19 pq2
26 keys (+space + 2shifts)
french corpus (Jeanne D'Arc, from KLA latest)
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs"
global ImgWidth := 182
global ImgHeight := 96
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
	     q w e r       u i o p       b é o ,      c s l q
	  CL a s d f g   h j k l ; '   ; ' a e i h  g t r n p BS
	  @LSh z x c       m , . @/      è . à u      d v m @>+f
	  @LControl                    Escape   
	)"

	layerMainsh := "
	(Join`r`n
	     q w e r       u i o p       B  É O !      C S L Q
	  CL a s d f g   h j k l ; ' ~CL "  A E I H  G T R N P ~Del
	  @LSh z x c       m , . @/      È ~; À U      D V M @>+F
	)"

	; orig, unfortunately 2nd layer is done indepedent of main:
	; so makes no sense vs main
	;  ?ê«û   ô»]ù
	;  w)xyœ z-j(;
	; kâî:    [—ç"

	layerPunx := "
	(Join`r`n
	       q w e r       u i o p      ? x ô «      ç » ] ù 
	    CL a s d f g   h j k l ; '    w â ê î œ  z - j : ; 
	    @LSh z x c       m , . @/     k y ( û      [ — ) @>+"
	)"

	layerPunxSh := "
	(Join`r`n
	       q w e r       u i o p     ~/ X  Ô «      Ç »  } Ù 
	    CL a s d f g   h j k l ; '    W Â  Ê Î Œ  Z + J  & ~\ 
	    @LSh z x c       m , . @/     K Y ~< Û      { _ ~> @>+"
	)"


	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
	    	map: layerPunx, 
	    	mapSh: layerPunxSh
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

