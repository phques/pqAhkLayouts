#InstallKeybdHook
#InstallMouseHook
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
global StopOnEscape := false

; ----

onHotkeyDn(sc)
{
    ; OutputDebug "onHotkeyDn '" . sc . "' " . GetKeyName(sc)

    ; debug, hit Esc to stop script
    if (StopOnEscape && sc == MakeKeySC('Escape'))
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


CreateHotkey(sc)
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
        CreateHotkey(keysc)
    }
}

;--

onMouseDn()
{
    ; this is required so that Shift+LeftMouseButton does not output the tapval
    ; for a dualMode LShift
    CKeyDef.checkOnDualDn()
}

onMouseUp()
{
}

hookMouse()
{
    fnDn := Func("onMouseDn")
    fnUp := Func("onMouseUp")

    ; '~' lets the button through, we only need to KNOW that it was presssed
    HotKey '~LButton', fnDn
    HotKey '~LButton up', fnUp

    HotKey '~MButton', fnDn
    HotKey '~MButton up', fnUp

    HotKey '~RButton', fnDn
    HotKey '~RButton up', fnUp

}

;-------

;; action funcs for keydefs, called in CKeyDef.OnKeyDn/Up

prepBlind(keyDef, out)
{
    ; use {blind+} if we need to output a non-shifted key while shift is down
    ; eg Shift+q => [
    if (CKeyDef.IsShiftDown()) {
        ; if (!out.isShiftKey && !out.isShifted && !InStr(out.mods, "+")) {
        if (out.needBlindShift && !InStr(out.mods, "+")) {
            return "{blind+}"            
        }
    }

    return "{blind}"
}

sendOutValueDn(keydef) 
{ 
    ; OutputDebug "++send out dn " currentLayer.id ' ' keydef.name
    out := keydef.GetValues(false)
    if (out) {
        blindStr := prepBlind(keydef, out)
        Send blindStr out.mods "{" out.key  " Down}"
        ; outputdebug "Send " blindStr out.mods "{" Getkeyname(out.key)  " Down}"
    }
    else 
        outputdebug "sendOutValueDn no outValue, " keydef.name    
}

sendOutValueUp(keydef) 
{ 
    ; OutputDebug "++send out up " currentLayer.id ' ' keydef.name
    out := keydef.GetValues(false)
    if (out) {
        blindStr := prepBlind(keydef, out)
        Send blindStr out.mods "{" out.key " Up}"
        ; outputdebug "Send " blindStr out.mods "{" Getkeyname(out.key) " Up}"
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


InitLayout(layers)
{
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
        if (idx > 1  && val.Key) {
            k := CKeyDef.CreateLayerAccess(val.key, val.id, val.tap)
            main.AddKeyDef(k)
        }
    }

    ; create mappings (keydefs in layers)
    for idx, val in layers {
        outputdebug val.id
        outputdebug val.map
        outputdebug val.id "Sh"
        outputdebug val.mapSh
        ; get layer
        layer := layerDefsById[val.id]
        if (!layer) {
            MsgBox("Unknown layer " val.id)
            ExitApp
        }
        
        layer.AddMappings(val.map, false)
        layer.AddMappings(val.mapSh, true)
    }

    ; create all hotkeys (do at end, needs data above)
    ; we need to trap all key events for dualMode 
    ; eg @Shift-F2, if no hotkey for F2 then we wont know a key was press and will output Tapval
    CreateHotkeysForUsKbd()

    ; hook mouse buttons, to avoid out tapVal for dualMode modifier (eg. shift+click)
    hookMouse()
}

; ---------

; test / debug
tata()
{
    layers := [
        {id: "main",
             map: "a @/  s @>+q",  mapSh: "a @/ S @>+Q"
        },
        {id: "punx", key: "Space", tap: "Space",
            map: "a s d f   i e a u", mapSh: "a s d f   i E +a ["},
            ; map: "a s f g   i e +a :", mapSh: "a s f g  I e +z ["},
    ]

    InitLayout(layers)

    main := layerDefsById["main"]
    ; main.AddMappings("@LSh k", false)

    StopOnEscape := true
}

; tata()
