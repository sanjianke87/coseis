% PEER LOH.1

  affine = [ 1. 0. 0.   1. 1. 1.   0. 0. 1.   1. ];
  dx  = 50.;
  dt  = .004;
  nt  = 2250;
  vp  = 6000.;
  vs  = 3464.;
  rho = 2700.;
  gam = .0;
  vp  = { 4000. 'zone'   1 1 1   -1 -1 21 };
  vs  = { 2000. 'zone'   1 1 1   -1 -1 21 };
  rho = { 2600. 'zone'   1 1 1   -1 -1 21 };
  hourglass = [ 1. 4. ];
  bc1 = [ -2  0  0 ];
  bc2 = [  1  0  1 ];
  n1expand = [ 0 50 0 ];
  n2expand = [ 0 50 0 ];

  nn    = [  161  482 101 ];
  ihypo = [ -162  321  41 ];
  xhypo = [ 0. 0. 2000. ];
  fixhypo = -2;
  rsource = 25.;
  tsource = .1;
  tfunc = 'brune';
  moment1 = [ 0. 0. 0. ];
  moment2 = [ 0. 0. 1e18 ];
  faultnormal = 0;

  itcheck = 0;
  np = [ 1 1 2 ];

  timeseries = { 'v' 5999.  7999. -1. };
  timeseries = { 'v' 6001.  8001. -1. };
  timeseries = { 'v' 5999. -7999. -1. };
  timeseries = { 'v' 6001. -8001. -1. };

% out = { 'x'  0   1 0 1 0  -1  0 -1  0 };
% out = { 'v' 40   1 0 1 0  -1  0 -1 -1 };
% out = { 'x'  0   1 1 0 0  -1 -1  0  0 };
% out = { 'v' 40   1 1 0 0  -1 -1  0 -1 };
