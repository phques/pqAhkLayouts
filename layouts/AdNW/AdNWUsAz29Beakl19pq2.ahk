/*

2019-03-16
AdNW ansi angleZ BEALK19 pq2
26 keys (+space + 2shifts)

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\az29Beakl19pq2"
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
	     q w e r       u i o p       q u i .       m r c v
	  CL a s d f g   h j k l ; '   ; g h e a ,   w t n s p BS
	  @LSh z x c v     m , . @/      k y ' o i     d l f @>+b 
	  @LControl                    Escape   
	)"

	layerMainsh := "
	(Join`r`n
	     q w e r       u i o p       Q U I @       M R C V
	  CL a s d f g   h j k l ; ' ~CL G H E A !   W T N S P ~Del
	  @LSh z x c v     m , . @/      K Y ? O I     D L F @>+B    
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
						   ; 9 0                       < >
	layerJxzFrench := "
	(Join`r`n
	        q w e r t    u i o p     ù û î ï ä     x " ç z
	     CL a s d f g  h j k l ;   \ / è é à â   % « = » ;
	     @LSh z x c v    m , . /     : ë ê ô œ     j ( ) -
	)"
	; need layer since accented chars wont auto upper case ! (CapsLock wont work)
	layerJxzFrenchSh := "
	(Join`r`n
	        q w e r t    u i o p     Ù Û Î Ï Ä     X " Ç Z
	     CL a s d f g  h j k l ;   | ? È É À Â   % « + » :
	     @LSh z x c v    m , . /     : Ë Ê Ô Œ     J < > _
	)"

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

	    {id: "french", 
	    	map: layerJxzFrench,
	    	mapSh: layerJxzFrenchSh,
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

	main := layerDefsById["main"]
	main.AddMappings("n  Enter", false)
	main.AddMappings("n  +Enter", true)

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

