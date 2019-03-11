/*

2019-02-20
AdNW ansi angleZ BEALK19
swap vx qz ,.

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\AdNWpq2-3"
global ImgWidth := 176
global ImgHeight := 54
global CenterOnCurrWndMonitor := 1

#include ../layersv2c.ahk
#include punxLayer.ahk
#include extendLayer.ahk
#include ../fromPkl/pkl_guiLayers.ahk

; ----

go()
{
	; using AngleZ ergo mod (lower left hand shifted left by 1, pinky on dualmode Shift)
	; dualMode '/' : RShift | V
	layerMain := "
	(Join`r`n
	     q w e r t   y u i o p [     z h i , /   v f d r q BS
	  CL a s d f g   h j k l ; '   ; y o e a .   g s t n p ``
	  @LSh z x c v   n m , . @/      j k ' u x   w c m l @>+b 
	)"

	layerMainsh := "
	(Join`r`n
	    q w e r t   y u i o p [      Z H I ! ?   V F D R Q BS
	    a s d f g   h j k l ; '      Y O E A @   G S T N P ^
	 @LSh z x c v   n m , . @/       J K _ U X   W C M L @>+B
	)"

	punxLayers := PunxLayerMappings()
	extendLayer := ExtendLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
	    	map: punxLayers.layerAZ, 
	    },

	    {id: "edit", key: "LAlt",
	    	map: extendLayer, mapSh: extendLayer
		}
	]

	InitLayout(layers)

	; debug / for now, since no hotkeys yet
    StopOnEscape := true

	DisplayHelpImage()

}


go()

return
;--------

;## PQ hotkeys like these dont work with my layersv2c.ahk :-(

; Ctrl-Win-X qwerty
#^sc02D:: ExitApp

; Ctrl-Win-p qwerty
#^sc019::Send 'philippe.quesnel'

; Ctrl-Win-q qwerty
#^sc010::Send 'philippe.quesnel@gmail.com'


; Win-Delete to close the current window
#Del::WinClose "A"



