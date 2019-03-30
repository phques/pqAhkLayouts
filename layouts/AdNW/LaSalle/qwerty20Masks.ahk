
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

; 0 = std pos, -1 = shift left by 1, +1 shift right by 1 etc
; lsh: 0, -1
; rsh: 0, 1, 2
GetQwerty20Mask2(lsh, rsh)
{
	qmaskL := []
	if (lsh == 0)
		qmaskL := ["w e r", "a s d f g", "@LShift c"]
	else if (lsh == -1)
		qmaskL := ["q w e", "CapsLock a s d f", "@LShift x"]

	qmaskR := []
	if (rsh == 0)
		qmaskR := ["u i o", "h j k l `;", "m /"]
	else if (rsh == 1)
		qmaskR := ["i o p", "j k l `; '", ", @RShift"]
	else if (rsh == 2)
		qmaskR := ["o p [", "k l `; ' Cr", ". @RShift"]

 	ln1 := qmaskL[1]  " " qmaskR[1]
 	ln2 := qmaskL[2]  " " qmaskR[2]
 	ln3 := qmaskL[3]  " " qmaskR[3]
 	return ln1 "`r`n" ln2 "`r`n" ln3
}



