/*

2020-02-29
AdNW ansi angleZ BEALK19 pq
22 keys, space on main keys (+space + 2shifts)
ie Den's PLLT. pinky less, less thumb, but space back on spacebar

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs\az25Beakl19pq2"
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
      y i .      m s l       
    g h e a ,  b t n r c      
      p u o      d f w         
  )"

  layerMain_2sh := "
  (Join`r`n
      Y I :      M S L       
    G H E A ~; B T N R C      
      P U O      D F W         
  )"

  ; opt -3
  layerMain_3 := "
  (Join`r`n
	  p o .      d n l  
	w i e a g  f s r t c
	  y , u      h b m  
  )"

  layerMain_3sh := "
  (Join`r`n
	  P O  :      D N L  
	W I E  A G  F S R T C
	  Y ~; U      H B M  
  )"

  ; -----------
  ; copy from BEAKL PLLT x1, slightly modified PQ

  layerAlt := "
  (Join`r`n
        q ' j        v ! #     
      ? ( - ) $    z { = } &   
        * .  /        + x k  
  )"

  layerAltSh := "
  (Join`r`n
        Q ~`` J        V |  .      
      < < _   > .   Z ~[ @ ~] %   
        ^ ~- ~\        ~ X  K  
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


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
