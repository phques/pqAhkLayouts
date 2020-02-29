/*  http://shenafu.com/smf/index.php?topic=89.msg2409;topicseen#msg2409
(Den)
PLLT may be my other radical idea here. 
"Pinky-Less, Less Thumb" further minimizes pinkies by eliminating the remote corner keys hit 
by the pinkies. also theoretically thumbs are slower than other fingers, 
so move the most used character (Space) away from thumb. on the other hand,
 thumbs are detached from other fingers, so they are more flexible for chording. 
 such that thumbs are more ideal to be utilized as shifts and modifier keys.

PQ
kinda fits with what I like, was using Space as Alt layer dual mode key,
in this it becomes only alt layer key.
Small changes as suggested by Den

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgsb"
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
      z   c    n m , . 
  )"

  ; shift right hand ->
  ; supposedly more ergo, also, Enter and RShift are nearer 
  qwertyMask_wide := "
  (Join`r`n
      w e r        i o p
    a s d f g    j k l ; '
      z   c      m , . /
  )"

  rightSh := 0
  if (rightSh == 0)
    qwertyMask := qwertyMask_std
  else 
    qwertyMask := qwertyMask_wide


  layerMain := "
  (Join`r`n
        i u  o        m d n     
      y e Sp a g    l r t s p   
        ,    .      w h c f     
  )"

  layerMainSh := "
  (Join`r`n
        I U O        M D N     
      Y E " A G    L R T S P   
       ~;   :      W H C F     
  )"

  layerAlt := "
  (Join`r`n
        q ' j        v ! #     
      ? ( - ) $    + { = } &   
        *   /      z k x b  
  )"

  ; Q.J => actual Q J,  (use . as filler)
  ; ditto ZV| and <_>`
  ; use empty QJ spot to add '-', so it is easy to do "->"
  layerAltSh := "
  (Join`r`n
        Q ~`` J        V |  .      
      . < _  > ~-   ~ ~[ @ ~] %   
        ^   ~\      Z  K X  B     
  )"

  extendLayer := ExtendLayerMappings()
  numpadLayers := NumpadLayerMappings()

  layers := [
      {id: "main", 
        qwertyMask: qwertyMask,
        map: layerMain, 
        mapSh: layerMainSh
      },

      {id: "syms", key: "Space", ;tap: "Space",
        qwertyMask: qwertyMask,
        map: layerAlt,
        mapSh: layerAltSh,
      },

      {id: "edit", key: "LAlt", toggle: true,
        map: extendLayer, 
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
  syms := layerDefsById["syms"]

  ; PQ extras / adaptations for US kbd
  main.AddMappingsFromTo("v", "Backspace", false)
  main.AddMappingsFromTo("v", "~Delete", true)

  ; if right hand on std pos, add enter on '
  ; and Shift on / 
  if (rightSh == 0) {
    main.AddMappingsFromTo("'", "Enter", false)
    main.AddMappingsFromTo("'", "+Enter", true)

    main.AddMappingsFromTo("/", "RSh", false) ;; shift on /
    main.AddMappingsFromTo("/", "RSh", true) ;; shift on /

    syms.AddMappingsFromTo("/", "RSh", false) ;; shift on /
    syms.AddMappingsFromTo("/", "RSh", true) ;; shift on /
  }

}

;---
CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
