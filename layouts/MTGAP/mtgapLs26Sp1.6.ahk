/*

2020-03-08
ls26spv1.6
MTGAP ansi angleZ BEAKL
26 keys
LaSalle fingering
space on main
shift as dual mode on home row pinkies (eventually ! bug on alt layers now)
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgssp1.6"
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
    qwertyMask26_std := "
    (Join`r`n
              w e r      u i o 
           @a s d f g  h j k l @; 
      LShift z x c v  n m , . /
    )"

    qwertyMask26_wid := "
    (Join`r`n
              w e r        i o p
           @a s d f g    j k l ; @'
      LShift z x c v    m , . / RShift
    )"
    qwertyMask26 := qwertyMask26_wid
    ; qwertyMask26 := qwertyMask26_std

    layerMain_2 := "
    (Join`r`n
            a  e  v         h  t  s
      @<+g  i  o SP  -   m  n  d  r  @>+c
         '  =  *  u  _   f  l  q  j  b
    )"
    altGrTap := 'y'

    layerAlt := "
    (Join`r`n
            "  .  ?         !  p  w
      @<+(  )  ;  y  [   ]  ,  k  x  @>+z
         {  &  <  /  \   +  :  >  |  }
    )"


    ; can be used with left hand moved (thumb on Alt, or on home pos)
    layerEdit3 := "
    (Join`r`n
          Del BS Esc           ^z   Up  Right 
     Ctrl Sh ^BS Sh .    ^x Left Home End Down
      Del  . Ins BS .     .  ^c   ^v   .  ^v
    )"

    numpadLayers := NumpadLayerMappings()

    layerExtend := layerEdit3
    layerExtend :=ExtendLayerMappingsWide()

    layers := [
        {id: "main", 
            qwertyMask: qwertyMask26,
            map: layerMain_2, 
            ;mapSh: layerMainSh
        },

        {id: "syms", key: "Space",  tap: altGrTap,
            qwertyMask: qwertyMask26, 
            map: layerAlt, 
        },

        {id: "edit", key: "LAlt", toggle: true,
            ; qwertyMask: qwertyMask26, 
            map: layerExtend, 
        },

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

    if (qwertyMask26 == qwertyMask26_std) {
        main.AddMappingsFromTo("p", "Backspace", false)
        main.AddMappingsFromTo("p", "~Delete", true)
        main.AddMappingsFromTo("'", "Enter", false)
        main.AddMappingsFromTo("'", "Enter", true)
    }
    else {
        main.AddMappingsFromTo("[", "Backspace", false)
        main.AddMappingsFromTo("[", "~Delete", true)
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
