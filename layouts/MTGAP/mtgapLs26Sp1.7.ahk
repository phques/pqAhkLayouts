/*

2020-03-09
ls26spv1.7
MTGAP ansi angleZ BEAKL
26 keys
LaSalle fingering
space on main
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgssp1.7"
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
    ; (also causes probs when using Shift as a normal key and we do for eg. ctrl-shift-up .. )
    qwertyMask_std := "
    (Join`r`n
              w e r      u i o 
           @a s d f g  h j k l @; 
     @LShift z x c v  n m , . @/
    )"

    qwertyMask_wid := "
    (Join`r`n
              w e r        i o p
           @a s d f g    j k l ; @'
     @LShift z x c v    m , . / @RShift
    )"
    qwertyMask := qwertyMask_wid
    ; qwertyMask := qwertyMask_std

    layerMain_2 := "
    (Join`r`n
            a  e  k         h  t  s
      @<+g  i  o SP  _   m  n  d  r  @>+c
      @<+'  ?  :  u  !   f  l  v  j  @>+b
    )"

    ; try swapped io
    ; lower same finger (ai I guess), butter higher distance/finger use
    ; also means IOn io os reverse roll
    ; layerMain_2 := "
    ; (Join`r`n
    ;         a  e  k         h  t  s
    ;   @<+g  o  i SP  _   m  n  d  r  @>+c
    ;   @<+'  ?  :  u  !   f  l  v  j  @>+b
    ; )"
    altGrTap := 'y' ; same-ginger with SP
    altGrTap := 'b' ; dual mode shift on bottom pinky
    altGrTap := 'v' ; hard to reach 

    layerAlt := "
    (Join`r`n
            -  .  /         z  p  w
      @<+(  )  ;  y  +   *  ,  "  =  @>+q
      @<+[  &  <  >  \   |  x  {  }  @>+]
    )"


    ; can be used with left hand moved (thumb on Alt, or on home pos)
    layerEdit3 := "
    (Join`r`n
          Del BS Esc           ^z   Up  Right 
     Ctrl Sh  .  Sh .    ^x Left Home End @>+Down
      Del  . Ins BS .     .  ^c   ^v   .  ^v
    )"

    numpadLayers := NumpadLayerMappings()

    ; use std extend layout, have to get used to switching to old way!
    ; layerExtend := layerEdit3
    layerExtend := ExtendLayerMappingsWide()

    layers := [
        {id: "main", 
            qwertyMask: qwertyMask,
            map: layerMain_2, 
            ;mapSh: layerMainSh
        },

        {id: "syms", key: "Space",  tap: altGrTap,
            qwertyMask: qwertyMask, 
            map: layerAlt, 
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
        main.AddMappingsFromTo("'", "Enter", false)
        main.AddMappingsFromTo("'", "Enter", true)
    }
    else {
        main.AddMappingsFromTo("[", "Backspace", false)
        main.AddMappingsFromTo("[", "~Delete", true)

        main.AddMappingsFromTo("n", "Control", false)
        main.AddMappingsFromTo("n", "Control", true)
        altGr.AddMappingsFromTo("n", "Control", false)
        altGr.AddMappingsFromTo("n", "Control", true)
    }

    main.AddMappingsFromTo("q", "Esc", false)
    main.AddMappingsFromTo("q", "+Esc", true)
    main.AddMappingsFromTo("t", "Tab", false)
    main.AddMappingsFromTo("t", "+Tab", true)

}

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
