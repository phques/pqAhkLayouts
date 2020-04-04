/* 
2020-4-01
mtgapbeakl24-1.2

modified mtgap, BEAKL PLLT type of layout on 24 keys
Sp & Cr on main, 'keep paired'

setkeeppairschars: \n
set keepBrackets 1

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
   CL a s d f g  h j k l ; '
        z x c v  n m , . 
  )"

  ; shift right hand ->
  ; supposedly more ergo, also, Enter and RShift are nearer 
  qwertyMask_wide := "
  (Join`r`n
        w e r        i o p
   CL a s d f g    j k l ; ' Enter
        z x c v    m , . /
  )"

  ; -----------

  layerMain := "
  (Join`r`n
         o  i  '         w  h  c
  LSh y  a  e SP  -   m  t  n  s  r RShift
         .  k  u  _   b  d  l  f
  )"

  layerMainSh := "
  (Join`r`n
  )"


  layerAlt := "
  (Join`r`n
         ?  (  !         q  )  "
  LSh :  ;  , Cr  >   z  g  v  p  x RShift
         *  /  [  ]   {  }  =  j
  )"

  layerAltSh := "
  (Join`r`n
  )"

  ; -----------

  wide := 1
  qwertyMask := (wide ? qwertyMask_wide : qwertyMask_std)

  layerMain := layerMain
  layerMainSh := layerMainSh

  numpad := NumpadLayerMappings()
  numpadLayers := (wide ? numpad.thumbOnBwide : numpad.thumbOnB)
  extendLayer := (wide ? ExtendLayerMappingsWide() : ExtendLayerMappings())


  layers := [
      {id: "main", 
        qwertyMask: qwertyMask,
        map: layerMain, 
        ; mapSh: layerMainSh
      },

      {id: "syms", key: "Space", tap: "Space",
        qwertyMask: qwertyMask,
        map: layerAlt,
        ; mapSh: layerAltSh,
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
  altGr := layerDefsById["syms"]

  if (! wide) {
      main.AddMappingsFromTo("p", "Backspace", false)
      main.AddMappingsFromTo("p", "~Delete", true)
  }
  else {
      main.AddMappingsFromTo("[", "Backspace", false)
      main.AddMappingsFromTo("[", "~Delete", true)

      main.AddMappingsFromTo( "h", "Control", false)
      main.AddMappingsFromTo( "h", "Control", true)
      altGr.AddMappingsFromTo("h", "Control", false)
      altGr.AddMappingsFromTo("h", "Control", true)

      main.AddMappingsFromTo( "n", "Alt", false)
      main.AddMappingsFromTo( "n", "Alt", true)
      altGr.AddMappingsFromTo("n", "Alt", false)
      altGr.AddMappingsFromTo("n", "Alt", true)
  }

}

;---

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
