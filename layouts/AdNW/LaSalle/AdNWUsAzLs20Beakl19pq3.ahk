/*

2019-03-17
AdNW ansi angleZ BEALK19 pq3
20 keys (+space + 2shifts)
LaSalle fingering

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls20Beakl19pq3"
global ImgWidth := 164
global ImgHeight := 94
global CenterOnCurrWndMonitor := 1

; for easyDragWindow script
global DoubleAlt := 0


#include ../../../fromPkl/pkl_guiLayers.ahk
#include ../../../layersv2c.ahk
#include ../../punxLayer.ahk
#include ../../extendLayer.ahk
#include ../../numpadLayer.ahk
#include qwerty20Masks.ahk

; ----

CreateLayers()
{
	lsh := false
	rsh := true
	qwertyMask20 := GetQwerty20Mask(lsh, rsh)

	; -2 seems to have better scrore (lower same finger than -3)
	; feels better too
	layerMain_2 := "
	(Join`r`n
		  o e u       d s n   
		g h a i p   f t l r c 
		b     y       m     w 
	)"
	layerMain_3 := "
	(Join`r`n
		  o e u       d t n  
		p h i a g   c s l r m
		b     y       f     w
	)"

	layerAlt := "
	(Join`r`n
		  ' , z       ) . k  
		? " q - :   ( v j x $
		%     ;       !     @
	)"

	; need backspace and delete
	layerEdit1 := "
	(Join`r`n
		  . . .        Home  Up  End
	 Ctrl Sh . . .  ^z Left Down Right ^x
		.     Alt        ^c            ^v
	)"
	layerEdit2 := "
	(Join`r`n
		  . . .         ^z   Up  Right 
	 Ctrl Sh . . .  ^x Left Home Down End
		.     Alt       ^c            ^v
	)"

	layerEdit3 := "
	(Join`r`n
		  . . .          ^x  Up  End
	 Ctrl Sh . . .  ^z Left Home Down Right
		.     Alt      ^c             ^v
	)"
	layerEdit4 := "
	(Join`r`n
		  . . .        Home  Up  End
	 Ctrl Sh . . .  ^c Left Down Right ^v
		.     Alt       ^z             ^x
	)"
	layerEdit5 := "
	(Join`r`n
		  . . .          ^x Left Right 
	 Ctrl Sh . . .  ^z Home Down Up   End
		.     .          ^c           ^v
	)"	
	layerEdit6 := "
	(Join`r`n
		  . . .        Home   Up  End
	 Ctrl Sh . . .  ^z Left Right Down ^x
		.     Alt       ^c             ^v
	)"

	; for \, use actual key, not to far anyways
	; missing / 
	layerPunx := "
	(Join`r`n
	      < - >     `` [ ] 
	    _ ( & ) !  : { = } *
	    #     +      ^     | 
	)"

	; layerPunx_ := "
	; (Join`r`n
	;         q w e r t    u i o p      $ < - > %    ~ [ ] @
	;      CL a s d f g  h j k l ;    _ \ ( " ) !  % { = } ;
	;      @LSh z x c v    m , . /      # : * + ``   & ^ _ | 
	; )"

	; extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	; altKey := (rsh ? "RAlt" : "Space")
	; punxTap := (rsh ? 0      : "Space")
	altKey := "Space"
	altTap := "Space"
	punxKey := (rsh ? "m" : "n")
	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask20,
	     	map: layerMain_2, 
	     	;mapSh: layerMainSh
	    },

	    {id: "alt", key: altKey, tap: altTap,
	    	qwertyMask: qwertyMask20, 
	    	map: layerAlt, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	qwertyMask: qwertyMask20, 
	    	map: layerEdit1, 
	    	; map: extendLayer, 
		},

	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.indexOnB, 
		},

	    {id: "punx", key: punxKey,
	    	qwertyMask: qwertyMask20, 
	    	map: layerPunx, 
		},

	]

	; dont create layout hotkeys for these
	; for eg, we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	main := layerDefsById["main"]
	main.AddMappings("@LControl  Escape", false)
	if (rsh)
		main.AddMappings("]  Backspace", false)
	else
		main.AddMappings("[  Backspace", false)

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx := layerDefsById["alt"]
	punx.AddMappings("b  Space", false)

	if (rsh)
	    main.AddMappings(", Enter", false)
	    ; main.AddMappings("m Enter", false)

	; SetMouseDragKeys("space", "control")
}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk

