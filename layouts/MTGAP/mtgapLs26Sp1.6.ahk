/*

2020-03-08
ls26spv1.6
MTGAP ansi angleZ BEAKL
26 keys
LaSalle fingering
space on main
shift as dual mode on home row pinkies (eventually ! bug on alt layers now)
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgssp1.6"
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
    qwertyMask26_std := "
    (Join`r`n
              w e r      u i o 
            a s d f g  h j k l ; 
      @LShift z x c b  n m , . @/
    )"

    qwertyMask26_wid := "
    (Join`r`n
              w e r        i o p
            a s d f g    j k l ; '
      @LShift z x c b    n , . / @RShift
    )"
    ; qwertyMask26 := qwertyMask26_wid
    qwertyMask26 := qwertyMask26_std

    layerMain_2 := "
    (Join`r`n
            a  e  v         h  t  s
         g  i  o SP  _   m  n  d  r  c
         '  =  !  u         l  b  j  @>+f
    )"
    altGrTap := 'b'

    layerAlt := "
    (Join`r`n
            -  .  x         z  p  w
         (  )  ;  y  /   *  ,  k  "  q
         {  }  [  ?         :  ]  +  >
    )"


    ; can be used with left hand moved (thumb on Alt, or on home pos)
    layerEdit3 := "
    (Join`r`n
          Del BS Esc           ^z   Up  Right 
     Ctrl Sh ^BS Sh .    ^x Left Home End Down
      Del  . Ins BS .     .  ^c   ^v   .  ^v
    )"

    numpadLayers := NumpadLayerMappings()

    layers := [
        {id: "main", 
            qwertyMask: qwertyMask26,
            map: layerMain_2, 
            ;mapSh: layerMainSh
        },

        {id: "syms", key: "Space",  tap: altGrTap,
            qwertyMask: qwertyMask26, 
            map: layerAlt, 
        },

        {id: "edit", key: "LAlt", toggle: true,
            qwertyMask: qwertyMask26, 
            map: layerEdit3, 
            ; map: extendLayer, 
        },

        ; would've liked  to use V here, but it screws up??
        {id: "numpad", key: "b", toggle: true,
            map: numpadLayers.thumbOnB, 
        },

    ]

    ; dont create layout hotkeys for these
    ; for eg, we will use Win-XX for hotkeys to do actions
    ; we need to do it this way for the Suspend hotkey w. #SuspendExempt
    dontCreateHotkeys := [MakeKeySC("LWin")]

    InitLayout(layers, dontCreateHotkeys)

    main := layerDefsById["main"]
    altGr := layerDefsById["syms"]

    if (qwertyMask26 == qwertyMask26_std) {
        main.AddMappingsFromTo("n", "Backspace", false)
        main.AddMappingsFromTo("n", "~Delete", true)
        main.AddMappingsFromTo("'", "Enter", false)
        main.AddMappingsFromTo("'", "Enter", true)
    }
    else {
        main.AddMappingsFromTo("m", "Backspace", false)
        main.AddMappingsFromTo("m", "~Delete", true)
    }

    main.AddMappingsFromTo("v", "Tab", false)
    main.AddMappingsFromTo("v", "+Tab", true)
    main.AddMappingsFromTo("t", "Esc", false)
    main.AddMappingsFromTo("t", "+Esc", true)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
