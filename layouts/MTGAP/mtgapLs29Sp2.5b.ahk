/*

2020-03-15
ls29spv2.5b
MTGAP ansi angleZ BEAKL
LaSalle fingering
28 keys + Thumb

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\sp2.5b"
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
    ; using dualmode shift on home row pinkies
    ; this is habt breaking ! so leave dualMode on real shift keys
    qwertyMask_std := "
    (Join`r`n
           3 4         9 0
          w e r      u i o
       @a s d f g  h j k l @;
        z x c v    n m , . 
    )"

    qwertyMask_wid := "
    (Join`r`n
           3 4         0 -
          w e r      i o p   
       @a s d f g  j k l ; @'
        z x c v    m , . /   
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid

    ;----------------
    /* Orig
       missing: `~
              +  ^            ]  &
           -  .  [         z  g  k
        /  :  ;  ,  \   {  p  )  "  $
           <  %  >  #   }  =  |  @
                                       *
              (  `            w  x
           a  e  v         h  t  n
        y  i  o SP  '   f  s  r  l  m
           ?  !  u  _   b  d  j  q
                                       c
    */

    layerMain := "
    (Join`r`n
              (  *            w  x
           a  e  v         h  t  n
     @<+y  i  o SP  '   f  s  r  l @>+m
           ?  !  u  _   b  d  j  q
    )"
    altGrTap := 'c' 


    layerAlt := "
    (Join`r`n
              +  ^            ]  &
           -  .  [         z  g  k
     @<+/  :  ;  ,  \   {  p  )  " @>+$
           <  %  >  #   }  =  |  @
    )"


    ;----------------


    numpadLayers := NumpadLayerMappings()

    ; use std extend layout vs LaSalle
    layerExtend := ExtendLayerMappingsWide()

    layers := [
        {id: "main", 
            qwertyMask: qwertyMask,
            map: layerMain, 
            mapSh: layerMainSh
        },

        {id: "syms", key: "Space",  tap: altGrTap,
            qwertyMask: qwertyMask, 
            map: layerAlt, 
            mapSh: layerAltSh, 
        },

        {id: "edit", key: "LAlt", toggle: true,
            ; qwertyMask: qwertyMask, 
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
