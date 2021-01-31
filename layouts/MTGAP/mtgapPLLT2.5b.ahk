/*  mtgap version of the PLLT idea (pinky less, less thumb)

manually moved P to mid index, bring ,. etc.
manually placed syms / modified alt layer

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgs__"
global ImgWidth := 160
global ImgHeight := 54
global CenterOnCurrWindow := 1
; global CenterOnCurrWndMonitor := 1

; for easyDragWindow script
global DoubleAlt := 0

global altAccessTapFr := 0
; global altAccessTap := 0
global altAccesKey := 0

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../punxLayer.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

; ----

CreateLayers()
{
  ; masks

  qwertyMask_wid := "
  (Join`r`n
       w e r        i o p
     a s d f g    j k l ; '
       z x c v    m , . / 
  )"

  ; masks for extra / special chars (Cr, Bs etc)

  qwertyMask_widEx := "
  (Join`r`n
     q w e r        i o p [
  CL a s d f g    j k l ; ' CR
       z x c v    m , . / 
  )"

    ; qwertyMask := qwertyMask_std
    ; qwertyMaskEx := qwertyMask_stdEx
    qwertyMask := qwertyMask_wid
    qwertyMaskEx := qwertyMask_widEx


  ;---------

  ; maip layer definition
  layerMain := "
  (Join`r`n
         i  o  u         g  r  h
      y  a  e SP  p   m  t  s  n  c
         .  _  , CR   f  d  l  b
  )"


  layerMainSh := "
  (Join`r`n
         I  O  U         G  R  H
      Y  A  E  "  P   M  T  S  N  C
         :  _ ~; CR   F  D  L  B
  )"

  ; alt / secondary layer
  layerAlt := "
  (Join`r`n
        >  '  !         q  =  x
     ?  (  -  )  |   +  w  v  k  &
        *  #  /  @   z  {  j  }
  )"

  layerAltSh := "
  (Join`r`n
        ^ ~`` .         Q  $  X
      . < ~-  > .    ~  W  V  K  %
        . ~= ~\ .    Z ~[  J ~]
  )"

  ;----------------

  ; main layer extra / special chars
  layerMainEx := "
  (Join`r`n
    Tab . . .           . . . BS     
  LSh . . . . .       . . . . . RSh
        . . . .         . . . .     
  )"

  layerMainExSh := "
  (Join`r`n
    Tab . . .           . . . ~Delete
   CL . . . . .       . . . . . CL
        . . . .       . . . .     
  )"


 ; edit !
 layerMainExWid := "
  (Join`r`n
    ``           ^z
      t   y u       ^c    Up Right
          h               Left    
      b   n         ^v    Down   
  )"


  ; -- Setup layers, including Extend layer (for edit keys) --

  ; extendLayer := ExtendLayerMappingsAlt()
  extendLayer := ExtendLayerMappingsWide()  
  numpadLayers := NumpadLayerMappings()

  altAccesKey := "Space"
  layers := [
      {id: "main", 
        qwertyMask: qwertyMask,
        map: layerMain, 
        mapSh: layerMainSh
      },

      {id: "syms", key: altAccesKey,
        qwertyMask: qwertyMask,
        map: layerAlt,
        mapSh: layerAltSh,
      },

      ; {id: "edit", key: "LAlt", toggle: true,
      ;   map: extendLayer, 
      ; },

      ; would've liked  to use V here, but it screws up??
      ; {id: "numpad", key: "b", toggle: true,
      ;   map: numpadLayers.thumbOnBwide, 
      ; },

  ]

  ; dont create layout hotkeys for these
  ; for eg, we will use Win-XX for hotkeys to do actions
  ; we need to do it this way for the Suspend hotkey w. #SuspendExempt
  dontCreateHotkeys := [MakeKeySC("LWin"), MakeKeySC("ScrollLock")]

  InitLayout(layers, dontCreateHotkeys)

  main := layerDefsById["main"]
  altGr := layerDefsById["syms"]
  ; extend := layerDefsById["edit"]

  CLayer.NoKeyChar := '.'
  main.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
  main.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)
  altGr.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
  altGr.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)
  ; french.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
  ; french.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)

  if (qwertyMask == qwertyMask_wid) {
    main.AddMappings(layerMainExWid, false)
    main.AddMappings(layerMainExWid, true)
    ; altGr.AddMappings(layerMainExWid, false)
    ; altGr.AddMappings(layerMainExWid, true)
  }


  ; put FN keys on the top row (digits)
    main.AddMappingsFromTo("1  2  3  4  5  6  7  8  9  0   -   =", 
                           "F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12", false)
    main.AddMappingsFromTo("1  2  3  4  5  6  7  8  9  0   -   =", 
                           "F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12", true)

}


;---

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

