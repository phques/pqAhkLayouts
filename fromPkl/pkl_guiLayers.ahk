; this version uses global vars set by layers.ahk

;global currentLayer

global wnd := 0
global imgCtrl := 0

; initial call to enable & display
DisplayHelpImage()
{
	pkl_displayHelpImage(1) ; activate
	pkl_displayHelpImage(0) ; display
}

DisplayHelpImageToggle()
{
	pkl_displayHelpImage( 2 )
}

DisplayHelpImageSuspendOn()
{
	pkl_displayHelpImage( 3 )
}

DisplayHelpImageSuspendOff()
{
	pkl_displayHelpImage( 4 )
}

;--------

pkl_OnDisplayTimer()
{
	pkl_displayHelpImage(0) ; display
}


pkl_displayHelpImage( activate := 0 )
{
	; Parameter:
	; 0 = display, if activated
	;-1 = deactivate
	; 1 = activate
	; 2 = toggle
	; 3 = suspend on
	; 4 = suspend off

	static guiActiveBeforeSuspend := 0
	static guiActive := 0
	static prevFile := ""
	static HelperImage
	static displayOnTop := 0
	static yPosition := -1
	static blockedKeySkipped := 0
	static prevSkippedLayerId := 0


	if ( activate == 2 )
		activate := 1 - 2 * guiActive
	if ( activate == 1 ) {
		guiActive := 1
	} else if ( activate == -1 ) {
		guiActive := 0
	} else if ( activate == 3 ) {
		guiActiveBeforeSuspend := guiActive
		activate := -1
		guiActive := 0
	} else if ( activate == 4 ) {
		if ( guiActiveBeforeSuspend == 1 && guiActive != 1) {
			activate := 1
			guiActive := 1
		}
	}


	if ( activate == 1 ) {
		if ( yPosition == -1 ) {
			yPosition :=  A_ScreenHeight - ImgHeight - 60
		}
		wnd := GuiCreate("+AlwaysOnTop -Border +ToolWindow", "pklHelperImage")
		wnd.MarginX := 0
		wnd.MarginY := 0
		; imgCtrl := wnd.Add("Pic", "xm", Format("{1}\layer1.png",ImgsDir))
		; wnd.Show(Format("xCenter y{1} AutoSize NA", yPosition))
		imgCtrl := wnd.Add("Pic", "xm", ImgsDir "\layer1.png")
		wnd.Show("xCenter y" yPosition " AutoSize NA")

		SetTimer "pkl_OnDisplayTimer", 200

	} else if ( activate == -1 ) {
		SetTimer "pkl_OnDisplayTimer", "Off"
        if (wnd) {
            wnd.Destroy()
            wnd := 0
            imgCtrl := 0
        }
		prevFile := ""
		return
	}
	
	if ( guiActive == 0 ) {
		prevFile := ""
		return
	}


	; check if mouse is over the help image
	; and adjust y position of image (move to top or bottom.. toggle)
	MouseGetPos , , id
	if ( id == wnd.Hwnd ) {
		displayOnTop := 1 - displayOnTop
		if ( displayOnTop )
			yPosition := 5
		else
			yPosition := A_ScreenHeight - ImgHeight - 60
		; Gui, 2:Show, xCenter y%yPosition% AutoSize NA, pklHelperImage
	}

	; find current active window and its coords
	id := WinExist("A")
	WinGetPos x, y, width, height, "ahk_id " id
    if (!id) 
        return

    currWinCenter := x + (width / 2)

	xpos := 0
	if (CenterOnCurrWndMonitor) {
		; find out on which monitor the window is
		; (could get all monitors info beforehand
		;  but doesnt seem to take CPU (because of timer speed))
		Loop(MonitorGetCount()) {
			if (MonitorGet(A_Index, left, top, right, bottom)) {
				if (currWinCenter >= left and currWinCenter <= right) {
					; found it
					; X center on current monitor
					xpos := ((left + right) / 2) - (ImgWidth / 2)
					break
				}
			}
		}
	} else if (CenterOnCurrWindow) {
		;or X center on current window
		xpos := currWinCenter - (ImgWidth / 2)
	}

	; might want to avoid Show if same coords ..
	; if (xpos)
		; wnd.Show(Format("x{1} y{2} AutoSize NA", xpos, yPosition))
	; else
		; wnd.Show(Format("xCenter y{1} AutoSize NA", yPosition))
	if (xpos)
		wnd.Show("x" xpos "y" yPosition " AutoSize NA")
	else
		wnd.Show("xCenter y" yPosition " AutoSize NA")

	; PQuesnel 2017-05
	; check for image to display based on current layer
	if (!CurrentLayer)
		return

	; avoid flicker for access keys that can also output themselves,
	; skip 1st timer (not perfect, but helps)
	; if (!blockedKeySkipped) {
	; 	; already skipped once ?
	; 	if (prevSkippedLayerId != CurrentLayer.id) {
	; 		; ok, 1st time on this layer, skip if required
	; 		if (CurrentLayer.accessKey && !CurrentLayer.blockAccessKey) {
	; 			blockedKeySkipped := 1
	; 			prevSkippedLayerId := CurrentLayer.index
	; 			return
	; 		}
	; 	}
	; }

	; once we change layer, reset  prevSkippedLayerId
	; if (prevSkippedLayerId != CurrentLayer.index)
	; 	prevSkippedLayerId := 0

	; blockedKeySkipped := 0

	fileName := "layer" CurrentLayer.id

    shiftIsDown := 0
    if (GetKeyState("Shift")) {
        fileName .= "sh"
        shiftIsDown := 1
    }

	if ( prevFile == fileName )
		return

	if ( not FileExist( ImgsDir "\" fileName ".png" ) )  {
        if (shiftIsDown) {
            ; try using the unshifted image
            fileName := "layer" CurrentLayer.id
            if ( not FileExist( ImgsDir "\" fileName ".png" ) )  {
                fileName := ""
            }
        }
    }

	prevFile := fileName
    filepath := ImgsDir '\' fileName ".png"
    
    if (FileExist(filepath)) {
        ; imgSizePrefix := "*w" ImgWidth " *h" ImgHeight
        ; filepath := imgSizePrefix " " filepath
        imgCtrl.Value := filepath
    }
}

