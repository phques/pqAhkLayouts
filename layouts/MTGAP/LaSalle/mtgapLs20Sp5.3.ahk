/*

2021-01-29
mtgapLs20Sp5.3

MTGAP ansi angleZ BEAKL
LaSalle fingering
20 keys, space on main

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\xx"
global ImgWidth := 160
global ImgHeight := 68
global CenterOnCurrWindow := 1
; global CenterOnCurrWndMonitor := 1

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

    qwertyMask_wid := "
    (Join`r`n
       w e r      i o p    
     a s d f g  j k l ; '
         c v    m ,      
    )"

    qwertyMask_widEx := "
    (Join`r`n
        q w e r t  u i o p [  
     CL a s d f g  j k l ; ' Enter
          x c v    m , .     
    )"

    qwertyMask := qwertyMask_wid
    qwertyMaskEx := qwertyMask_widEx


    ;----------------

    layerMainEx := "
    (Join`r`n
       Esc .  .  . Cr  Tab .  .  .  BS 
    LSh .  .  .  .  .   .  .  .  .  . RShift
             Tab .  .   .  .  Cr         
    )"
    layerMainExSh := "
    (Join`r`n
       Esc .  .  . Cr  Tab .  .  .  ~Delete 
     CL .  .  .  .  .   .  .  .  .  . CL
             Tab .  .   .  .  Cr         
    )"

    layerMainExWid := "
    (Join`r`n
        y     !Esc
        h     Ctrl
        n     Alt
    )"

    ;---------

    layerMain := "
    (Join`r`n
          a  e  v         h  t  s
       g  i  o SP  k   m  n  d  r  c
                u  '   f  l
    )"

    layerMainSh := "
    (Join`r`n
          A  E  V         H  T  S
       G  I  O  _  K   M  N  D  R  C
                U  '   F  L
    )"

    layerAlt := "
    (Join`r`n
          -  .  x         z  p  w
       (  )  ;  y  /   =  ,  b  j  "
                :  !   *  q
    )"

    layerAltSh := "
    (Join`r`n
          -  .  X         Z  P  W
       (  )  ;  Y  /   =  ,  B  J  "
                :  !   *  Q
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

        {id: "syms", key: "Space", 
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
    dontCreateHotkeys := [MakeKeySC("LWin"), MakeKeySC("ScrollLock")]

    InitLayout(layers, dontCreateHotkeys)

    ; add extra keys like Esc, Tab, Cr ..
    main := layerDefsById["main"]
    altGr := layerDefsById["syms"]

    CLayer.NoKeyChar := '.'
    main.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
    main.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)
    altGr.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
    altGr.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)

    ; if (qwertyMask == qwertyMask_wid) {
    ;   main.AddMappings(layerMainExWid, false)
    ;   main.AddMappings(layerMainExWid, true)
    ;   altGr.AddMappings(layerMainExWid, false)
    ;   altGr.AddMappings(layerMainExWid, true)
    ; }

    main.AddMappingsFromTo("1  2  3  4  5  6  7  8  9  0   -   =", 
                           "F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12", false)
    main.AddMappingsFromTo("1  2  3  4  5  6  7  8  9  0   -   =", 
                           "F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12", true)

}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
