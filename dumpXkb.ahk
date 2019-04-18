global Layers

DumpXkb(layoutName, layerIdx)
{
	codesMap := getCodesMap()

	; open outputfile
	filename := "ahkXkbOut.txt"
	file := FileOpen(filename, "w")
	if !IsObject(file)
	{
	    MsgBox "Can't open '" FileName "' for writing."
	    return
	}

	; write first lines
	file.WriteLine("partial alphanumeric_keys")
	file.WriteLine(Format("xkb_symbols `"{}`" {", layoutName))
	file.WriteLine(Format("  name[Group1]= `"{}`";", layoutName))

	; go through mappings of this layer
	For fromKey, modsAndKey in CurrentLayer.mappings 
	{
		; get keys to output (normal and shifted)
		toKey := modsAndKey.key
		if (CurrentLayer.mappingsSH[fromKey])
			toKeySh := CurrentLayer.mappingsSH[fromKey].Key
		Else
			toKeySh := "NoSymbol"

		; get fromKey as hex scancode
		fromKeySC := Format("{:02x}", GetKeySC(fromKey))

		; do we know the xkb keycode for this scancode?
		if (codesMap[fromKeySC])
		{
			; format values for xkb output
			fromKeyCode := codesMap[fromKeySC]
			; if (!InStr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', toKey))
				toKeyUni := Format("U{:04X}", Ord(toKey))
			; if (!InStr('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', toKeySh))
				toKeyShUni := Format("U{:04X}", Ord(toKeySh))

			s := Format("  key <{}> { [ {}, {} ] };  // {}  {} {}",
				fromKeyCode, toKeyUni, toKeyShUni,
				fromKey, toKey, toKeySh)
		}
		Else
		{
			; unknown xkb key
			s := Format("  // {}  {} {}", fromKey, toKey, toKeySh)
		}

		; write this line to file
		file.WriteLine(s . "")
	}
	
	file.WriteLine("};")
	file.Close()
}

; returns a map of scancodes (2digits hex) to xkb keycode
getCodesMap()
{
	codes := {}
	codes["29"] := "TLDE"
	codes["02"] := "AE01"
	codes["03"] := "AE02"
	codes["04"] := "AE03"
	codes["05"] := "AE04"
	codes["06"] := "AE05"
	codes["07"] := "AE06"
	codes["08"] := "AE07"
	codes["09"] := "AE08"
	codes["0a"] := "AE09"
	codes["0b"] := "AE10"
	codes["0c"] := "AE11"
	codes["0d"] := "AE12"

	codes["10"] := "AD01"
	codes["11"] := "AD02"
	codes["12"] := "AD03"
	codes["13"] := "AD04"
	codes["14"] := "AD05"
	codes["15"] := "AD06"
	codes["16"] := "AD07"
	codes["17"] := "AD08"
	codes["18"] := "AD09"
	codes["19"] := "AD10"
	codes["1a"] := "AD11"
	codes["1b"] := "AD12"
	codes["2b"] := "BKSL"

	codes["1e"] := "AC01"
	codes["1f"] := "AC02"
	codes["20"] := "AC03"
	codes["21"] := "AC04"
	codes["22"] := "AC05"
	codes["23"] := "AC06"
	codes["24"] := "AC07"
	codes["25"] := "AC08"
	codes["26"] := "AC09"
	codes["27"] := "AC10"
	codes["28"] := "AC11"

	codes["2c"] := "AB01"
	codes["2d"] := "AB02"
	codes["2e"] := "AB03"
	codes["2f"] := "AB04"
	codes["30"] := "AB05"
	codes["31"] := "AB06"
	codes["32"] := "AB07"
	codes["33"] := "AB08"
	codes["34"] := "AB09"
	codes["35"] := "AB10"

	; dont output
	; codes["39"] = "-"
	; codes["53"] = "-"

	; map LShift to LSGT
    ; I think this the extra key on pc105 kbd:  shift/lsgt/z/x/c/v..) 
    ; I use this to have a key defined in the xkb map, when using Shift_L to output a letter, with xcape
    ; ie to do "angle mod"
    codes["2a"] := "LSGT" 

    Return codes
}