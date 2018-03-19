
; key => 'sc000'
FormatAsScancode(key)
{
	return Format("sc{:03x}", GetKeySC(key))
}

