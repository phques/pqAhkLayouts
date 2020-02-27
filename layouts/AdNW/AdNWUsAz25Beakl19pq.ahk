/*

2020-02-26
AdNW ansi angleZ BEALK19 pq
22 keys, space on main keys (+space + 2shifts)
ie Den's PLLT. pinky less, less thumb

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\az25Beakl19pq"
global ImgWidth := 182
global ImgHeight := 48
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
	; using AngleZ ergo mod (lower left hand shifted left by 1)
	; actyually mirrored left/right vs AdNW output

	;alternate ( opt -3 vs -2)
	layerMain_3 := "
	(Join`r`n
	    w e r       u i o        h o u       m s l  
	  a s d f g   h j k l ;   p SP e a .   g t n r c
	    z x c      m , .        y , i       d f w  
	)"
	layerMain_3sh := "
	(Join`r`n
	    w e r       u i o        H O U       M S L  
	  a s d f g   h j k l ;   P SP E A :   G T N R C
	    z x c      m , .        Y ~; I       D F W  
	)"

	; dup I to bott-center, for IO
	layerMain_2 := "
	(Join`r`n
	    w e r       u i o       h i .        c r l  
	  a s d f g   h j k l ;  g SP e a ,    f t s n p
	    z x c v     m , .       y u o i      d w m  
	)"

	layerMain_2sh := "
	(Join`r`n
	    w e r       u i o       H I :        C R L   
	  a s d f g   h j k l ;  G SP E A ~;   F T S N P 
	    z x c v     m , .       Y U O I      D W M   
	)"

	; copied/modified from BEAKL PLLT x1
	layerAlt := "
	(Join`r`n
	    w e r       u i o         q ' j        v ! #  
	  a s d f g   h j k l ;     ? ( - ) $    k { = } &
	    z   c     n m , .         *   /      z + x b  
	)"

	layerAltSh := "
	(Join`r`n
	  q w e r         i o       Q Q ~`` J        V |     
	  a s d f g   h j k l ;     < < _  > ~-   K ~[ @ ~] %   
	    z   c     n m , .         ^   ~\      Z  ~ X  B     
	)"

	; created this one based on my std punxLayer, 
	; adding bvkqxjz
	__layerPunx := "
	(Join`r`n
	    w e r       u i o         h o u      l s m  
	  a s d f g   h j k l ;     p   e a .  c r n t g
	    z x c       m , .         y , i      w f d  
	)"

	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	     	map: layerMain_3, 
	     	mapSh: layerMain_3Sh
	    },

	    {id: "syms", key: "Space", ;tap: "Space",
	    	map: layerAlt,
	    	mapSh: layerAltSh
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
	
	; ## dont remap Numpad5, for some reason it does not work correctly 
	dontCreateHotkeys := [MakeKeySC("LWin"), MakeKeySC("Numpad5")]

	InitLayout(layers, dontCreateHotkeys)

	syms := layerDefsById["syms"]
	main := layerDefsById["main"]

	; add Space on syms B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	syms.AddMappings("b  Space", false)

    main.AddMappingsFromTo("'", "Enter", false)
    main.AddMappingsFromTo("'", "+Enter", true)

	main.AddMappingsFromTo("v", "Backspace", false)
	main.AddMappingsFromTo("v", "~Delete", true)

    main.AddMappingsFromTo("/", "RSh", false) ;; shift on /
    main.AddMappingsFromTo("/", "RSh", true) ;; shift on /

    syms.AddMappingsFromTo("/", "RSh", false) ;; shift on /
    syms.AddMappingsFromTo("/", "RSh", true) ;; shift on /

	; SetMouseDragKeys("space", "control")
}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
