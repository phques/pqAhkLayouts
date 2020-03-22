/*

2020-03-20
lsUs28spv3.3pq1(bCrSh)
MTGAP ansi angleZ BEAKL
LaSalle fingering
22 keys

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgssp3.3pq2"
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
           3           9  
        q w e r t  y u i o p
     CL a s d f g  h j k l ; '
            c v    n m ,   
    )"

    qwertyMask_wid := "
    (Join`r`n
           3           0  
        q w e r t  u i o p [  
     CL a s d f g  j k l ; ' Enter
            c v    m , .     
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid


    ;----------------
    ; b) Swap ,-   <-not used !
    ; CrSh) According to info found in tests w. KLA, 
    ;  moving CR to mid left col and shifts up is better
    ;  try it instead of Shift on pinkies to the pitfalls they imply
    ; Also, I have placed Enter on V which is easier to access than T

    ; also add extra M beside L fopr LM (aLMost) since LM is hard
    layerMain := "
    (Join`r`n
              !                 w   
       Esc a  e  v  ``   Tab h  t  s BS
    LSh g  i  o SP  '     m  n  d  r  c RShift
                 u  CR    f  l  m   
    )"
    altGrTap := 'b' 

    layerMainSh := "
    (Join`r`n
              ?                 W   
       Esc A  E  V  ~    Tab H  T  S ~Delete
     CL G  I  O  "  _     M  N  D  R  C CL
                 U  CR    F  L  M  
    )"


    layerAlt := "
    (Join`r`n
              /                 b   
      Esc  -  .  :  >    Tab j  p  x BS
    LSh *  {  ;  y  +     =  ,  k  }  q RShift
                 (  CR    z  )  0       
    )"

    layerAltSh := "
    (Join`r`n
              \                 B   
       Esc &  |  0  0    Tab J  P  X ~Delete
    LSh $  [  %  Y  ^     #  @  K  ]  Q RShift
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

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----


#include ../winHotkeys.ahk

