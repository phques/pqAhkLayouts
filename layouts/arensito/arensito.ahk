/* arensito (Std Kbd)

http://web.archive.org/web/20050306181446/http://www.pvv.org/~hakonhal/keyboard/

*/

; code only includes (not hotkeys)

; Global variables for pkl_guiLayers.ahk / layout image
; MUST be declared *before* scripts that use them
; NB: 2019-03-12, images are not exactly th mappings found in this file!
global ImgsDir := A_ScriptDir . "\imgs"
global ImgWidth := 176
global ImgHeight := 54
global CenterOnCurrWndMonitor := 1

#include ../../fromPkl/pkl_guiLayers.ahk
#include ../../layersv2c.ahk
#include ../punxLayer.ahk
#include ../extendLayer.ahk
#include ../numpadLayer.ahk

; ----

CreateLayers()
{
        ; 1 2 3 4 5 6 7 8 9 0 - =   
        ; q w e r t y u i o p [ ]   
        ; a s d f g h j k l ; ' CR  
        ; z x c v b n m , . / RSh   

    ; left hand does not firt on my Ms ergo kbd YHN is on the right side !
    ; so move left hand one spot to the left
    ; adjusted left hand thumb 
    layerMain := "
    (Join`r`n
       `` 1 2 3 4 5  6 7 8 9 0 -  Tab BS q l , p   Del f u d k CR 
      Tab q w e r t  y u i o p [     ' a r e n b   g   s i t o " 
       CL a s d f g  h j k l ; '     z w . h j #   v   c y m x à  
            x c v    n m                 - Alt Sh  Sp Ctrl  
    )"

    layerMainsh := "
    (Join`r`n
       `` 1 2 3 4 5  6 7 8 9 0 -  Tab BS Q L ? P   Del F U D K CR 
      Tab q w e r t  y u i o p [   ~`` A R E N B   G   S I T O ~ 
       CL a s d f g  h j k l ; '     Z W ! H J @   V   C Y M X À  
            x c v    n m                _ Alt Sh  Sp Ctrl  
    )"

    layerAltGr  := "
    (Join`r`n
            2 3 4 5    7 8 9 0           { } [ ]     _ < > $   
      Tab q w e r t  y u i o p [      % ; / - 0 :   \ 1 ( ) = ^
       CL a s d f g  h j k l ; '      6 7 8 9 + &   * 2 3 4 5 | 
    )"

    ; punxLayers := PunxLayerMappings()
    ; extendLayer := ExtendLayerMappings()
    ; numpadLayers := NumpadLayerMappings()

    layers := [
        {id: "main", 
            map: layerMain, 
            mapSh: layerMainSh
        },

        {id: "syms", key: "Space", ;tap: "Space",
          map: layerAltGr, 
        },

     ;    {id: "edit", key: "LAlt", toggle: true,
     ;      map: extendLayer, mapSh: extendLayer
        ; },

     ;    {id: "numpad", key: "b", toggle: true,
     ;      map: numpadLayers.indexOnB, 
        ; },

    ]

    ; dont create layout hotkey for Left Win
    ; we will use Win-XX for hotkeys to do actions
    ; we need to do it this way for the Suspend hotkey w. #SuspendExempt
    dontCreateHotkeys := [MakeKeySC("LWin")]

    InitLayout(layers, dontCreateHotkeys)

    ; add W on punc layer on N for easier access 
    ; (is on Y, pretty tough reach on Microsoft Sculpt)
    punx := layerDefsById["punx"]
    ; punx.AddMappings("n  w", false)
    ; punx.AddMappings("n  W", true)

    ; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
    ; punx.AddMappings("b  Space", false)

    SetMouseDragKeys("space", "control")

}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
