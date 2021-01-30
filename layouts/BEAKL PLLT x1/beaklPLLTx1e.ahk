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

Small changes as suggested by Den for me (and some perso changes)
Orig:                           Revised:
    i u o      w m d n            i u o        m d n    
  y e   a g    h r t s p        y e   a g    l r t s p  
    ,   .        l c f            .   ,        h c f    
                               
    I U O      W M D N            I U O         M D N   
  Y E " A G    H R T S P        Y E " A G     L R T S P 
    ;   :        L C F            :   ;         H C F      French AltGr
                               
    q $ j      z v ! #            q ' j         v ! #      ï î û ô œ          v q j !
  ? ( - ) '    k { = } &        ? ( - ) $     + { = } &    ê é ù à ä        - « ' » x
    *   /        + x b            *   / :     z k x b        è ë â          w k ç b  
                                                           
    Q   J      Z V |              Q ` J         V |        Ï Î Û Ô Œ          V Q J ?
    < _ > `    K [ @ ] %        < < _ > -     ~ [ @ ] %    Ê É Ù À Ä        + ( / ) X
    ^   \        ~ X B            ^   \       Z K X B        È Ë Â          W K Ç B 

swap hl k+ $' ,. 
move w to SP, z to bottom 
add extra < - on sh-altGr

Move Shifts to Caps / Enter
Change numrow to Fn keys
*/

; code only includes

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
global ImgsDir := A_ScriptDir . "\imgsc"
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
  qwertyMask_std := "
  (Join`r`n
      w e r       u i o     
    a s d f g   h j k l ;  
      z x c v   n m , .     
  )"

  qwertyMask_wid := "
  (Join`r`n
       w e r        i o p
     a s d f g    j k l ; '
       z x c v    m , . / 
  )"

  ; masks for extra / special chars (Cr, Bs etc)
  qwertyMask_stdEx := "
  (Join`r`n
    q w e r       u i o p    
 CL a s d f g   h j k l ; CR
      z x c v   n m , .     
  )"

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
        i u  o           m d n      
      y e Sp a g       l r t s p  
        . .  , .       w h c f     
  )"


  layerMainSh := "
  (Join`r`n
        I U O            M D N       
      Y E " A G        L R T S P  
        : . ~; .       W H C F    
  )"

  ; alt / secondary layer
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

  ; main layer extra / special chars
  layerMainEx := "
  (Join`r`n
    Tab . . .           . . . BS     
  LSh . . . . .       . . . . . RSh
       . CR . .         . . . .     
  )"

  layerMainExSh := "
  (Join`r`n
    Tab . . .           . . . ~Delete
   CL . . . . .       . . . . . CL
       . CR . .       . . . .     
  )"

  ; more extra chars for wid mode
  ; layerMainExWid1 := "
  ; (Join`r`n
  ;     y     !Esc
  ;     h     Ctrl
  ;     n     Alt
  ; )"

 ; edit !
 layerMainExWid := "
  (Join`r`n
    ``           ^z
      t   y u       ^x    Left Right
          h               Up    
    v b   n      ^c ^v    Down   
  )"
 ; french layer verion, cannot have ^x (cut) on T, in use
 layerMainExWidFr := "
  (Join`r`n
    ``           ^z
          y u             Left Right
          h               Up    
    v b   n      ^c ^v    Down   
  )"

  ; --- French layers ---

  ; need to move QJ to right hand !
  if (qwertyMask == qwertyMask_std) {
    layerAltfr := "
    (Join`r`n
       q w e r t      u i o p          ï î û ô œ    v q j !   
    CL a s d f g    h j k l ; CR   LSh ê é ù à ä  - « ' » x RSh
       z x c        n m , .              è ë â    w k ç b
    )"
  } else  {
    layerAltfr := "
    (Join`r`n
       q w e r t      i o p [          ï î û ô œ    v q j !   
    CL a s d f g    j k l ; ' CR   LSh ê é ù à ä  - « ' » x RSh
       z x c        m , . /              è ë â    w k ç b    
    )"
  }

  ; need this ! no Z otherwise
  altAccessTapFr := 'z'

  if (qwertyMask == qwertyMask_std) {
    layerAltfrsh := "
    (Join`r`n
      Q W E R T    U I O P      Ï Î Û Ô Œ    V Q  J ?   
      A S D F G  H J K L ;      Ê É Ù À Ä  + ( ~/ ) X   
      Z X C      N M , . /        È Ë Â    W K Ç  B  
    )"
  } else  {
    layerAltfrsh := "
    (Join`r`n
      Q W E R T    I O P [     Ï Î Û Ô Œ    V Q  J ?   
      A S D F G  J K L ; '     Ê É Ù À Ä  + ( ~/ ) X   
      Z X C      M , . /         È Ë Â    W K Ç  B  
    )"
  }

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

      {id: "syms", key: altAccesKey, tap: altAccessTapFr, ;; need tap defined here to be accessible on french layer
        qwertyMask: qwertyMask,
        map: layerAlt,
        mapSh: layerAltSh,
      },

      {id: "french", tap: altAccessTapFr,
        map: layerAltfr,
        mapSh: layerAltfrsh,
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
  french := layerDefsById["french"]

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
    french.AddMappings(layerMainExWid, false)
    french.AddMappings(layerMainExWid, true)
  }


  ; put FN keys on the top row (digits)
    main.AddMappingsFromTo("1  2  3  4  5  6  7  8  9  0   -   =", 
                           "F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12", false)
    main.AddMappingsFromTo("1  2  3  4  5  6  7  8  9  0   -   =", 
                           "F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12", true)

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
    ; symsAccessKeydef.AddMapping(altAccessTapFr, false, true)
    ; symsAccessKeydef.AddMapping(altAccessTapFr, true, true)

    ; changing the main layer name changes the accessed img file
    mainLayer.id := "mainfr"
  }
  else {
    ; change the layer accessed by the layer access key
    symsAccessKeydef.layerId := "syms"

    ; Change the Tap value of alt layer access key
    ; e.g. Space: w <-> Space: z
    ; symsAccessKeydef.AddMapping(altAccessTap, false, true)
    ; symsAccessKeydef.AddMapping(altAccessTap, true, true)

    ; changing the main layer name changes the accessed img file
    mainLayer.id := "main"
  }
}


;---

CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

; LWin-n qwerty swap between symbols and french on altGr
LWin & sc031::swapSymsAndFrench()
