/*  http://shenafu.com/smf/index.php?topic=89.msg2409;topicseen#msg2409
(Den) PLLT x1(d)
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
  qwertyMask_std := "
  (Join`r`n
    q w e r       u i o     
    a s d f g   h j k l ;  
      z   c v   n m , .     
  )"

  qwertyMask_wid := "
  (Join`r`n
     q w e r        i o p
     a s d f g    j k l ; '
       z   c v    m , . / 
  )"

  ; qwertyMask := qwertyMask_std
  qwertyMask := qwertyMask_wid

  layerMain := "
  (Join`r`n
    Esc i u  o           m d n      
      y e Sp a g       l r t s p  
        .    , Tab    Cr h c f     
  )"
  altAccessTap := 'w'

  layerMainSh := "
  (Join`r`n
    Esc I U O            M D N       
      Y E " A G        L R T S P  
        :  ~; Tab     Cr H C F    
  )"


  layerAlt := "
  (Join`r`n
    Esc q ' j            v ! #     
   @<+? ( - ) $        + { = } @>+&   
        *   / :        z k x b     
  )"

  layerAltSh := "
  (Join`r`n
    Esc Q ~`` J           V |  .       
      < < _ > ~-       ~ ~[ @ ~] %   
        ^  ~\ .        Z  K X  B     
  )"

  ; need to move QJ to right hand !
  if (qwertyMask == qwertyMask_std) {
    layerAltfr := "
    (Join`r`n
      q w e r t      u i o p       ï î û ô œ    v q j !   
      a s d f g    h j k l ;       ê é ù à ä  - « ' » x   
      z x c        n m , .           è ë â    w k ç b
    )"
  } else  {
    layerAltfr := "
    (Join`r`n
      q w e r t      i o p [       ï î û ô œ    v q j !   
      a s d f g    j k l ; '       ê é ù à ä  - « ' » x   
      z x c        m , . /           è ë â    w k ç b    
    )"
  }

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
        map: extendLayer, 
      },

      ; would've liked  to use V here, but it screws up??
      {id: "numpad", key: "b", toggle: true,
        map: numpadLayers.thumbOnBwide, 
      },

  ]

  ; dont create layout hotkeys for these
  ; for eg, we will use Win-XX for hotkeys to do actions
  ; we need to do it this way for the Suspend hotkey w. #SuspendExempt
  dontCreateHotkeys := [MakeKeySC("LWin"), MakeKeySC("ScrollLock")]

  InitLayout(layers, dontCreateHotkeys)

  main := layerDefsById["main"]
  altGr := layerDefsById["syms"]
  extend := layerDefsById["edit"]
  french := layerDefsById["french"]

  if (qwertyMask == qwertyMask_std) {
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
    symsAccessKeydef.AddMapping(altAccessTapFr, false, true)
    symsAccessKeydef.AddMapping(altAccessTapFr, true, true)

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

LWin & Insert::swapSymsAndFrench()
