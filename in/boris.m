% Test run for Boris

  nn = [ 221 221 222 ];
  nt = 400;
  dx = .007;
  dt = .00005;
  rho = 16.;
  vp = 56.;
  vs = 30.;
  bc1 = [ 1 1 1 ];
  bc2 = [ 1 1 1 ];
  viscosity = [ .5 .5 ]	;
  faultnormal = 3;
  mus = 1.85;
  mud = 2.4;
  dc = .001;
  co = 0.;
  tn = -330.;
  th = 730.;
  td = 0.;
  vrup = 15.;
  rcrit = .4;
  out = { 'v' 1   1 1 0     -1 -1 0 };
  out = { 'v' 1   1 1 -10   -1 -1 -10 };
