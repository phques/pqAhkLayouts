/*

2019-03-29
AdNW ansi angleZ, no dualMode shift (use V) BEALK19 pq2b
26 keys, only letters on main -3 stdUs29azvBEAKL19pq2b.cfg
Try to avoid dualMode modifiers, since having bugs w them !

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\azv29Beakl19pq2b"
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
	     q w e r t   y u i o p [     k u i q Tab Del m r c v Escape
	  CL a s d f g   h j k l ; '   ; g h e a x     w t n s p BackSpace
	       z x c v   n m , . / RSh     y j o z   RSh d l f b Enter

	)"
	layerMainSh := "
	(Join`r`n
	     q w e r t     u i o p       K U I Q +Tab    M R C V
	  CL a s d f g   h j k l ; '  CL G H E A X     W T N S P ~Del
	       z x c v     m , . / RSh     Y J O Z       D L F B +Enter
	)"


	; modified version of std punx layer, added stuff normally on main
	; still use lshift on this one, but NOT dualMode
	layerPunx := "
	(Join`r`n   
	       q w e r t    u i o p      $ < ' > %      ? [ ] @ 
	    CL a s d f g  h j k l ;    _ / ( , ) !    = { . } ;
	     LSh z x c v  n m , . /      # : * + -    & " ^ _ | 
	)"

	; cannot use lshift on this one, 
	; will want to use it as actual shift for syms of right hand
	layerFrench := "
	(Join`r`n
	        q w e r t    u i o p       ù û î ï ä     - , ç *
	     CL a s d f g  h j k l ; '  `` ' è é à â   = « . » ; BackSpace
	          z x c v  n m , . /         ë ê ô œ   $ ! ( ) ?
	)"
	; need shift layer since accented chars wont auto upper case ! 
	; (CapsLock wont work)
	layerFrenchSh := "
	(Join`r`n
	        q w e r t    u i o p     Ù Û Î Ï Ä     _  ^  Ç #
	     CL a s d f g  h j k l ;   ~ " È É À Â   + ~[ @ ~] :
	          z x c v  n m , . /       Ë Ê Ô Œ   % &  <  > |
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

	    {id: "french",
	    	map: layerFrench, 
	    	mapSh: layerFrenchSh, 
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
	punx := layerDefsById["punx"]
    punxAccessKeydef := mainLayer.GetKeydef(punx.key)

    if (punxAccessKeydef.layerId == "punx") {
    	punxAccessKeydef.layerId := "french"
   }
    else {
    	punxAccessKeydef.layerId := "punx"
    }

}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

LWin & Insert::swapFrenchAndPunx()

