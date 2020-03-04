/* balanced13-iso-shifted-v2

http://shenafu.com/smf/index.php?topic=89.msg2877#msg2877
Moesasji

2020-03-02

*/

; code only includes (not hotkeys)

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
; NB: 2019-03-12, images are not exactly th mappings found in this file!
global ImgsDir := A_ScriptDir . "\imgs"
global ImgWidth := 176
global ImgHeight := 54
global CenterOnCurrWndMonitor := 1

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../punxLayer.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

; ----

CreateLayers()
{
	; mapping main kbd for now.. will do the rest if I like it
	; using AngleZ ergo mod fingering
	; not that this is designed for European kbd, 
	; which has extra key between LSh and Z
	; I will skip the Win key: Win q f g => q f g (q on LSh)

	qwertyMask := "
	(Join`r`n
	    Tab q w e r t    y  u i o p [ ]  
	    CL  a s d f g    h  j k l ; ' CR  
	    LSh z x c v b    n  m , . / RSh 
	)"

	layerMain := "
	(Join`r`n
	    Esc v c d l b     ?  ' u o y ; "  
	    LSh r s t n w     ?  . a e i p RSh
	        q f g h m Tab  CR x , k j z  
	)"

	layerMainsh := "
	(Join`r`n
	   +Esc V C D L B     ?  % U O Y ! ~``  
	    LSh R S T N W     ?  & A E I P RSh 
	        Q F G H M +Tab +CR X ? K J Z    
	)"

	punxLayers := PunxLayerMappings()
	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	        qwertyMask: qwertyMask,
	        map: layerMain, 
	        mapSh: layerMainSh
	    },

	 ;    {id: "punx", key: "Space", tap: "Space",
	 ;    	map: punxLayers.layerAZ, 
	 ;    },

	 ;    {id: "edit", key: "LAlt", toggle: true,
	 ;    	map: extendLayer, mapSh: extendLayer
		; },

	 ;    {id: "numpad", key: "b", toggle: true,
	 ;    	map: numpadLayers.indexOnB, 
		; },

	]

	; dont create layout hotkey for Left Win
	; we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	; add W on punc layer on N for easier access 
	; (is on Y, pretty tough reach on Microsoft Sculpt)
	punx := layerDefsById["punx"]
	; punx.AddMappings("n  w", false)
	; punx.AddMappings("n  W", true)

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	; punx.AddMappings("b  Space", false)

	SetMouseDragKeys("space", "control")

}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
