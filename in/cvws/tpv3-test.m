% TPV3
  faultnormal = 3;
  vrup = -1.;
  vp  = 6000.;
  vs  = 3464.;
  rho = 2670.;
  dc  = 0.4;
  mud = .525;
  mus = 10000.;
  mus = { .677    'cube' -601. -601. -1.  601. 601. 1. };
  tn  = -120e6;
  ts1 = -70e6;
  ts1 = { -81.6e6 'cube' -401. -401. -1.  401. 401. 1. };
  gam = .1;
  hourglass = [ 1. .7 ];
  fixhypo = -1;
  dx  = 100;
  dt  = .008;
  nt  = 10;
  bc1   = [  0  0  0 ];
  bc2   = [ -1  1 -2 ];
  ihypo = [ -1 -1 -2 ];
  nn    = [  8  8  9 ];
  np    = [  2  3  2 ];
  debug = 2;

  out = { 'x'    1   1 1 1 0   -1 -1 -1  0 };
  out = { 'rho'  1   1 1 1 0   -1 -1 -1  0 };
  out = { 'vp'   1   1 1 1 0   -1 -1 -1  0 };
  out = { 'vs'   1   1 1 1 0   -1 -1 -1  0 };
  out = { 'mu'   1   1 1 1 0   -1 -1 -1  0 };
  out = { 'lam'  1   1 1 1 0   -1 -1 -1  0 };
  out = { 'v'    1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'vm2'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'pv2'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'u'    1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'um2'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'w'    1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'wm2'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'a'    1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'am2'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'nhat' 1   1 1 1 0   -1 -1 -1  0 };
  out = { 'mus'  1   1 1 1 0   -1 -1 -1  0 };
  out = { 'mud'  1   1 1 1 0   -1 -1 -1  0 };
  out = { 'dc'   1   1 1 1 0   -1 -1 -1  0 };
  out = { 'co'   1   1 1 1 0   -1 -1 -1  0 };
  out = { 'ts'   1   1 1 1 0   -1 -1 -1 -1 };
  out = { 'tsm'  1   1 1 1 0   -1 -1 -1 -1 };
  out = { 'tn'   1   1 1 1 0   -1 -1 -1 -1 };
  out = { 'sv'   1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'svm'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'psv'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'su'   1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'sum'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'sl'   1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'sa'   1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'sam'  1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'trup' 1   1 1 1 1   -1 -1 -1 -1 };
  out = { 'tarr' 1   1 1 1 1   -1 -1 -1 -1 };
  timeseries = { 'v'  -200. 0. 0. };
  timeseries = { 'sv' -200. 0. 0. };
  timeseries = { 'v'  0. 0. 0. };
  timeseries = { 'v'  -801. -700. -700. };
  timeseries = { 'v'  101. 000. 000. };

