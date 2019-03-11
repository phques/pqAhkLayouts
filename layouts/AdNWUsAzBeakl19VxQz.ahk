/*

2019-02-20
AdNW ansi angleZ BEALK19
swap vx qz ,.

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs"
global ImgWidth := 176
global ImgHeight := 54
global CenterOnCurrWndMonitor := 1

#include ../layersv2c.ahk
#include punxLayer.ahk
; #include ../../common/fromPkl/pkl_guiLayers.ahk

; ----

go()
{
	; using AngleZ ergo mod (lower left hand shifted left by 1, pinky on dualmode Shift)
	; dualMode '/' : RShift | V
	layerMain := "
	(Join`r`n
	     q w e r t   y u i o p [     j u i o z  x d r l b BS
	  CL a s d f g   h j k l ; '   ; g h e a .  p t s n c ``
	  @LSh z x c v   n m , . @/      q y ' , /  k f w m @>+v
	)"

	layerMainsh := "
	(Join`r`n
	    q w e r t   y u i o p        J U I O Z  X D R L B
	    a s d f g   h j k l ; '      G H E A @  P T S N C ^
	 @LSh z x c v   n m , . @/        Q Y _ ! ?  K F W M @>+V
	)"

	punxLayers := PunxLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
	    	map: punxLayers.layerAZ, 
	    	; mapSh: "a s d  ! { @"
	    },

	    ; {id: "edit", key: "LAlt"}
	]

	InitLayout(layers)

	; debug / for now, since no hotkeys yet
    StopOnEscape := true

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



