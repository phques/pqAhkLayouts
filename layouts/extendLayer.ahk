
; extend / edit layer

ExtendLayerMappings()
{
	; note: when using LAlt to access this layer, one could move the hand and
	;   use the std shift and ctl, or move the hand and use A/S for ctl / shift or
	;   stay at home pos and use A/F for ctl / shift
	layer := "
	(Join`r`n
        1 2 3 4 5 6 7 8 9 0 - =     F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12
        q w e r     y u i o p [     insert escape tab alt         PgUp Home Up   End   Delete    AppsKey
       CL a s f g   h j k l ; '     LWin Control Shift Shift !Esc PgDn Left Down Right Backspace Enter
        z x c v b     m , . /        ^z ^x ^c ^v Space               ^c   ^x   ^v    ^z
    )"
        ; LSh RSh LCt RCt              LSh RSh LCt RCt
    return layer
}
             
ExtendLayerMappingsAlt()
{
    ; note: when using LAlt to access this layer, one could move the hand and
    ;   use the std shift and ctl, or move the hand and use A/S for ctl / shift or
    ;   stay at home pos and use A/F for ctl / shift
    layer := "
    (Join`r`n
        1 2 3 4 5 6 7 8 9 0 - =     F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12
        q w e r     y u i o p [     insert escape tab alt         PgUp Home Up   End   Delete    AppsKey
       CL a s f g   h j k l ; '     LWin Shift Control Shift !Esc PgDn Left Down Right Backspace Enter
        z x c v b     m , . /        ^z ^x ^c ^v Space               ^c   ^x   ^v    ^z
    )"
        ; LSh RSh LCt RCt              LSh RSh LCt RCt
    return layer
}
             
ExtendLayerMappingsWide()
{
    ; note: when using LAlt to access this layer, one could move the hand and
    ;   use the std shift and ctl, or move the hand and use A/S for ctl / shift or
    ;   stay at home pos and use A/F for ctl / shift
    layer := "
    (Join`r`n
        1 2 3 4 5 6 7 8 9 0 - =     F1 F2 F3 F4 F5 F6 F7 F8 F9 F10 F11 F12
        q w e r     u i o p [     insert escape tab alt           PgUp Home Up   End   Delete    
       CL a s f g   j k l ; '     LWin Control Shift Shift !Esc   PgDn Left Down Right Backspace 
        z x c v b   m , . /        ^z ^x ^c ^v Space               ^z  ^c   ^x   ^v
    )"
        ; LSh RSh LCt RCt              LSh RSh LCt RCt
    return layer
}
