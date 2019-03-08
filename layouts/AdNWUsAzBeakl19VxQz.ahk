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
; #include ../../common/fromPkl/pkl_guiLayers.ahk

; ----

go()
{
	; using AngleZ ergo mod (lower left hand shifted left by 1, pinky on dualmode Shift)
	layerMain := "
	(Join`r`n
	     q w e r t   y u i o p [     j u i o z  x d r l b BS
	  CL a s d f g   h j k l ; '   ; g h e a .  p t s n c ``
	  @LSh z x c v   n m , . /       q y ' , /  k f w m v
	)"

	layerMainsh := "
	(Join`r`n
	    q w e r t   y u i o p        J U I O Z  X D R L B
	    a s d f g   h j k l ; '      G H E A @  P T S N C ^
	 @LSh z x c v   n m , . /        Q Y _ ! ?  K F W M V
	)"


	layers := [
	    {id: "main"},
	    ; {id: "punx", key: "Space", tap: "Space"},
	    ; {id: "edit", key: "LAlt"}
	]
	mappings := [
	    {id: "main", map: layerMain, mapSh: layerMainSh},
	    ; {id: "punx", map: "a s d  , `; ." },
	    ; {id: "edit", key: "LAlt"}
	]

	InitLayout(layers, mappings)

	; test, add CtrlV on B
	main := layerDefsById["main"]
	main.AddMappings("b  ^v", false)

	; main.AddMappings("Capslock  `;", false)
	; main.AddMappings("[  backspace", false)
}

go()

;--------

return


