; pqAhkLayouts project
; Copyright 2018 Philippe Quesnel
; Licensed under the Academic Free License version 3.0

; key => 'sc000'
FormatAsScancode(key)
{
	return Format("sc{:03x}", GetKeySC(key))
}

