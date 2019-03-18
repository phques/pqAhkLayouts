/* White

https://github.com/mw8/white_keyboard_layout/blob/master/README.md

2019-03-17

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
	qwertyMaskAZ := "
	(Join`r`n
	  `` 1 2 3 4 5 6 7 8 9 0 - =
	     q w e r t y u i o p [ ] \
	     a s d f g h j k l ; ' 
	  @LSh z x c v n m , . / 
	)"

	layerMain := "
	(Join`r`n
		# 1 2 3 4 5 @ $ 6 7 8 9 0   
		  v y d , ' _ j m l u ( ) = 
		  a t h e b - c s n o i   
		  p k g w q x r f . z   
	)"

	layerMainSh := "
	(Join`r`n
	  ~`` !  <  > ~/  |  ~  % ~\  * ~[ ~]  ^    
		  V  Y  D ~;  "  &  J  M  L  U  {  }  ? 
		  A  T  H  E  B  +  C  S  N  O  I     
		  P  K  G  W  Q  X  R  F  :  Z     
	)"


	punxLayers := PunxLayerMappings()
	extendLayer := ExtendLayerMappings()
	numpadLayers := NumpadLayerMappings()

	layers := [
	    {id: "main", 
	    	qwertyMask: qwertyMaskAZ,
	     	map: layerMain, 
	     	mapSh: layerMainSh
	    },

	    {id: "punx", key: "Space", tap: "Space",
	    	map: punxLayers.layerAZ, 
	    },

	    {id: "edit", key: "LAlt", toggle: true,
	    	map: extendLayer, mapSh: extendLayer
		},

	    {id: "numpad", key: "b", toggle: true,
	    	map: numpadLayers.indexOnB, 
		},

	]

	; dont create layout hotkey for Left Win
	; we will use Win-XX for hotkeys to do actions
	; we need to do it this way for the Suspend hotkey w. #SuspendExempt
	dontCreateHotkeys := [MakeKeySC("LWin")]

	InitLayout(layers, dontCreateHotkeys)

	punx := layerDefsById["punx"]

	; add Space on punx B (hold will repeat! vs spacebar dual mode layer access which doesnt)
	punx.AddMappings("b  Space", false)

	; SetMouseDragKeys("space", "control")

}


CreateLayers()
DisplayHelpImage()

return


;--- hotkeys, must be at the end -----

#include ../winHotkeys.ahk
