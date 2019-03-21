; numpad layer

NumpadLayerMappings()
{
	; these two are designed for layer access with left hand on B
	; left hand home is (LaSalle) xDFb (B is layer access key, with index)
	indexOnB := "
	(Join`r`n
	            u i o p                 7 8 9 BS
	    d f   h j k l ; '       + -   , 4 5 6 0 CR
	  x c v     m , . /       = / *     1 2 3 . 
	)"

	; use thumb to press B, home row is (LaSalle) aWEf
	thumbOnB := "
	(Join`r`n
	  w e       u i o p         + -       7 8 9 BS
	 a  d f   h j k l ; '     /   = *   , 4 5 6 0 CR
	            m , . /                   1 2 3 . 
	)"

	return { indexOnB: indexOnB, thumbOnB: thumbOnB }
}