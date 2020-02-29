/*  http://shenafu.com/smf/index.php?topic=89.msg2409;topicseen#msg2409
(Den)
PLLT may be my other radical idea here. 
"Pinky-Less, Less Thumb" further minimizes pinkies by eliminating the remote corner keys hit 
by the pinkies. also theoretically thumbs are slower than other fingers, 
so move the most used character (Space) away from thumb. on the other hand,
 thumbs are detached from other fingers, so they are more flexible for chording. 
 such that thumbs are more ideal to be utilized as shifts and modifier keys.

PQ
this one has space back on spacebar
** Modified to have 22 keys

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs__"
global ImgWidth := 160
global ImgHeight := 54
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
    a s d f g  h j k l ; 
      z x c      m , . 
  )"

  ; shift right hand ->
  ; supposedly more ergo, also, Enter and RShift are nearer 
  qwertyMask_wide := "
  (Join`r`n
      w e r        i o p
    a s d f g    j k l ; '
      z x c        , . /
  )"

  ; -----------

  ; prefered  -----------
  ; opt -2
  layerMain_2 := "
  (Join`r`n
        p o u      m l f  
      g t e a y  d r n s b
        . , i      h w c  
  )"

  layerMain_2sh := "
  (Join`r`n
        P  O U      M L F  
      G T  E A Y  D R N S B
        : ~; I      H W C  
  )"

  ; opt -3
  layerMain_3 := "
  (Join`r`n
        p o u       d n c   
      b i a e g   h r t s w 
        . , y       l m f   
  )"

  layerMain_3sh := "
  (Join`r`n
        P  O U       D N C   
      B I  A E G   H R T S W 
        : ~; Y       L M F   
  )"

  ; -----------
  ; copy from BEAKL PLLT x1, slightly modified PQ

  layerAlt := "
  (Join`r`n
        q ' j        v ! #     
      ? ( - ) $    k { = } &   
        * z  /        + x b  
  )"

  layerAltSh := "
  (Join`r`n
        Q ~`` J        V |  .      
      < < _  > ~-   K ~[ @ ~] %   
        ^ Z ~\         ~ X  B     
  )"

  ; -----------

  rightSh := 0
  qwertyMask := (rightSh ? qwertyMask_wide : qwertyMask_std)

  layerMain := layerMain_2
  layerMainSh := layerMain_2sh

  numpad := NumpadLayerMappings()
  numpadLayers := (rightSh ? numpad.indexOnBwide : numpad.indexOnB)
  extendLayer := (rightSh ? ExtendLayerMappingsWide() : ExtendLayerMappings())


  layers := [
      {id: "main", 
        qwertyMask: qwertyMask,
        map: layerMain, 
        mapSh: layerMainSh
      },

      {id: "syms", key: "Space", tap: "Space",
        qwertyMask: qwertyMask,
        map: layerAlt,
        mapSh: layerAltSh,
      },

      {id: "edit", key: "LAlt", toggle: true,
        map: extendLayer, 
      },

    ; would've liked  to use V here, but it screws up??
      {id: "numpad", key: "b", toggle: true,
        map: numpadLayers, 
      },

  ]

  ; dont create layout hotkeys for these
  ; for eg, we will use Win-XX for hotkeys to do actions
  ; we need to do it this way for the Suspend hotkey w. #SuspendExempt
  dontCreateHotkeys := [MakeKeySC("LWin")]

  InitLayout(layers, dontCreateHotkeys)

  ; PQ extras / adaptations for US kbd
  main := layerDefsById["main"]
  syms := layerDefsById["syms"]

  main.AddMappingsFromTo("v", "Backspace", false)
  main.AddMappingsFromTo("v", "~Delete", true)

  ; if right hand on std pos, 
  ; add enter on ' and Shift on / 
  if (rightSh == 0) {
    main.AddMappingsFromTo("'", "Enter", false)
    main.AddMappingsFromTo("'", "Enter", true)

    main.AddMappingsFromTo("/", "RSh", false) ;; shift on /
    main.AddMappingsFromTo("/", "RSh", true) ;; shift on /

    syms.AddMappingsFromTo("/", "RSh", false) ;; shift on /
    syms.AddMappingsFromTo("/", "RSh", true) ;; shift on /
  }  else {
    ; add Backspace on M for wide mod
    main.AddMappingsFromTo("m", "Backspace", false)
    main.AddMappingsFromTo("m", "~Delete", true)
  }

}

;---

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
