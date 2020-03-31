/*

2019-03-29
MTGAP ansi angleZ BEALK19 pq3
24 keys (+space + 2shifts)
LaSalle fingering

manually modified
 dont use 2 bottom mid fingers
 use ,. on main, added shift layers + more syms 
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\1.1b"
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
    qwertyMask24_std := "
    (Join`r`n
              w e r      u i o 
            a s d f g  h j k l ; 
      @LShift     c      m , . @/
    )"

    qwertyMask24_wid := "
    (Join`r`n
              w e r        i o p
            a s d f g    j k l ; '
      @LShift     c        , . / @RShift
    )"
    ; qwertyMask24_std := "
    ; (Join`r`n
    ;           w e r      u i o 
    ;         a s d f g  h j k l ; 
    ;   @LShift z x c      m , . /
    ; )"
    ; qwertyMask24_wid := "
    ; (Join`r`n
    ;           w e r        i o p
    ;         a s d f g    j k l ; '
    ;   @LShift z x c        , . / @RShift
    ; )"

    ; qwertyMask24 := qwertyMask24_std
    qwertyMask24 := qwertyMask24_wid

    ; -2 seems to have better scrore (lower same finger than -3)
    ; feels better too
    layerMain_2 := "
    (Join`r`n
          a e y      h t s  
        g u o i .  m n r d c
        ,     p      l q z @>+v
    )"
    layerMain_2sh := "
    (Join`r`n
          A E Y       H T S  
        G U O I :   M N R D C
       ~;     P       L Q Z @>+V
    )"

    layerAlt := "
    (Join`r`n
          k ' /       x w b 
        ? ( - ) &   = f { ! }  
        *     "       j - $ @>++
    )"
    layerAltsh := "
    (Join`r`n
          K  # ~\         X  W  B   
      ~- ~<  _ ~>  |  ~=  F ~[  @ ~]
        ^       :         J ``  _  @>+%
    )"

    ; original, symbols placed by MTGAP
    ; layerMain_2 := "
    ; (Join`r`n
    ;        a  e  y         h  t  s   
    ;     g  u  o  i  _   m  n  r  d  c
    ;     -  >  !  p         l  q  z  v
    ; )"

    ; layerAlt := "
    ; (Join`r`n
    ;         k  ,  ;         x  w  b   
    ;      ?  '  (  .  *   =  f  )  "  / 
    ;      $  +  [  :         j  ]  {  } 
    ; )"

    ; need backspace (and delete) ?
    layerEdit1 := "
    (Join`r`n
          . . .        Home  Up  End
     Ctrl Sh . . .  ^z Left Down Right ^x
        .     Alt        ^c   .    .   ^v
    )"
    layerEdit2 := "
    (Join`r`n
          . . .         ^z   Up  Right 
     Ctrl Sh . . .  ^x Left Home Down End
        .     Alt       ^c   .     .  ^v
    )"
    ; can be used with left hand moved (thumb on Alt, or on home pos)
    layerEdit3 := "
    (Join`r`n
          Del BS Esc         ^z   Up  Right 
     Ctrl Sh  .  Sh .  ^x Left Home End Down
     Del      BS           ^c   .     .  ^v
    )"

    numpadLayers := NumpadLayerMappings()

    layers := [
        {id: "main", 
            qwertyMask: qwertyMask24,
            map: layerMain_2, 
            mapSh: layerMain_2sh
        },

        {id: "syms", key: "Space", tap: "Space",
            qwertyMask: qwertyMask24, 
            map: layerAlt, 
            mapSh: layerAltSh, 
        },

        {id: "edit", key: "LAlt", toggle: true,
            qwertyMask: qwertyMask24, 
            map: layerEdit3, 
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

    ; for use w. both hands at std pos
    if (qwertyMask24 == qwertyMask24_std) {
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
