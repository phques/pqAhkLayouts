; numpad layer

NumpadLayerMappings()
{
	; these two are designed for layer access with left hand on B
	; left hand home is (LaSalle) xDFb (B is layer access key, with index)
	indexOnB := "
	(Join`r`n
	      r t   u i o p         : tab      7 8 9 BS
	    d f g h j k l ; '       + - .    , 4 5 6 0 CR
	  x c v     m , . /       = / *        1 2 3 . 
	)"

	indexOnBwide := "
	(Join`r`n
	      r t     i o p [           : tab    7 8 9 BS
	    d f g   j k l ; '         + - .    , 4 5 6 0  
	  x c v     m , . /         = / *      . 1 2 3   
	)"

	; use thumb to press B, home row is (LaSalle) aWEf
	thumbOnB := "
	(Join`r`n
	  w e r t   u i o p         + - : tab    7 8 9 BS
	 a  d f   h j k l ; '     /   * .      , 4 5 6 0 CR
	      c     m , . /             =        1 2 3 . 
	)"

	; use thumb to press B, home row is (LaSalle) aWEf
	thumbOnBwide := "
	(Join`r`n
	  w e r t   i o p [         + - : tab    7 8 9 BS
	 a  d f   j k l ; '       /   * .      , 4 5 6 0 
	      c   m , . /               =      . 1 2 3   
	)"

	return { indexOnB: indexOnB, 
			 thumbOnB: thumbOnB, 
			 indexOnBwide: indexOnBwide, 
			 thumbOnBwide: thumbOnBwide,  }
}