% TPV3

  debug = 1;
  np = [ 1 1 1 ];
  faultnormal = 3;
  vrup = -1.;
  out = { 'x'    1      1 1 0  -1 -1 0 };
  out = { 'sv'   1      1 1 0  -1 -1 0 };
  out = { 'sl'   1      1 1 0  -1 -1 0 };
  out = { 'trup' 100    1 1 0  -1 -1 0 };
  vp  = 6000.;
  vs  = 3464.;
  rho = 2670.;
  dc  = 0.4;
  mud = .525;
  tn  = -120e6;
  td  = 0.;
  mus = 10000;
  th  = -70e6;
  viscosity = [ .1 .7 ];

  dx  = 300;
  dt  = .024;
  nt  = 40;
  mus = .677;
  th  = [ -81.6e6   16 16 0   25 25 0 ];

  nn  = [ 40 40 42 ];
  bc1 = [ 0 0 0 ];
  bc2 = [ 0 0 0 ];
  ihypo = [ 0 0 0 ];

  nn  = [ 20 40 42 ];
  bc1 = [ 0 0 0 ];
  bc2 = [ 2 0 0 ];
  ihypo = [ -1 -0 -0 ];

  nn  = [ 40 20 21 ];
  bc1 = [ 0 0 0 ];
  bc2 = [ 0 2 2 ];
  ihypo = [ -0 -1 -1 ];

  nn    = [ 20 20 21 ];
  bc1   = [  0  0  0 ];
  bc2   = [ -2  2 -2 ];
  ihypo = [ -1 -1 -1 ];

  return

  dx  = 300;
  dt  = .024;
  nt  = 300;
  mus = [ .677      26 26 0   125 75 0 ];
  th  = [ -81.6e6   71 46 0    80 55 0 ];
  bc1 = [ 1 1 1 ];
  bc2 = [ 2 2 2 ];
  nn  = [ 75 50 41 ];
  ihypo = [ -1 -1 -1 ];
  return

  dx  = 100;
  dt  = .008;
  nt  = 1626;
  nt  = 900;
  mus = [ .677       26 26 0   325 175 0 ];
  th  = [ -81.6e6   161 86 0   190 115 0 ];
  bc1 = [ 1 1 1 ];
  bc2 = [ 2 2 2 ];
  nn  = [ 175 100 61 ];
  ihypo = [ -1 -1 -1 ];
  return

