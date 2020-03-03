﻿/*  http://shenafu.com/smf/index.php?topic=89.msg2409;topicseen#msg2409
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
Small changes as suggested by Den (and some perso changes)

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

global altAccessTapFr := 0
global altAccessTap := 0
global altAccesKey := 0

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../punxLayer.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

; ----

CreateLayers()
{
  qwertyMask := "
  (Join`r`n
      w e r       u i o
    a s d f g   h j k l ; 
      z   c     n m , . 
  )"



  layerMain := "
  (Join`r`n
        i u  o        m d n     
      y e Sp a g    l r t s p   
        ,    .      _ h c f     
  )"
  layerMainSh := "
  (Join`r`n
        I U O        M D N     
      Y E " A G    L R T S P   
       ~;   :      _ H C F     
  )"

  altAccessTap := 'w'
  layerAlt := "
  (Join`r`n
        q ' j        x ! k     
      ? ( - ) $    # { = } b   
        *   /      z v & +  
  )"
  layerAltSh := "
  (Join`r`n
        Q ~`` J        X |  K      
      < < _  > ~-   . ~[ @ ~] B   
        ^   ~\      Z  V %  ~     
  )"

  ; need to move QJ to right hand !
  altAccessTapFr := 'z'
  layerAltfr := "
  (Join`r`n
    q w e r t    u i o p   ï î û ô œ    x q j ! 
    a s d f g  h j k l ;   è é ù à ä  - « ' » b
    z x c      n m , .       ê ë â    w v ç k  
  )"
  layerAltfrsh := "
  (Join`r`n
    Q W E R T    U I O P   Ï Î Û Ô Œ    X Q  J ?
    A S D F G  H J K L ;   È É Ù À Ä  + ( ~/ ) B
    Z X C      N M , .       Ê Ë Â    W V Ç  K  
  )"

  extendLayer := ExtendLayerMappingsAlt()
  numpadLayers := NumpadLayerMappings()

  altAccesKey := "Space"
  layers := [
      {id: "main", 
        qwertyMask: qwertyMask,
        map: layerMain, 
        mapSh: layerMainSh
      },

      {id: "syms", key: altAccesKey, tap: altAccessTap,
        qwertyMask: qwertyMask,
        map: layerAlt,
        mapSh: layerAltSh,
      },

      {id: "french", 
        map: layerAltfr,
        mapSh: layerAltfrsh,
      },

      {id: "edit", key: "LAlt", toggle: true,
      ; {id: "edit", key: "LAlt", toggle: true,
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
  french := layerDefsById["french"]

  ; PQ extras / adaptations for US kbd
  main.AddMappingsFromTo("v", "Backspace", false)
  main.AddMappingsFromTo("v", "~Delete", true)

  ; right hand on std pos, add enter on '
  ; and Shift on / 
  main.AddMappingsFromTo("'", "Enter", false)
  main.AddMappingsFromTo("'", "+Enter", true)

  main.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  main.AddMappingsFromTo("/", "RSh", true) ;; shift on /

  syms.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  syms.AddMappingsFromTo("/", "RSh", true) ;; shift on /

  french.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  french.AddMappingsFromTo("/", "RSh", true) ;; shift on /
}


; swap alt layer between syms and french
; we just change the layer accessed by the layer access key !
swapSymsAndFrench()
{
  ; get syms layer access keydef, on main layer 
  mainLayer := layerDefs[1]
  symsAccessKeydef := mainLayer.GetKeydef(altAccesKey)

  if (symsAccessKeydef.layerId == "syms") {
    ; change the layer accessed by the layer access key
    symsAccessKeydef.layerId := "french"
    
    ; Change the Tap value of alt layer access key
    ; e.g. Space: w <-> Space: z
    symsAccessKeydef.AddMapping(altAccessTapFr, false, true)
    symsAccessKeydef.AddMapping(altAccessTapFr, true, true)
    ; tapVal := new COutput(altAccessTapFr)

    ; changing the main layer name changes the accessed img file
    mainLayer.id := "mainfr"
  }
  else {
    ; change the layer accessed by the layer access key
    symsAccessKeydef.layerId := "syms"

    ; Change the Tap value of alt layer access key
    ; e.g. Space: w <-> Space: z
    symsAccessKeydef.AddMapping(altAccessTap, false, true)
    symsAccessKeydef.AddMapping(altAccessTap, true, true)
    ; tapVal := new COutput(altAccessTap)

    ; changing the main layer name changes the accessed img file
    mainLayer.id := "main"
  }

  ; change the Tap value of alt layer access key
  ; e.g. Space: w <-> Space: z
  ; symsAccessKeydef.outTapValues := [tapVal, tapVal]
}


;---
CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

LWin & Insert::swapSymsAndFrench()
