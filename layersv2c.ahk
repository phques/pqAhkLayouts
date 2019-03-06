#InstallKeybdHook
#Warn All, MsgBox

#include util.ahk
#include scancodes.ahk
#include keyDef.ahk
#include layer.ahk

;--------

; CKeyDef, idx = keyScancode
global layerDefs := []
global layerDefsById := {}
global currentLayer

; current layer != main, this is the key that accessed it
; (it is still held down)
global layerAccessKeyDn := 0    
global escapeSc

onHotkeyDn(sc)
{
    OutputDebug "onHotkeyDn '" . sc . "' " . GetKeyName(sc)

    ; debug, hit Esc to stop script
    if (sc == escapeSc)
    {
        OutputDebug "escape pressed, stopping script"
        ExitApp
    }

    if (layerAccessKeyDn && layerAccessKeyDn.sc == sc)
        keydef := layerAccessKeyDn
    else 
        keydef := currentLayer.keyDefs[sc]

    if (keydef)
        keydef.OnKeyDn()
    else
        OutputDebug "no keydef for " . sc
}

onHotkeyUp(sc)
{
    OutputDebug "onHotkeyUp '" . sc . "' " . GetKeyName(sc)
    
    if (layerAccessKeyDn && layerAccessKeyDn.sc == sc)
        keydef := layerAccessKeyDn
    else 
        keydef := currentLayer.keyDefs[sc]

    if (keydef)
        keydef.OnKeyUp()
    else
        OutputDebug "no keydef for " . sc
}


Hotkey2(sc)
{
    fnDn := Func("onHotkeyDn").Bind(sc)
    fnUp := Func("onHotkeyUp").Bind(sc)

    ; create hotKey for press and release of the key
    ; add '*' to hotkeyname (hotkey will work even when other modifiers are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' sc, fnDn
    HotKey '*' sc " up", fnUp
}

;-------

;; action funcs for keydefs

sendOutValueDn(keydef) 
{ 
    if (keydef && keydef.outValue && keydef.outValue.key)
        Send "{blind}{" . keydef.outValue.key . " Down}"
    else
        outputdebug "sendOutValueDn no outValue, " keydef.name    
}

sendOutValueUp(keydef) 
{ 
    if (keydef && keydef.outValue && keydef.outValue.key)
        Send "{blind}{" . keydef.outValue.key . " Up}"
    else
        outputdebug "sendOutValueUp no outValue, " keydef.name    
}

sendTap(keydef) 
{
    if (keydef.outTapValue) {
        Send "{blind}{" . keydef.outTapValue . " Down}"
        Send "{blind}{" . keydef.outTapValue . " Up}"
    }
}

layerAccessDn(keydef) 
{   ;TODO
    outputdebug "layer on : " keydef.layerId
    layer := layerDefsById[keydef.layerId]
    if (layer) {
        currentLayer := layer
        layerAccessKeyDn := keydef
    }
    Else {
        OutputDebug "layer !found: " keydef.layerId
    }
}

layerAccessUp(keydef) 
{   ;TODO
    ; return to main layer (1st entry)
    outputdebug "layer off : " keydef.layerId
    currentLayer := layerDefs[1]
    layerAccessKeyDn := 0
}

;--

; CreateStdKeydef(key, outStr)
; {
;     ; k1 := new CStdKey(key, true, false, outValue, 0)
;     outValue := new COutput(outStr)
;     k1 := new CKeyDef(key, true, false, outValue, 0, 0)
;     k1.onHoldDn := Func("sendOutValueDn")
;     k1.onHoldUp := Func("sendOutValueUp")

;     return k1
; }

; AddDualModifier(key, outValue, outTapValue)
; {
;     ; k1 := new CDualModeModifier(key, false, true, outValue, outTapValue)
;     k1 := new CKeyDef(key, false, true, outValue, outTapValue)

;     k1.onHoldDn := Func("sendOutValueDn")
;     k1.onHoldUp := Func("sendOutValueUp")
;     k1.onTap := Func("sendTap")

;     keydefs[k1.sc] := k1
;     ; Hotkey2(k1.sc)
;     return k1
; }

CreateLayerAccess(key, layerId, outTapValue)
{
    ; always isDual, ignored if no outTapValue
    ; k1 := new CDualModeLayerAccess(key, layerId, outTapValue)
    k1 := new CKeyDef(key, false, true, 0, 0, outTapValue)
    
    ; save layerId !
    k1.layerId := layerId

    k1.onHoldDn := Func("layerAccessDn")
    k1.onHoldUp := Func("layerAccessUp")
    k1.onTap := Func("sendTap")

    return k1
}

;-------

toto()
{
    ; AddStdKeydef('a', 'i')
    ; AddStdKeydef('LCtrl', 'j')

    ; AddDualModifier('LShift', 'LShift', 'k')
    ; AddDualModifier('b', 'LShift', 'l')
    ; AddDualModifier('v', 't', 'r') ;;hihi makes no sense

    ; AddLayerAccess('RAlt', 2, 0)
    ; AddLayerAccess('n', 3, 'q')
    ; AddLayerAccess('Space', 4, 'Space')

}

;;----------

; create a hotkey foreach key scancode of US kbd
CreateHotkeysForUsKbd()
{
    for idx, scanCode in usKbdScanCodes
    {    
        ; create hotkey
        keysc := 'sc' scanCode
        Hotkey2(keysc)
    }
}


Init(layers, mappings)
{
    escapeSc := MakeKeySC('Escape')

    ; create layers, 1st is main
    for idx, val in layers {
        outputdebug "layer " idx  " " val.id " " val.key " " val.tap

        layer := new CLayer(val.id, val.key)

        layerDefs.Push(layer)
        layerDefsById[val.id] := layer
    }

    ; set main layer as current
    main := currentLayer := layerDefs[1]

    ; create layer access keys, set on main layer
    for idx, val in layers {
        k := CreateLayerAccess(val.key, val.id, val.tap)
        main.AddKeyDef(k)
    }

    ; create mappings (keydefs in layers)
    for idx, val in mappings {
        outputdebug val.id
        outputdebug "   " val.map
        outputdebug val.id "Sh"
        outputdebug "   " val.mapSh
        ; get layer
        layer := layerDefsById[val.id]
        
        layer.AddMappings(val.map, false)
        layer.AddMappings(val.mapSh, true)
    }

    ; create all hotkeys (do at end, needs data above)
    CreateHotkeysForUsKbd()
}

tata()
{
    layers := [
        {id: "main"},
        {id: "punx", key: "Space", tap: "Space"},
        {id: "edit", key: "LAlt"}
    ]
    mappings := [
        {id: "main", map: "a s d f  i e a :", mapSh: "a s d f  I E A ["},
        {id: "punx", map: "a s d  , `; ." },
    ]

    Init(layers, mappings)
}

tata()
; toto()

; ---


/* todo
- output code (handle modifiers, ie shiftout, release shift etc ..)
- @LSh = dualmode
- layer access actual code !
- outputValueTap COutput
*/