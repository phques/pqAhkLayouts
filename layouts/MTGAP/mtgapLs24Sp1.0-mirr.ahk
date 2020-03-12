/*

2020-03-07
ls24spv1.0-mirr
MTGAP ansi angleZ BEAKL
24 keys (+space + 2shifts)
LaSalle fingering
Space on main

mirror of ls24spv1.0, vowels+space on right hand 
(was actually generated like this)

B was on dual mode left shift, which does not work well,
trying it on SP ! 
(actually a bit better results on KLA, lower distance, but higher same finger (!?))

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgssp1.0-mirr"
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
    qwertyMask_std := "
    (Join`r`n
              w e r      u i o 
           @a s d f g  h j k l @; 
      @LShift z x c      m , . @/
    )"
    qwertyMask_wid := "
    (Join`r`n
              w e r        i o p
           @a s d f g    j k l ; @'
      @LShift z x c        , . / @RShift
    )"
    qwertyMask := qwertyMask_wid
    ; qwertyMask := qwertyMask_std

    layerMain_2 := "
    (Join`r`n
           s  t  h         i SP  e
     @<+f  r  d  n  m   g  a  u  o  @>+c
     @<+b  j  v  l         y  _  >  @>+-
    )"
    ; altGrTap := 'b'
    altGrTap := 'v'  ; V is hard to reach, so put THAT one on SP

    layerAlt := "
    (Join`r`n
           "  w  :         (  .  ,
     @<+z  x  )  k  =   ?  p  '  /  @>+!
     @<+*  +  {  q         ;  }  [  @>+]
    )"

    ; can be used with left hand moved (thumb on Alt, or on home pos)
    layerEdit3 := "
    (Join`r`n
          Del BS Esc         ^z   Up  Right 
     Ctrl Sh ^BS Sh .    ^x Left Home End Down
     Del . Ins BS            ^c   ^v   .  ^v
    )"

    numpadLayers := NumpadLayerMappings()

    ; use std extend layout, have to get used to switching to old way!
    layerExtend := layerEdit3
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
            ; map: layerEdit3, 
            map: layerExtend, 
        },

        ; would've liked  to use V here, but it screws up??
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

; Win-N inserts ING
; since IG is not comfy, and I noticed it is often used in ing 
; (going, intersting, everything, string)
LWin & sc031::Send("ing")
