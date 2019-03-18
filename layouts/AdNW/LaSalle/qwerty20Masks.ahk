
GetQwerty20Mask(lsh, rsh)
{
	; note that 'std' right hand is still shifted right by 1
	qwertyMask20Std := "
	(Join`r`n
	          w e r      i o p
	        a s d f g  j k l ; '
	  @LShift    c       ,     @RShift
	)"

	qwertyMask20Lsh := "
	(Join`r`n
	             q w e      i o p
	    CapsLock a s d f  j k l ; '
	    @LShift      x      ,     @RShift
	)"

	qwertyMask20RSh := "
	(Join`r`n
	           w e r      o p [
	         a s d f g  k l ; ' Enter
	   @LShift    c       .     @RShift
	)"

	qwertyMask20LRSh := "
	(Join`r`n
	             q w e      o p [
	    CapsLock a s d f  k l ; ' Enter
	    @LShift      x      .     @RShift
	)"

	if (lsh & rsh)
	  qwertyMask20 := qwertyMask20LRsh
	else if (lsh)
	  qwertyMask20 := qwertyMask20Lsh
	else if (rsh)
	  qwertyMask20 := qwertyMask20Rsh
	else 
	  qwertyMask20 := qwertyMask20Std

	return qwertyMask20
}