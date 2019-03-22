/*

2019-03-21
AdNW ansi angleZ BEALK19 pq2b
26 keys, only letters on main (+space + 2shifts)

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\az29Beakl19pq2b"
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
	; 
	layerMain := "
	(Join`r`n
	     q w e r       u i o p [     q u i z      m r c v '
	  CL a s d f g   h j k l ; '   ; g h e a x  w t n s p BS
	  @LSh z x c v     m , . @/      k y j o i    d l f @>+b
	  @LControl                    Escape   
	)"
	layerMainSh := "
	(Join`r`n
	     q w e r       u i o p [     Q U I Z      M R C V " 
	  CL a s d f g   h j k l ; '  CL G H E A X  W T N S P ~Del
	  @LSh z x c v     m , . @/      K Y J O I    D L F @>+B
	)"

	; modified version of std punx layer, added stuff normally on main
	layerPunx := "
	(Join`r`n   
	       q w e r t    u i o p      $ < , > %   `` [ ] @ 
	   CL  a s d f g  h j k l ;    _ / ( . ) !  ? { = } ;
	  @LSh z x c v      m , . /      # : * + -    & ^ _ | 
	)"


	; punxLayers := PunxLayerMappings()
	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
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

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx := layerDefsById["punx"]
	punx.AddMappings("b  Space", false)

	; SetMouseDragKeys("space", "control")
}


swapFrenchAndPunx()
{
	; get punx layer access keydef, on main layer 
    mainLayer := layerDefs[1]
    ; mainLayer := layerDefsById["main"]
	punx := layerDefsById["punx"]
	french := layerDefsById["french"]

    punxAccessKeydef := mainLayer.GetKeydef(punx.key)
    ; frenchAccessKeydef := mainLayer.GetKeydef(french.key)

    if (punxAccessKeydef.layerId == "punx") {
    	mainLayer.id := "mainfr"
    	punxAccessKeydef.layerId := "french"
	    ; frenchAccessKeydef.layerId := "punx"
    }
    else {
    	mainLayer.id := "main"
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
