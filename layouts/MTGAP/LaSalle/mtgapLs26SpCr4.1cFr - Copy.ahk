/*

2020-03-20
mtgapLs26SpCr4.1c 
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
       q w e r      u i o p
    CL a s d f g  h j k l ; ' 
        z x c v   n m ,   
    )"

    qwertyMask_wid := "
    (Join`r`n
          3 4             
       q w e r      i o p [  
    CL a s d f g  j k l ; ' Enter
        z x c v   m , .     
    )"
    ; qwertyMask := qwertyMask_std
    qwertyMask := qwertyMask_wid

    ;----------------

    layerMain := "
    (Join`r`n
           ?  '               
        Cr a  e  é          h  t  s Bs
    LSh g  i  o SP  -    m  n  d  r  c RShift
           *  /  u  _    f  l  b
    )"
    altGrTap := 'b' 

    ; top right  *  \
    layerMainSh := "
    (Join`r`n
           &  @               
        Cr A  E  É          H  T  S ~Delete
     CL G  I  O  "  :    M  N  D  R  C RShift
         ~``  ~  U  ^    F  L  B
    )"

    ; top right +  } 
    layerAlt := "
    (Join`r`n
            {  |              
       Esc ;  .  «           x  p  v  BS
    LSh <  (  !  y  »     q  ,  k  )  > RShift
           %  #  z  w     =  j  $
    )"

    ; ç«»éèêëàâäùûîïôœ
    ; à è ù
    layerFr1 := "
    (Join`r`n
           ?  '                     
        Cr à  è  é          h  t  s Bs
    LSh g  i  o SP  -    m  n  d  r  c RShift
           *  /  ù  _    f  l  b
    )"

    layerFr1Sh := "
    (Join`r`n
           ?  '                    
        Cr À  È  É          H  T  S Bs
    LSh G  I  O SP  -    M  N  D  R  C RShift
           *  /  Ù  _    F  L  B
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

        ; {id: "fr1", key: "9", toggle: true,
        ;     qwertyMask: qwertyMask, 
        ;     map: layerFr1, 
        ;     mapSh: layerFr1Sh, 
        ; },

        ; {id: "syms", key: "Space",  tap: altGrTap,
        ;     qwertyMask: qwertyMask, 
        ;     map: layerAlt, 
        ;     ; mapSh: layerAltSh, 
        ; },

        ; {id: "edit", key: "LAlt", toggle: true,
        ;     ; qwertyMask: qwertyMask, 
        ;     map: layerExtend, 
        ; },

        ; {id: "numpad", key: "b", toggle: true,
        ;     map: numpadLayers.thumbOnBwide, 
        ; },

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

    if ( false  && qwertyMask == qwertyMask_wid) {
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
