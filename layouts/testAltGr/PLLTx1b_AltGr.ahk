; mix of pqAhk and microsoft keyboard layouts
; spacebar is my altGr ..
; for PLLTx1b.ahk

; global ImgsDir := A_ScriptDir . "\imgsb"
global ImgsDir := "..\BEAKL PLLT x1\imgsb"
global ImgWidth := 160
global ImgHeight := 54
global CenterOnCurrWndMonitor := 1

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

extendLayer := ExtendLayerMappingsAlt()
numpadLayers := NumpadLayerMappings()

layers := [
    {id: "main", 
      ; (<^RALt) lctrl ralt = altGr, actually works as ctr-ralt
      map: "Space  RALt",
      ; map: "Space  ^RALt",
      ; map:   " ' / v    Enter RShift Backspace",  
      ; mapSh: " ' / v    +Enter RShift ~Delete",  
    },

    {id: "syms", key: "Space", ;tap: "w",
      map:   "/ f",
      ; map:   "/ RShift",
      ;mapSh: "/ RShift",
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

; main.AddMappingsFromTo("Space", "^RALt", false)
; main.AddMappingsFromTo("Space", "^RALt", true)

main.AddMappingsFromTo("v", "Backspace", false)
main.AddMappingsFromTo("v", "~Delete", true)

; main.AddMappingsFromTo("'", "Enter", false)
; main.AddMappingsFromTo("'", "+Enter", true)

; main.AddMappingsFromTo("/", "RSh", false) ;; shift on /
; main.AddMappingsFromTo("/", "RSh", true) ;; shift on /
; syms.AddMappingsFromTo("/", "RSh", false) ;; shift on /
; syms.AddMappingsFromTo("/", "RSh", true) ;; shift on /


DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk

