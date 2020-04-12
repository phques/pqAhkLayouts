/*

2020-04-11
mgtapLs23Sp5.2

MTGAP ansi angleZ BEAKL
LaSalle fingering
22 keys + thumb (space)

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\Sp5.2"
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
    qwertyMask_std := "
    (Join`r`n
        3          8
       w e r      u i o  
     a s d f g  h j k l ; 
         c v    n m    
    )"

    qwertyMask_wid := "
    (Join`r`n
        3          9
       w e r      i o p    
     a s d f g  j k l ; '
         c v    m ,      
    )"

    qwertyMask_stdEx := "
    (Join`r`n
           3          8  
        q w e r t  y u i o p
     CL a s d f g  h j k l ; '
            c v    n m    
    )"

    qwertyMask_widEx := "
    (Join`r`n
           3          9  
        q w e r t  u i o p [  
     CL a s d f g  j k l ; ' Enter
            c v    m ,      
    )"

    ; qwertyMask := qwertyMask_std
    ; qwertyMaskEx := qwertyMask_stdEx
    qwertyMask := qwertyMask_wid
    qwertyMaskEx := qwertyMask_widEx


    ;----------------

    layerMainEx := "
    (Join`r`n
              .               .      
       Esc .  .  . Cr  Tab .  .  .  BS 
    LSh .  .  .  .  .   .  .  .  .  . RShift
                 .  .   .  .           
    )"
    layerMainExSh := "
    (Join`r`n
              .               .      
       Esc .  .  . Cr  Tab .  .  .  ~Delete 
     CL .  .  .  .  .   .  .  .  .  . CL
                 .  .   .  .           
    )"

    layerMainExWid := "
    (Join`r`n
        y     .
        h     Ctrl
        n     Alt
    )"

    ;---------

    layerMain := "
    (Join`r`n
            :               v
         a  e  p         h  t  s
      g  i  o SP  -   m  n  r  d  c
               u  '   f  l
    )"
    altGrTap := 'q' 
    altGrTapSh := 'Q'

    layerMainSh := "
    (Join`r`n
            +               V
         A  E  P         H  T  S
      G  I  O  @  _   M  N  R  D  C
               U ~``  F  L
    )"

    ; originally miss <>\+|&$%@#^`~
    layerAlt := "
    (Join`r`n
            {               }
         "  .  !         ?  w  b
      (  )  ;  y  /   =  ,  k  x  z
               [  ]   *  j
    )"

    layerAltSh := "
    (Join`r`n
            #               }
         & ~-  |         ?  W  B
      <  >  $  Y ~\   : ~=  K  X  Z
               %  ^   ~  J
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

    ; add extra keys like Esc, Tab, Cr ..
    main := layerDefsById["main"]
    altGr := layerDefsById["syms"]

    CLayer.NoKeyChar := '.'
    main.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
    main.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)
    altGr.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
    altGr.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)

    if (qwertyMask == qwertyMask_wid) {
      main.AddMappings(layerMainExWid, false)
      main.AddMappings(layerMainExWid, true)
      altGr.AddMappings(layerMainExWid, false)
      altGr.AddMappings(layerMainExWid, true)
    }

}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
