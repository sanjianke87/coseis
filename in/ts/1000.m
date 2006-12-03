% Terashake 1000m
  upvector = [ 0 0 1 ];
  bc1 = [ 1 1 1 ];
  bc2 = [ 1 1 0 ];
  faultnormal = 2;
  grid = 'read';
  rho = 'read';
  vp = 'read';
  vs = 'read';
  vs1 = 500.;
  vp1 = 1500.;
  vdamp = 400.;
  tn = -20e6;
  ts1 = 'read';
  mus = 1000.;
  mud = .5;
  dc = .5;
  rcrit = 3000.;
  vrup = 2300.;
  itcheck = 100;


  np = [ 2 1 1 ] % Wide
  np = [ 8 4 1 ] % Babiaca
  dx = 1000.;
  dt = .06;
  trelax = .6;
  nt = 3000;
  nn = [ 601 302 81 ];
  ihypo = [ 273 200 -6 ];
  ihypo = [ 454 200 -6 ];
  mus = [ 1.03 'zone'  264 0 -17         463  0 -1      ];
  out = { 'x'     1    264 0 -17    0    463  0 -1    0 };
  out = { 'rho'   1    264 0 -17    0    463  0 -1    0 };
  out = { 'vp'    1    264 0 -17    0    463  0 -1    0 };
  out = { 'vs'    1    264 0 -17    0    463  0 -1    0 };
  out = { 'tn'   10    264 0 -17    0    463  0 -1 1500 };
  out = { 'tsm'  10    264 0 -17    0    463  0 -1 1500 };
  out = { 'sl'   10    264 0 -17    0    463  0 -1 1500 };
  out = { 'svm'  10    264 0 -17    0    463  0 -1 1500 };
  out = { 'psv'  10    264 0 -17    0    463  0 -1 1500 };
  out = { 'trup'  1    264 0 -17 1500    463  0 -1 1500 };
  out = { 'x'     1      1 1  -1    0     -1 -1 -1    0 };
  out = { 'vm'   10      1 1  -1    0     -1 -1 -1 3000 };
  out = { 'pv' 1500      1 1  -1 1500     -1 -1 -1 3000 };
  timeseries = { 'v'  82188. 188340. 129. }; % Bakersfield
  timeseries = { 'v'  99691.  67008.  21. }; % Santa Barbara
  timeseries = { 'v' 152641.  77599.  16. }; % Oxnard
  timeseries = { 'v' 191871. 180946. 714. }; % Lancaster
  timeseries = { 'v' 216802. 109919.  92. }; % Westwood
  timeseries = { 'v' 229657. 119310. 107. }; % Los Angeles
  timeseries = { 'v' 242543. 123738.  63. }; % Montebello
  timeseries = { 'v' 253599.  98027.   7. }; % Long Beach
  timeseries = { 'v' 256108. 263112. 648. }; % Barstow
  timeseries = { 'v' 263052. 216515. 831. }; % Victorville
  timeseries = { 'v' 271108. 155039. 318. }; % Ontario
  timeseries = { 'v' 278097. 115102.  36. }; % Santa Ana
  timeseries = { 'v' 293537. 180173. 327. }; % San Bernardino
  timeseries = { 'v' 296996. 160683. 261. }; % Riverside
  timeseries = { 'v' 351928.  97135.  18. }; % Oceanside
  timeseries = { 'v' 366020. 200821. 140. }; % Palm Springs
  timeseries = { 'v' 403002. 210421. -18. }; % Coachella
  timeseries = { 'v' 402013.  69548.  23. }; % San Diego
  timeseries = { 'v' 501570.  31135.  24. }; % Ensenada
  timeseries = { 'v' 526989. 167029.   1. }; % Mexicali
  timeseries = { 'v' 581530. 224874.  40. }; % Yuma

