%------------------------------------------------------------------------------%

  model		= 'kostrov'			;
  n		= [ 41  41  42  ]		;
  nt		= 100				;
  bc		= [ 0 1 0   0 1 0 ]		;
  faultnormal	= 3				;
  mus		= 1e9				;
  dc		= 1e9				;
  co		= 0.				;
  tnrm		= -100e6			;
  tstr		= -90e6				;
  tdip		= 0.				;
  vrup		= 3117.6914			;
  rcrit		= 1e9				;
  trelax	= 0.				;
  out		= { 'x'  1   1 0 1   -1 0 -1 }	;
  out		= { 'vs' 1   1 0 1   -1 0 -1 }	;
