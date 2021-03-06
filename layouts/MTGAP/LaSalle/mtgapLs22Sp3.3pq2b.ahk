/*

2020-03-20 / 2020-04-24
Ls22Sp3.3pq2b
MTGAP ansi angleZ BEAKL
LaSalle fingering
22 keys

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\sp3.3pq2b"
global ImgWidth := 164
global ImgHeight := 94
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
    ; try both hands a std pos
    qwertyMask_std := "
    (Join`r`n
           3          8  
        q w e r t  y u i o p
     CL a s d f g  h j k l ; '
            c v    n m ,   
    )"

    qwertyMask_wid := "
    (Join`r`n
           3          9  
        q w e r t  u i o p [  
     CL a s d f g  j k l ; ' Enter
            c v    m , .     
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid


    ;----------------
    ; b) Swap e-sp
    ; CrSh) According to info found in tests w. KLA, 
    ;  moving CR to mid left col and shifts up is better
    ;  try it instead of Shift on pinkies to the pitfalls they imply
    ; Also, I have placed Enter on V which is easier to access than T

    ; also add extra M beside L fopr LM (aLMost) since LM is hard
    layerMain := "
    (Join`r`n
              !                 w   
       Esc a  SP v  ``   Tab h  t  s BS
    LSh g  i  o  e  '     m  n  d  r  c RShift
                 u  CR    f  l  m   
    )"
    altGrTap := 'b' 

    layerMainSh := "
    (Join`r`n
              ?                 W   
       Esc A  "  V  ~    Tab H  T  S ~Delete
     CL G  I  O  E  _     M  N  D  R  C CL
                 U  CR    F  L  M  
    )"


    layerAlt := "
    (Join`r`n
              /                 b   
      Esc  -  y  :  >    Tab j  p  x BS
    LSh *  {  ;  .  +     =  ,  k  }  q RShift
                 (  CR    z  )  0       
    )"

    layerAltSh := "
    (Join`r`n
             ~\                 B   
       Esc &  Y  0  0    Tab J  P  X ~Delete
    LSh $ ~[  %  |  ^     #  @  K ~]  Q RShift
                 <  CR    Z  >  0    
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
    dontCreateHotkeys := [
        MakeKeySC("LWin"), 
        ; MakeKeySC("CapsLock"),  ; need to use ahk hotkey def to map CL to Shift
    ]

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

    main.AddMappingsFromTo("1  2     4  5  6  7  8     0   -   =", 
                           "F1 F2    F4 F5 F6 F7 F8    F10 F11 F12", false)
    main.AddMappingsFromTo("1  2     4  5  6  7  8     0   -   =", 
                           "F1 F2    F4 F5 F6 F7 F8    F10 F11 F12", true)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----


#include ../../winHotkeys.ahk

