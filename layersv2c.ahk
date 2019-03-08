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
    ; OutputDebug "onHotkeyDn '" . sc . "' " . GetKeyName(sc)

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
    ; OutputDebug "onHotkeyUp '" . sc . "' " . GetKeyName(sc)
    
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

;-------

;; action funcs for keydefs


prepBlind(keyDef, out)
{
    if (CKeyDef.IsShiftDown()) {
        OutputDebug keydef.name " shift dn"
        if (!out.isShifted && !InStr(out.mods, "+")) {
            OutputDebug keydef.name " !out.isShifted"
            return "{blind+}"            
        }
    }

    return "{blind}"
}

sendOutValueDn(keydef) 
{ 
    out := keydef.GetValues(false)

    if (out) {
        blindStr := prepBlind(keydef, out)
        Send blindStr out.mods "{" out.key  " Down}"
    }
    else 
        outputdebug "sendOutValueDn no outValue, " keydef.name    
}

sendOutValueUp(keydef) 
{ 
    out := keydef.GetValues(false)
    if (out) {
        blindStr := prepBlind(keydef, out)
        Send blindStr out.mods "{" out.key " Up}"
    }
    else
        outputdebug "sendOutValueUp no outValue, " keydef.name    
}

sendTap(keydef) 
{
    out := keydef.GetValues(true)
    if (out) {
        blindStr := prepBlind(keydef, out)
        Send blindStr out.mods "{" out.key " Down}"
        Send blindStr out.mods "{" out.key " Up}"
    }
    else
        outputdebug "sendTap no outTapValue, " keydef.name    
}

layerAccessDn(keydef) 
{
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
{
    ; return to main layer (1st entry)
    outputdebug "layer off : " keydef.layerId
    currentLayer := layerDefs[1]
    layerAccessKeyDn := 0
}

;;----------


InitLayout(layers, mappings)
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
        k := CKeyDef.CreateLayerAccess(val.key, val.id, val.tap)
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
    ; we need to trap all key events for dualMode 
    ; eg @Shift-F2, if no hotkey for F2 then we wont know a key was press and will output Tapval
    CreateHotkeysForUsKbd()
}

; ---------

tata()
{
    layers := [
        {id: "main"},
        {id: "punx", key: "Space", tap: "Space"},
        {id: "edit", key: "LAlt"}
    ]
    mappings := [
        {id: "main", map: "a s d f  i e +a :", mapSh: "a s d f  I e +z ["},
        {id: "punx", map: "a s d  , `; ." },
    ]

    InitLayout(layers, mappings)

    main := layerDefsById["main"]
    main.AddMappings("@LSh k", false)
}

; tata()
