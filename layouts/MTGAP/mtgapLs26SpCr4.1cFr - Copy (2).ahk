/*

2020-03-23
mtgapLs26SpCr4.1cFr (french adaptation of mtgapLs26SpCr4.1c)
MTGAP ansi angleZ BEAKL
26 keys
LaSalle fingering
space & Cr on main, (pq mostly man syms)
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\spCr4.1c"
global ImgWidth := 160
global ImgHeight := 68
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
    ; added one key on right top digits cause of missing #
    qwertyMask_std := "
    (Join`r`n
          3 4             
       q w e r    y u i o p
    CL a s d f g  h j k l ; ' 
        z x c v   n m ,   
    )"

    qwertyMask_wid := "
    (Join`r`n
          3 4             
       q w e r    u i o p [  
    CL a s d f g  j k l ; ' Enter
        z x c v   m , .     
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid

    ;----------------

    ; added extra key top right digits cause of missing #,
    ; might as well use it here too!
    ; place / * on it instead
    layerMain := "
    (Join`r`n
           ?  '                    
        Cr a  e é       Tab h  t  s Bs
    LSh g  i  o SP  -    m  n  d  r  c RShift
           *  /  u  _    f  l  b
    )"
    altGrTap := 'b' 

    layerMainSh := "
    (Join`r`n
           &  @                    
        Cr A  E  É      Tab H  T  S ~Delete
     CL G  I  O  "  :    M  N  D  R  C RShift
         ~``  ~  U  ^    F  L  B
    )"

    ; swap # and +
    ; guess we dont need Esc here, can use it for extra - for "->"
    ; swap |} swap }+ give easier key to {}
    ; topright +  } 
    layerAlt := "
    (Join`r`n
            {  |              
        -  ;  .  «      Tab  x  p  v  BS
    LSh <  (  !  y  »     q  ,  k  )  > RShift
           %  #  z  w     =  j  $
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
            ; mapSh: layerAltSh, 
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

#include ../winHotkeys.ahk
