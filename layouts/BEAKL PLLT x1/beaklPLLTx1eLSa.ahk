/*  http://shenafu.com/smf/index.php?topic=89.msg2409;topicseen#msg2409
(Den) PLLT x1(e)
PLLT may be my other radical idea here. 
"Pinky-Less, Less Thumb" further minimizes pinkies by eliminating the remote corner keys hit 
by the pinkies. also theoretically thumbs are slower than other fingers, 
so move the most used character (Space) away from thumb. on the other hand,
 thumbs are detached from other fingers, so they are more flexible for chording. 
 such that thumbs are more ideal to be utilized as shifts and modifier keys.

PQ
kinda fits with what I like, was using Space as Alt layer dual mode key,
in this it becomes only alt layer key / dualMode W.

Trying to do a LaSalle version of PLLT1x
** not very good, original PLLT1x is better ;-)

*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgsxx"
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
        q w e r t  u i o p [  
     CL a s d f g  j k l ; ' Enter
            c v    m ,       
    )"

    ; qwertyMask := qwertyMask_std
    ; qwertyMaskEx := qwertyMask_stdEx
    qwertyMask := qwertyMask_wid
    qwertyMaskEx := qwertyMask_widEx


  ;---------

  ; maip layer definition
  layerMain := "
  (Join`r`n
      e sp o       m t s      
    y i u  a g   l r d n p  
      . .  , .   w h c f     
  )"


  layerMainSh := "
  (Join`r`n
      E " O       M T S      
    Y I U A G   L R D N P  
      . . ~; :  W H C F     
  )"

  ; alt / secondary layer
  ; no change for lasalle for now, we'll see
  layerAlt := "
  (Join`r`n
        q ' j            v ! #     
      ? ( - ) @        + { = } &   
        * | / _        z k x b     
  )"

  layerAltSh := "
  (Join`r`n
        Q ~`` J           V |  .       
      < < _ > ~-       ~ ~[ $ ~] %   
        ^ . ~\ .       Z  K X  B     
  )"

  ;----------------

    ; swap Cr Tab to give left hand a rest
    layerMainEx := "
    (Join`r`n
       Esc .  .  . Tab  Cr .  .  .  BS 
    LSh .  .  .  .  .   .  .  .  .  . RShift
                 .  .   .  .           
    )"
    layerMainExSh := "
    (Join`r`n
       Esc .  .  . Tab  Cr .  .  .  ~Delete 
     CL .  .  .  .  .   .  .  .  .  . CL
                 .  .   .  .           
    )"

  ; more extra chars for wid mode
  ; layerMainExWid1 := "
  ; (Join`r`n
  ;     y     !Esc
  ;     h     Ctrl
  ;     n     Alt
  ; )"


  ; -- Setup layers, including Extend layer (for edit keys) --

    numpadLayers := NumpadLayerMappings()

    ; use std extend layout vs LaSalle
    layerExtend := ExtendLayerMappingsWide()

    layers := [
        {id: "main", 
            qwertyMask: qwertyMask,
            map: layerMain, 
            mapSh: layerMainSh
        },

        {id: "syms", key: "Space", 
            qwertyMask: qwertyMask, 
            map: layerAlt, 
            mapSh: layerAltSh, 
        },

        {id: "edit", key: "LAlt", toggle: true,
            ; qwertyMask: qwertyMask, 
            map: layerExtend, 
        },

        {id: "numpad", key: "b", toggle: true,
            map: numpadLayers.thumbOnBwide, 
        },

    ]

    ; dont create layout hotkeys for these
    ; for eg, we will use Win-XX for hotkeys to do actions
    ; we need to do it this way for the Suspend hotkey w. #SuspendExempt
    dontCreateHotkeys := [MakeKeySC("LWin"), MakeKeySC("ScrollLock")]

    InitLayout(layers, dontCreateHotkeys)

    ; add extra keys like Esc, Tab, Cr ..
    main := layerDefsById["main"]
    altGr := layerDefsById["syms"]

    CLayer.NoKeyChar := '.'
    main.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
    main.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)
    altGr.AddMappingsFromTo(qwertyMaskEx, layerMainEx, false)
    altGr.AddMappingsFromTo(qwertyMaskEx, layerMainExSh, true)

    ; if (qwertyMask == qwertyMask_wid) {
    ;   main.AddMappings(layerMainExWid, false)
    ;   main.AddMappings(layerMainExWid, true)
    ;   altGr.AddMappings(layerMainExWid, false)
    ;   altGr.AddMappings(layerMainExWid, true)
    ; }

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

