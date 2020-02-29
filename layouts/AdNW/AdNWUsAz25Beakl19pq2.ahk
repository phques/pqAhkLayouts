/*

2020-02-29
AdNW ansi angleZ BEALK19 pq
22 keys, space on main keys (+space + 2shifts)
ie Den's PLLT. pinky less, less thumb, but space back on spacebar
Has french layer too 

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
  qwertyMask := "
  (Join`r`n
      w e r      u i o  
    a s d f g  h j k l ;
      z x c      m , .  
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
  ; copy from BEAKL PLLT x1, slightly modified PQ (including B now on main)

  ; ' !# ?(-)$ {=}& *"/ +
  ; ` | <_> [@]% ^\ ~

  layerAlt := "
  (Join`r`n
      q ' j        v ! #     
    ? ( - ) $    z { = } &   
      * " /        k x +  
  )"

  layerAltSh := "
  (Join`r`n
      Q ~`` J        V |  .      
    < < _   > .   Z ~[ @ ~] %   
      ^ ~- ~\        K X  ~  
  )"

  ; need to move QJ to right hand !
  layerAlt_2fr := "
  (Join`r`n
    q w e r    u i o p     ë î ï â      v j ' /
    a s d f g  h j k l ;   ê è é à ä  z « ! » ç
      z x c v  n m , .      ù û ô œ  - k x q  
  )"
  layerAlt_2frsh := "
  (Join`r`n
    q w e r    u i o p     Ë Î Ï Â      V J " ~\
    a s d f g  h j k l ;   Ê È É À Ä  Z ( ? ) Ç
      z x c v  n m , .       Ù Û Ô Œ  + K X Q  
  )"

  ; -----------

  layerMain := layerMain_2
  layerMainSh := layerMain_2sh

  numpad := NumpadLayerMappings()
  extendLayer := ExtendLayerMappings()


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

      {id: "french", 
        map: layerAlt_2fr,
        mapSh: layerAlt_2frsh,
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
  french := layerDefsById["french"]

  main.AddMappingsFromTo("v", "Backspace", false)
  main.AddMappingsFromTo("v", "~Delete", true)

  ; add enter on ' and Shift on / 
  main.AddMappingsFromTo("'", "Enter", false)
  main.AddMappingsFromTo("'", "+Enter", true)

  main.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  main.AddMappingsFromTo("/", "RSh", true) ;; shift on /

  syms.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  syms.AddMappingsFromTo("/", "RSh", true) ;; shift on /

  french.AddMappingsFromTo("/", "RSh", false) ;; shift on /
  french.AddMappingsFromTo("/", "RSh", true) ;; shift on /
}

swapSymsAndFrench()
{
  ; get syms layer access keydef, on main layer 
  mainLayer := layerDefs[1]
  syms := layerDefsById["syms"]
  french := layerDefsById["french"]

  symsAccessKeydef := mainLayer.GetKeydef(syms.key)

  if (symsAccessKeydef.layerId == "syms") {
    symsAccessKeydef.layerId := "french"
    mainLayer.id := "mainfr"
  }
  else {
    symsAccessKeydef.layerId := "syms"
    mainLayer.id := "main"
  }
}

;----------

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

LWin & Insert::swapSymsAndFrench()
