/*

2019-03-17
AdNW ansi angleZ BEALK19 pq3
20 keys (+space + 2shifts)
LaSalle fingering
2019-03-29
adding french altGr
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
	; try both hands a std pos
	qwertyMask20 := GetQwerty20Mask2(0, 0)

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

	; missing âîûùï üëö
	layerAltFr := "
	(Join`r`n
		  ô é ê       . , k  
		q ' à è «   » v j x ç
		?     ;       !     z
	)"

	; strange idea: place missing âîûùï üëö on shift layer !
	layerAltFrSh := "
	(Join`r`n
		  Ô É Ê       ü ë K  
		Q â À È û   ù V J X Ç
		ï     î       ö     Z
	)"

	; for \, use actual key, not too far anyways
	; missing ` (added manually below)
	layerPunx := "
	(Join`r`n
	      < - >      / [ ] 
	    _ ( & ) !  : { = } *
	    #     +      ^     | 
	)"

	; need backspace (and delete) ?
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

	; other edit tests
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

	; layerPunx_ := "
	; (Join`r`n
	;         q w e r t    u i o p      $ < - > %    ~ [ ] @
	;      CL a s d f g  h j k l ;    _ \ ( " ) !  % { = } ;
	;      @LSh z x c v    m , . /      # : * + ``   & ^ _ | 
	; )"

	; extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask20,
	     	map: layerMain_2, 
	     	;mapSh: layerMainSh
	    },

	    {id: "alt", key: "Space", tap: "Space",
	    	qwertyMask: qwertyMask20, 
	    	map: layerAlt, 
	    },

	    {id: "altFr",
	    	qwertyMask: qwertyMask20, 
	    	map: layerAltFr, 
	    	mapSh: layerAltFrSh, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	qwertyMask: qwertyMask20, 
	    	map: layerEdit2, 
	    	; map: extendLayer, 
		},

		; would've liked  to use V here, but it screws up??
	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.thumbOnB, 
		},

	    {id: "punx", key: "n",  ;; both hands at std
	    ; {id: "punx", key: (rsh ? "m" : "n"),
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
	; main.AddMappings("@LControl  Escape", false)
	; main.AddMappingsFromTo((rsh ? "]" : "["), "Backspace", false)
	; main.AddMappingsFromTo((rsh ? "]" : "["), "~Delete", true)
	; main.AddMappingsFromTo((rsh ? "," : "m"), "Enter", false)
	; main.AddMappingsFromTo((rsh ? "," : "m"), "Enter", true)

	; for use w. both hands at std pos
	; trying not to use dualMode lshift, so try caps=lshift
	;#pq not working (under linux VM though which has probs remapping capsl)
	; main.AddMappingsFromTo("cl", "lshift", false)
	; main.AddMappingsFromTo("cl", "cl", true)
	main.AddMappingsFromTo("p", "Backspace", false)
	main.AddMappingsFromTo("p", "~Delete", true)
	main.AddMappingsFromTo("'", "Enter", false)
	main.AddMappingsFromTo("'", "Enter", true)

	; add Space on altGr  (hold will repeat! vs spacebar dual mode layer access which doesnt)
	altGr := layerDefsById["alt"]
	altGr.AddMappings("v  Space", false)

	punx := layerDefsById["punx"]
	punx.AddMappings("p  ``", false)

	; SetMouseDragKeys("space", "control")
}

swapFrenchAndPunx()
{
	; get alt layer access keydef, on main layer 
    mainLayer := layerDefs[1]
	altGr := layerDefsById["alt"]
    altGrAccessKeydef := mainLayer.GetKeydef(altGr.key)

    if (altGrAccessKeydef.layerId == "alt") {
    	altGrAccessKeydef.layerId := "altFr"
   }
    else {
    	altGrAccessKeydef.layerId := "alt"
    }

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk

LWin & Insert::swapFrenchAndPunx()
