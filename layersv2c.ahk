#InstallKeybdHook
#Warn All, MsgBox

#include util.ahk
#include scancodes.ahk
#include keyDef.ahk
#include layer.ahk

;--------

; CKeyDef, idx = keyScancode
global layerDefs := []
global layerDefsByNm := {}
global currentLayer
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

    keydef := currentLayer.keyDefs[sc]
    if (keydef)
        keydef.OnKeyDn()
    else
        OutputDebug "no keydef for " . sc
}

onHotkeyUp(sc)
{
    OutputDebug "onHotkeyUp '" . sc . "' " . GetKeyName(sc)
    
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
    Send "{blind}{" . keydef.outValue . " Down}"
}

sendOutValueUp(keydef) 
{ 
    Send "{blind}{" . keydef.outValue . " Up}"
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
    ; outValue is layer idx
    outputdebug "layer on : " keydef.outValue
}

layerAccessUp(keydef) 
{   ;TODO
    ; outValue is layer idx
    outputdebug "layer off : " keydef.outValue
}

;--

AddStdKeydef(keyNm, outValue)
{
    ; k1 := new CStdKey(keyNm, true, false, outValue, 0)
    k1 := new CKeyDef(keyNm, true, false, outValue, 0, 0)
    k1.onHoldDn := Func("sendOutValueDn")
    k1.onHoldUp := Func("sendOutValueUp")

    keydefs[k1.sc] := k1
    ; Hotkey2(k1.sc)
    return k1
}

AddDualModifier(keyNm, outValue, outTapValue)
{
    ; k1 := new CDualModeModifier(keyNm, false, true, outValue, outTapValue)
    k1 := new CKeyDef(keyNm, false, true, outValue, outTapValue)

    k1.onHoldDn := Func("sendOutValueDn")
    k1.onHoldUp := Func("sendOutValueUp")
    k1.onTap := Func("sendTap")

    keydefs[k1.sc] := k1
    ; Hotkey2(k1.sc)
    return k1
}

CreateLayerAccess(keyNm, layerId, outTapValue)
{
    ; always isDual, ignored if no outTapValue
    ; k1 := new CDualModeLayerAccess(keyNm, layerId, outTapValue)
    ; save layerIdx in outValue
    k1 := new CKeyDef(keyNm, false, true, layerId, 0, outTapValue)

    k1.onHoldDn := Func("layerAccessDn")
    k1.onHoldUp := Func("layerAccessUp")
    k1.onTap := Func("sendTap")

    return k1
}

;-------

toto()
{
    AddStdKeydef('a', 'i')
    AddStdKeydef('LCtrl', 'j')

    AddDualModifier('LShift', 'LShift', 'k')
    AddDualModifier('b', 'LShift', 'l')
    ; AddDualModifier('v', 't', 'r') ;;hihi makes no sense

    ; AddLayerAccess('RAlt', 2, 0)
    ; AddLayerAccess('n', 3, 'q')
    ; AddLayerAccess('Space', 4, 'Space')

}


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
    ;
    escapeSc := MakeKeySC('Escape')

    ; create layers, 1st is main
    for idx, val in layers {
        outputdebug "layer " idx  " " val.id " " val.key " " val.tap

        layer := new CLayer(val.id, val.key)

        layerDefs.Push(layer)
        layerDefsByNm[val.id] := layer
    }

    ; set main layer as current
    main := currentLayer := layerDefs[1]

    ;  create layer access keys (keydefs in main)
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
        {id: "main", map: "a s d  i e a", mapSh: "a s d  I E A"},
        {id: "punx", map: "a s d  , `; ." },
    ]

    Init(layers, mappings)
}

tata()
; toto()

; ---


/* todo
- must register hotkey for all keys 
  -> eg dualmode Shift : 
     shift+F2, we won't see F2 press/rel and will sendTap for dual shift
- need shifted outValue etc
- output code (handle modifiers, ie shift ..)
- 'add mappings' funcs
- implement actual layers
  -> 1 layer = dictio of key 
  -> or have mappings in keydef, ie outValue[layerIdx]
  ?-> could implement chording by assigning layerAccess on a layer !
      eg: space for punc layer, on punc layer, shift (or other key) accesses numpad

*/