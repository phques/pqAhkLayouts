;; PQuesnel 2019-03-16
;; modified from :
; Easy Window Dragging -- KDE style (requires XP/2k/NT) -- by Jonny
; http://www.autohotkey.com

;global DoubleAlt := 0
global eatUpBtn := ""

minimizeWnd()
{
    ; minimize window
    CoordMode "Mouse"
    MouseGetPos ,, KDE_id
    ; This message is mostly equivalent to WinMinimize,
    ; but it avoids a bug with PSPad.
    PostMessage 0x112, 0xf020,,, "ahk_id " KDE_id
}

togglemaxiWnd()
{
    CoordMode "Mouse"
    MouseGetPos ,, KDE_id
    ; Toggle between maximized and restored state.
    if WinGetMinMax("ahk_id " KDE_id)
        WinRestore "ahk_id " KDE_id
    Else
        WinMaximize "ahk_id " KDE_id
}

closeWnd()
{
    CoordMode "Mouse"
    MouseGetPos ,, KDE_id
    WinClose "ahk_id " KDE_id
}

moveWnd()
{
    SetWinDelay 2
    CoordMode "Mouse"

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


resizeWnd()
{
    SetWinDelay 2
    CoordMode "Mouse"

    ; Get the initial mouse position and window id, and
    ; abort if the window is maximized.
    MouseGetPos KDE_X1, KDE_Y1, KDE_id
    if WinGetMinMax("ahk_id " KDE_id)
        return
    ; Get the initial window position and size.
    WinGetPos KDE_WinX1, KDE_WinY1, KDE_WinW, KDE_WinH, "ahk_id " KDE_id
    ; Define the window region the mouse is currently in.
    ; The four regions are Up and Left, Up and Right, Down and Left, Down and Right.
    if (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
        KDE_WinLeft := 1
    else
        KDE_WinLeft := -1
    if (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
        KDE_WinUp := 1
    else
        KDE_WinUp := -1
    Loop
    {
        if !GetKeyState("RButton", "P") ; Break if button has been released.
            break
        MouseGetPos KDE_X2, KDE_Y2 ; Get the current mouse position.
        ; Get the current window position and size.
        WinGetPos KDE_WinX1, KDE_WinY1, KDE_WinW, KDE_WinH, "ahk_id " KDE_id
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        ; Then, act according to the defined region.
        WinMove KDE_WinX1 + (KDE_WinLeft+1)/2*KDE_X2  ; X of resized window
              , KDE_WinY1 +   (KDE_WinUp+1)/2*KDE_Y2  ; Y of resized window
              , KDE_WinW  -     KDE_WinLeft  *KDE_X2  ; W of resized window
              , KDE_WinH  -       KDE_WinUp  *KDE_Y2  ; H of resized window
              , "ahk_id " KDE_id
        KDE_X1 := (KDE_X2 + KDE_X1) ; Reset the initial position for the next iteration.
        KDE_Y1 := (KDE_Y2 + KDE_Y1)
    }
}

;------

; call these on button down


lmousebutt(key1, key2)
{
    if !GetKeyState(key1, "P")
        return false

    eatUpBtn := "LButton"

    ; eg shift+alt
    if GetKeyState(key2, "P") {
        minimizewnd()
        return true
    }

    moveWnd()
    return true
}

mmousebutt(key1, key2)
{
    if !GetKeyState(key1, "P")
        return false

    eatUpBtn := "MButton"

    ; eg shift+alt
    if GetKeyState(key2, "P") {
        togglemaxiWnd()
        return true
    }

    return true
}

rmousebutt(key1, key2)
{
    if !GetKeyState(key1, "P")
        return false

    eatUpBtn := "RButton"

    ; eg shift+alt
    if GetKeyState(key2, "P") {
        closeWnd()
        return true
    }

    resizeWnd()
    return true
}


