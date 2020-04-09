/*

2020-04-08
mtgapLs21SpCr4.8
MTGAP ansi angleZ BEAKL
LaSalle fingering
20 keys + thumb (space)

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgssp4.8"
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

; ----

CreateLayers()
{
    ; try both hands a std pos
    ; using dualmode shift on home row pinkies
    ; this is habt breaking ! so leave dualMode on real shift keys
    qwertyMask_std := "
    (Join`r`n
        q w e r t  y u i o p
     CL a s d f g  h j k l ; '
            c v    n m    
    )"

    qwertyMask_wid := "
    (Join`r`n
        q w e r t  u i o p [  
     CL a s d f g  j k l ; ' Enter
            c v    m ,      
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid


    ;----------------

    layerMain := "
    (Join`r`n
       Esc a  e  v Cr  Tab h  t  s  BS
    LSh g  i  o SP  _   m  n  r  d  c RShift
                 u  '   f  l
    )"
    altGrTap := '!' 

    layerMainSh := "
    (Join`r`n
       ESC A  E  V CR  TAB H  T  S  ~Delete
    LSH G  I  O SP  _   M  N  R  D  C RSHIFT
                 U  '   F  L
    )"


    layerAlt := "
    (Join`r`n
       Esc -  .  x  Cr Tab q  w  p  BS
    LSh (  ;  ,  k  :   =  y  b  "  ) RShift
                 z  /   *  j
    )"

    layerAltSh := "
    (Join`r`n
       ESC -  .  X  CR TAB Q  W  P  ~Delete
    LSH (  ;  ,  K  :   =  Y  B  "  ) RSHIFT
                 Z  /   *  J
    )"
    altGrTapSh := '?' 


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

        {id: "syms", key: "Space",  tap: [altGrTap, altGrTapSh],
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
        main.AddMappingsFromTo("y", "Tab", false)
        main.AddMappingsFromTo("y", "Tab", true)
    }
    else {
        main.AddMappingsFromTo("[", "Backspace", false)
        main.AddMappingsFromTo("[", "~Delete", true)

        main.AddMappingsFromTo("u", "Tab", false)
        main.AddMappingsFromTo("u", "Tab", true)

        main.AddMappingsFromTo("n", "Control", false)
        main.AddMappingsFromTo("n", "Control", true)
        altGr.AddMappingsFromTo("n", "Control", false)
        altGr.AddMappingsFromTo("n", "Control", true)

        main.AddMappingsFromTo( "h", "Alt", false)
        main.AddMappingsFromTo( "h", "Alt", true)
        altGr.AddMappingsFromTo("h", "Alt", false)
        altGr.AddMappingsFromTo("h", "Alt", true)
    }

    main.AddMappingsFromTo("q", "Esc", false)
    main.AddMappingsFromTo("q", "+Esc", true)
    main.AddMappingsFromTo("t", "Enter", false)
    main.AddMappingsFromTo("t", "+Enter", true)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
