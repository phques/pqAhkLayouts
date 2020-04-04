/*

2020-03-18
ls28spv3.3(b)
MTGAP ansi angleZ BEAKL
LaSalle fingering
28 keys

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\sp3.3"
global ImgWidth := 160
global ImgHeight := 68
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
    qwertyMask_std := "
    (Join`r`n
           3 4         9 0
       q w e r t  y u i o p
    CL a s d f g  h j k l ; ' 
        z x c v    n m , . 
    )"

    qwertyMask_wid := "
    (Join`r`n
           3 4         0 -
       q w e r t  u i o p [  
    CL a s d f g  j k l ; ' Enter
        z x c v    m , . /   
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid

    ;----------------

    layerMain := "
    (Join`r`n
           ?  :                 w  z
       Esc a  e  v Cr    Tab h  t  s Bs
    LSh g  i  o SP  '     m  n  d  r  c RShift
           !  $  u  _     f  l  b  j
    )"
    altGrTap := 'b' 


    layerAlt := "
    (Join`r`n
           %  [                 ]  +
       Esc -  .  / Cr    Tab *  p  x  Bs
     CL (  )  ;  y  \     =  ,  k  "  q RShift
           @  <  >  #     {  }  |  &
    )"

    ; need these for shift-Bs to do Del
    layerMainSh := "
    (Join`r`n
           ^  :                 W  Z
       Esc A  E  V Cr    Tab H  T  S ~Delete
    LSh g  I  O SP ``     M  N  D  R  C RShift
           !  $  U  ~     F  L  B  J
    )"
    layerAltSh := "
    (Join`r`n
           %  [                 ]  +
       Esc -  .  / Cr    Tab *  P  X  ~Delete
    LSh (  )  ;  Y  \     =  ,  K  "  Q RShift
           @  <  >  #     {  }  |  &
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
    dontCreateHotkeys := [ MakeKeySC("LWin") ]

    InitLayout(layers, dontCreateHotkeys)

    main := layerDefsById["main"]
    altGr := layerDefsById["syms"]

    ; Shift-CapsLock for CapsLock still does not work well
    ; tab would be logical, but too habit breaking
    main.AddMappingsFromTo("``", "CapsLock", false)

    if (qwertyMask == qwertyMask_wid) {
        main.AddMappingsFromTo( "h", "Control", false)
        main.AddMappingsFromTo( "h", "Control", true)
        altGr.AddMappingsFromTo("h", "Control", false)
        altGr.AddMappingsFromTo("h", "Control", true)

        main.AddMappingsFromTo( "n", "Alt", false)
        main.AddMappingsFromTo( "n", "Alt", true)
        altGr.AddMappingsFromTo("n", "Alt", false)
        altGr.AddMappingsFromTo("n", "Alt", true)
    }
}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
