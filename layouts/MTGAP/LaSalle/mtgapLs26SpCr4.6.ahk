/*

2020-04-05
mtgapLs26SpCr4.6 
MTGAP ansi angleZ BEAKL
26 keys
LaSalle fingering
space & Cr on main
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\spCr4.6"
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
           3 4         9  
       q w e r    y u i o p
    CL a s d f g  h j k l ; ' 
        z x c v   n m ,   
    )"

    qwertyMask_wid := "
    (Join`r`n
           3 4         0  
       q w e r    u i o p [  
    CL a s d f g  j k l ; ' Enter
        z x c v   m , .     
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid

    ;----------------
    ; originally missing: $&%@#^`~
    ;  

    layerMain := "
    (Join`r`n
           :  '                 w
       Esc a  e Cr       Tab h  t  s Bs
    LSh g  i  o SP  -     m  n  d  r  c RShift
           *  /  u  _     f  l  b
    )"
    altGrTap := 'b' 

    layerMainSh := "
    (Join`r`n
           ~ ~``              W
       Esc A  E Cr     Tab H  T  S ~Delete
     CL G  I  O  @  &   M  N  D  R  C RShift
           $  ^  U  #   F  L  B
    )"

    layerAlt := "
    (Join`r`n
           |  {               }
        %  y  .  ?     Tab z  p  x  BS
    LSh (  )  ,  k  \   =  v  ;  "  q RShift
           +  <  !  [   ]  j  >
    )"

    layerAltSh := "
    (Join`r`n
           .  .               .
       Esc Y  .  .     Tab Z  P  X  ~Delete
    LSh .  .  .  K  .   .  V  .  .  Q RShift
           .  .  .  .   .  J  .
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
        main.AddMappingsFromTo( "n", "Control", false)
        main.AddMappingsFromTo( "n", "Control", true)
        altGr.AddMappingsFromTo("n", "Control", false)
        altGr.AddMappingsFromTo("n", "Control", true)

        main.AddMappingsFromTo( "h", "Alt", false)
        main.AddMappingsFromTo( "h", "Alt", true)
        altGr.AddMappingsFromTo("h", "Alt", false)
        altGr.AddMappingsFromTo("h", "Alt", true)
    }
}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../../winHotkeys.ahk
