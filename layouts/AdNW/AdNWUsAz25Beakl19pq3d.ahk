﻿/*

2020-03-01
AdNW ansi angleZ BEALK19 pq
22 keys, space on main keys (+space + 2shifts)
ie Den's PLLT. pinky less, less thumb, (space on main, other key on spacebar)
no X used
Space fixed on center of 3x3 block

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\az25Beakl19pq3c"
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
  qwertyMask := "
  (Join`r`n
      w e r      u i o  
    a s d f g  h j k l ;
      z x c    n m , .  
  )"

  ; -----------

  ; opt -2
  layerMain_2 := "
  (Join`r`n
      o i  y      l r d  
    g a Sp e .  m n s t c
      , _  u    . h w f  
  )" 
  altLayerTapChar2 := "p"

  ; upper chars and ,. => ;:
  layerMain_2sh := "
  (Join`r`n
  )"

  ; opt -3, no AngleZ in cfg
  layerMain_3naz := "
  (Join`r`n
  )"
  altLayerTapChar3naz := "g"

  ; opt -3, AngleZ 
  layerMain_3az := "
  (Join`r`n
  )"
  altLayerTapChar3az := "g"

  ; upper chars and ,. => ;:
  layerMain_3sh := "
  (Join`r`n
  )"

  ; -----------
  ; copy from BEAKL PLLT x1, slightly modified PQ (including B now on main)

  ; ' !# ?(-)$ {=}& *"/ +
  ; ` | <_> [@]% ^\ ~

  layerAlt := "
  (Join`r`n
      q ' j        x ! #     
    ? ( - ) $    + { = } b   
      * " /      z v & k  
  )"

  layerAltSh := "
  (Join`r`n
      Q ~`` J        X |  .      
    < < _   > .   ~ ~[ @ ~] B   
      ^ ~- ~\     Z  V %  K  
  )"


  ; -----------

  layerMain := layerMain_2
  layerMainSh := layerMain_2sh
  altLayerTapChar := altLayerTapChar2

  numpad := NumpadLayerMappings()
  extendLayer := ExtendLayerMappings()


  layers := [
      {id: "main", 
        qwertyMask: qwertyMask,
        map: layerMain, 
        ;mapSh: layerMainSh
      },

      {id: "syms", key: "Space", tap: altLayerTapChar,
        qwertyMask: qwertyMask,
        map: layerAlt,
        mapSh: layerAltSh,
      },

      {id: "edit", key: "LAlt", toggle: true,
        map: extendLayer, 
      },

    ; would've liked  to use V here, but it screws up??
      {id: "numpad", key: "b", toggle: true,
        map: numpad.indexOnB, 
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

  main.AddMappingsFromTo("'", "Enter", false)
  main.AddMappingsFromTo("'", "+Enter", true)

  ; add Shift on / 
  main.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  main.AddMappingsFromTo("/", "RSh", true) ;; shift on /

  syms.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  syms.AddMappingsFromTo("/", "RSh", true) ;; shift on /
}

;----------

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
