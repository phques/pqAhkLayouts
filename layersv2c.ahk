; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

#InstallKeybdHook
#InstallMouseHook
#Warn All, MsgBox
; def 70 
#MaxHotkeysPerInterval 140

#include util.ahk
#include scancodes.ahk
#include keyDef.ahk
#include layer.ahk

;--------

; CKeyDef, idx = keyScancode
global layerDefs := []      ; list of layers
global layerDefsById := {}  ; layers dictio by id 
global currentLayer := 0

; when current layer != main, this is the key that accessed it
; (it is still held down)
global layerAccessKeyDn := 0    
global StopOnEscape := False ;debug, if True, Escape will stop the script

; ----

; func called by hotkey on key down 
onHotkeyDn(sc)
{
    ; OutputDebug "onHotkeyDn '" . sc . "' " . GetKeyName(sc)

    ; debug, hit Esc to stop script
    if (StopOnEscape && sc == MakeKeySC('Escape'))
    {
        OutputDebug "escape pressed, stopping script"
        ExitApp
    }

    ; check for current layer access key already pressed
    ; (once on the other layer, the keydef will not be the same !)
    if (layerAccessKeyDn && layerAccessKeyDn.sc == sc)
        keydef := layerAccessKeyDn
    else 
        keydef := currentLayer.keyDefs[sc]

    if (keydef)
        keydef.OnKeyDn()
    else
        OutputDebug "no keydef for " . sc
}

; func called by hotkey on key up
onHotkeyUp(sc)
{
    ; OutputDebug "onHotkeyUp '" . sc . "' " . GetKeyName(sc)
    
    ; check for current layer access key already pressed
    ; (once on the other layer, the keydef will not be the same !)
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
    ; add '*' to hotkeyname (hotkey will work even when modifiers are pressed)
    ; (this also makes this hotkey use the keyboard hook)
    HotKey '*' sc, fnDn
    HotKey '*' sc " up", fnUp
}


; create a hotkey foreach key scancode of US kbd
; dontCreateHotkeys is array of scancodes to skip
; entries should be in format 'sc999', create w. MakeKeySC()
CreateHotkeysForUsKbd(dontCreateHotkeys)
{
    ; create map of scancodes to skip
    toSkipDictio := {}
    for _, scToSkip in dontCreateHotkeys {
        toSkipDictio[scToSkip] := True
    }

    for _, scanCode in usKbdScanCodes
    {   
        keysc := 'sc' scanCode
        if (!toSkipDictio[keysc]) {
            CreateHotkey(keysc)
        }
    }
}

;--
global DoubleAlt := 0

onMouseDn()
{

    ; this is required so that Shift+LeftMouseButton does not output the tapval
    ; for a dualMode LShift, for eg.
    CKeyDef.checkOnDualDn()
Return

    main := layerDefs[1] ; msin is 1st
    laltKeydef := main.GetKeyDef("LAlt")

    if (!laltKeydef.isDown)
        Return

SetWinDelay 2
CoordMode "Mouse"

    OutputDebug "mouse, alt is down"
    if DoubleAlt
    {
        MouseGetPos ,, KDE_id
        ; This message is mostly equivalent to WinMinimize,
        ; but it avoids a bug with PSPad.
        PostMessage 0x112, 0xf020,,, "ahk_id " KDE_id
        DoubleAlt := false
        return
    }
    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos KDE_X1, KDE_Y1, KDE_id
    if WinGetMinMax("ahk_id " KDE_id)
        return
    ; Get the initial window position.
    WinGetPos KDE_WinX1, KDE_WinY1,,, "ahk_id " KDE_id
    Loop
    {
        if !GetKeyState("LButton", "P") ; Break if button has been released.
            break
        MouseGetPos KDE_X2, KDE_Y2 ; Get the current mouse position.
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
        KDE_WinY2 := (KDE_WinY1 + KDE_Y2)
        WinMove KDE_WinX2, KDE_WinY2,,, "ahk_id " KDE_id ; Move the window to the new position.
    }

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

; create "{blind}" string for Send
prepBlind(keyDef, out)
{
    ; use {blind+} if we need to output a non-shifted key while shift is down
    ; eg Shift+q => ;, need to Send {blind+}{;}
    if (CKeyDef.IsShiftDown()) {
        if (out.needBlindShift && !InStr(out.mods, "+")) {
            return "{blind+}"            
        }
    }

    return "{blind}"
}

; keydef onHoldDn action, called to 'send down'  out value of a key
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

; keydef onHoldUp action, called to 'send up'  out value of a key
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

; keydef onTap action, called to send  tap value of a dual mode key
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

; keydef onHoldDn action for layer access
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

; keydef onHoldUp action for layer access
layerAccessUp(keydef) 
{
    ; return to main layer (1st entry)
    outputdebug "layer off : " keydef.layerId
    currentLayer := layerDefs[1]
    layerAccessKeyDn := 0
}

;;----------

; change currentLAyer to param layer, 2nd call will restore
; not the most solid technique, works ok as long as used as designed
ToggleLayer(layer := 0) 
{
    static prevLayer := 0
    if (prevLayer == 0 ) {
        prevLayer := currentLayer
        currentLayer := layer
    }
    else {
        currentLayer := prevLayer
        prevLayer := 0
    }
}

; set layer access key Tap action to toggle layer on/Off
; nb: no checks are made if this is valid, be careful ;-p
SetKeyToToggleLayer(keyName, layerId)
{
    ; get layers
    ; layer access keys are on main layer
    mainLayer := layerDefsById["main"]
    otherLayer := layerDefsById[layerId]

    ; set key tap to switch to layer
    keydef := mainLayer.GetKeyDef(keyName)
    keydef.onTap := Func("ToggleLayer").Bind(otherLayer)

    ; must also put ToggleLayer action on key of other layer!
    ; otherwise we will get stuck there ;-p
    ; of course care must be taken that the key is free on that layer 
    ; (original key value will be lost)
    keydef := otherLayer.GetKeyDef(keyName)
    ; normal key on this layer, so not Tap, but onHoldDn
    keydef.onHoldDn := Func("ToggleLayer")  
}

; initialize layout etc.
; THIS is the function to call when using these scripts
; See CreateHotkeysForUsKbd() for meaning of dontCreateHotkeys
InitLayout(layers, dontCreateHotkeys)
{
    ; create layers, 1st is main
    for idx, val in layers {
        outputdebug "layer " idx  " " val.id " " val.key " " val.tap

        ; no access key for main / 1st layer
        key := (idx > 1 ? val.key : 0)
        layer := new CLayer(val.id, key)

        ; save layer
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

    ; assign optional Tap action to toggle layer on/off for access key
    for idx, val in layers {
        if (idx > 1  && val.Toggle) {
            if (val.Tap)
                MsgBox "Cannot use both Tap and Toggle on layer access " val.id
            else
                SetKeyToToggleLayer(val.Key, val.id)
        }
    }

    ; create all hotkeys (do at end, needs data above)
    ; we need to trap all key events for dualMode 
    ; eg @Shift-F2, if no hotkey for F2 then we wont know a key was press and will output Tapval
    CreateHotkeysForUsKbd(dontCreateHotkeys)

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

    InitLayout(layers, {})

    main := layerDefsById["main"]
    ; main.AddMappings("@LSh k", false)

    StopOnEscape := true
}

tata()
