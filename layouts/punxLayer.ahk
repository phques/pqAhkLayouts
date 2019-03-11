; punctation / symbols layer, (based on BEAKL15 puncs)

PunxLayerMappings()
{
	; dup '%', depending on kbd, T or H might be easier
	layer := "
	(Join`r`n
	      q w e r t    u i o p          $ < - > %    ~ [ ] @ 
	   CL a s d f g  h j k l ;        _ \ ( " ) !  % { = } ;
	      z x c v      m , . /          # : * +      & ^ _ | 
	)"

	; right hand moved by 1 to the right , w. bottom right pinky on RShift
	; (eg for RAlt access, move hand right to access)
	layerWideRight := "
	(Join`r`n
	      q w e r t      i o p [        $ < - > %     ~ [ ] @
	   CL a s d f g    j k l ; '      _ \ ( " ) !   % { = } ;
	      z x c v        , . / RSh      # : * +       & ^ _ |
	)"

	; AngleZ, left bott pinky on LShift
	layerAZ := "
	(Join`r`n
	       q w e r t    u i o p         $ < - > %    ~ [ ] @ 
	   CL  a s d f g  h j k l ;       _ \ ( " ) !  % { = } ;
	   LSh z x c        m , . /         # : * +      & ^ _ | 
	)"

	layerAZWideRight := "
	(Join`r`n
	       q w e r t      i o p [       $ < - > %     ~ [ ] @
	   CL  a s d f g    j k l ; '     _ \ ( " ) !   % { = } ;
	   LSh z x c          , . / RSh     # : * +       & ^ _ |
	)"

	return { layer: layer, 
		     layerWideRight: layerWideRight, 
			 layerAZ: layerAZ, 
			 layerAZWideRight: layerAZWideRight }
}