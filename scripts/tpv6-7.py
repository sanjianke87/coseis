#!/usr/bin/env python
"""
TPV6 - SCEC validation problem versions 6 & 7
"""
import sord

_version = 6
np3 = 1, 1, 32
dx = 50.0, 50.0, 50.0
dt = dx[0] / 12500.
nn = (
    int( 33000.0 / dx[0] + 41.001 ),
    int( 18000.0 / dx[1] + 41.001 ),
    int( 12000.0 / dx[2] + 40.001 ),
)
nt = int( 12.0 / dt + 1.5 )
bc1 = 10,  0, 10
bc2 = 10, 10, 10
hourglass = 1.0, 2.0

faultnormal = 3	
vrup = -1.

if _version == 6:
    _rho = 2670.0, 2225.0
    _vp  = 6000.0, 3750.0
    _vs  = 3464.0, 2165.0
else:
    _rho = 2670.0, 2670.0
    _vp  = 6000.0, 5000.0
    _vs  = 3464.0, 2887.0

FIXME
ihypo = 0, 0, 
_l = nn[2] / 2
_j = nn[0] / 2
_k     = int(  7500.0 / dx[1] + 1.001 )
_1500  = int(  1500.0 / dx[0] + 0.001 )
_4500  = int(  4500.0 / dx[0] + 0.001 )
_15000 = int( 15000.0 / dx[0] + 0.001 )
_j0 = _j - _15000,     _j + _15000
_j1 = _j - _1500,      _j + _1500
_j2 = _j - _1500 + 1,  _j + _1500 - 1
_k0 =  1,               1 + _15000
_k1 = _k - _1500,      _k + _1500
_k2 = _k - _1500 + 1,  _k + _1500 - 1
_l0 = _l - _4500,      _l + _4500
_l1 =  1,              _l
_l2 = _l + 1,          -1
fieldio = [
    ( '=',  'rho',  [], 0.5 * ( _rho[0] + _rho[1] ) ),
    ( '=',  'vp',   [], 0.5 * ( _vp[0]  + _vp[1]  ) ),
    ( '=',  'vs',   [], 0.5 * ( _vs[0]  + _vs[1]  ) ),
    ( '=',  'rho',  [ (), (), _l1, () ], _rho[0] ),
    ( '=',  'vp',   [ (), (), _l1, () ], _vp[0]  ),
    ( '=',  'vs',   [ (), (), _l1, () ], _vs[0]  ),
    ( '=',  'rho',  [ (), (), _l2, () ], _rho[1] ),
    ( '=',  'vp',   [ (), (), _l2, () ], _vp[1]  ),
    ( '=',  'vs',   [ (), (), _l2, () ], _vs[1]  ),
    ( '=',  'gam',  [],                    0.2   ),
    ( '=',  'gam',  [ _j0, _k0, _l0, () ], 0.02  ),
    ( '=',  'dc',   [],                    0.4   ),
    ( '=',  'mud',  [],                    0.525 ),
    ( '=',  'mus',  [],                    1e4   ),
    ( '=',  'mus',  [ _j0, _k0, (), () ],  0.677 ),
    ( '=',  'tn',   [],                   -120e6 ),
    ( '=',  'ts',   [],                     70e6 ),
    ( '=',  'ts',   [ _j1, _k1, (), () ], 72.9e6 ),
    ( '=',  'ts',   [ _j1, _k2, (), () ], 75.8e6 ),
    ( '=',  'ts',   [ _j2, _k1, (), () ], 75.8e6 ),
    ( '=',  'ts',   [ _j2, _k2, (), () ], 81.6e6 ),
    ( '=w', 'trup', [ _j0, _k0, (), -1 ], 'trup' ),
]

_12000 = int( 12000.0 / dx[0] + 0.5 )
_j1, _j2 = _j - _12000,  _j + _12000
_l1, _l2 = _l,  _l + 1
for _f in 'u1', 'u2', 'u3', 'v1', 'v2', 'v3', 'ts1', 'ts2', 'tnm':
    fieldio += [
        ( '=w', _f, [ _j,   1, _l1, () ], 'nearst000dp000'  + _f ),
        ( '=w', _f, [ _j1,  1, _l1, () ], 'nearst-120dp000' + _f ),
        ( '=w', _f, [ _j1, _k, _l1, () ], 'nearst-120dp075' + _f ),
        ( '=w', _f, [ _j2,  1, _l1, () ], 'nearst120dp000'  + _f ),
        ( '=w', _f, [ _j2, _k, _l1, () ], 'nearst120dp075'  + _f ),
        ( '=w', _f, [ _j,   1, _l2, () ], 'farst000dp000'   + _f ),
        ( '=w', _f, [ _j1,  1, _l2, () ], 'farst-120dp000'  + _f ),
        ( '=w', _f, [ _j1, _k, _l2, () ], 'farst-120dp075'  + _f ),
        ( '=w', _f, [ _j2,  1, _l2, () ], 'farst120dp000'   + _f ),
        ( '=w', _f, [ _j2, _k, _l2, () ], 'farst120dp075'   + _f ),
    ]

rundir = '~/run/tpv%s' % _version
sord.run( locals() )

