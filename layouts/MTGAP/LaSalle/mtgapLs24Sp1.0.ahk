/*

2020-03-01
ls24spv1.0
trying to see if I can place space on main !??
took out $
MTGAP ansi angleZ BEAKL
24 keys (+space + 2shifts)
LaSalle fingering
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\ls24Beakl19"
global ImgWidth := 164
global ImgHeight := 94
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
	; try both hands a std pos
	qwertyMask_std := "
	(Join`r`n
	          w e r      u i o 
	        a s d f g  h j k l ; 
	  @LShift z x c      m , . /
	)"
	qwertyMask_wid := "
	(Join`r`n
	          w e r        i o p
	        a s d f g    j k l ; '
	  @LShift z x c        , . / @RShift
	)"
	qwertyMask := qwertyMask_wid

	layerMain_2 := "
	(Join`r`n
		    e  Sp i          h  t  s    
		 c  o  u  a  g    m  n  d  r  f 
		 -  >  _  y          l  v  j  b 
	)"
    altGrTap := 'v'  ; V is hard to reach, so put THAT one on SP
    altGrTap := 'b'


	layerAlt := "
	(Join`r`n
		    ,  .  (          :  w  "    
		 !  /  '  p  ?    =  k  )  x  z 
		 ]  [  }  ;          q  {  +  *
	)"

	; need backspace (and delete) ?
	layerEdit1 := "
	(Join`r`n
		  . . .        Home  Up  End
	 Ctrl Sh . . .  ^z Left Down Right ^x
		. . . Alt        ^c   .    .   ^v
	)"
	layerEdit2 := "
	(Join`r`n
		  . . .         ^z   Up  Right 
	 Ctrl Sh . . .  ^x Left Home Down End
		. . . Alt       ^c   .     .  ^v
	)"

	numpadLayers := NumpadLayerMappings()

    ; use std extend layout, have to get used to switching to old way!
    layerExtend := layerEdit3
    layerExtend := ExtendLayerMappingsWide()

	layers := [
	    {id: "main", 
	     	qwertyMask: qwertyMask,
	     	map: layerMain_2, 
	     	;mapSh: layerMainSh
	    },

	    {id: "syms", key: "Space", tap: altGrTap,
	    	qwertyMask: qwertyMask, 
	    	map: layerAlt, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	; qwertyMask: qwertyMask, 
	    	; map: layerEdit2, 
	    	map: layerExtend, 
		},

		; would've liked  to use V here, but it screws up??
	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.thumbOnBwide, 
		},

	]

	; dont create layout hotkeys for these
	; for eg, we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	main := layerDefsById["main"]
    altGr := layerDefsById["syms"]

    if (qwertyMask == qwertyMask_std) {
        main.AddMappingsFromTo("p", "Backspace", false)
        main.AddMappingsFromTo("p", "~Delete", true)
        main.AddMappingsFromTo("'", "Enter", false)
        main.AddMappingsFromTo("'", "Enter", true)
    }
    else {
        main.AddMappingsFromTo("[", "Backspace", false)
        main.AddMappingsFromTo("[", "~Delete", true)

        main.AddMappingsFromTo("n", "Control", false)
        main.AddMappingsFromTo("n", "Control", true)
        altGr.AddMappingsFromTo("n", "Control", false)
        altGr.AddMappingsFromTo("n", "Control", true)
    }

    main.AddMappingsFromTo("q", "Esc", false)
    main.AddMappingsFromTo("q", "+Esc", true)
    main.AddMappingsFromTo("t", "Tab", false)
    main.AddMappingsFromTo("t", "+Tab", true)


}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
