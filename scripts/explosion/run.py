#!/usr/bin/env python
"""
Explosion test problem
"""
import sord

np3 = 1, 1, 2
dx = [ 100.0 ] * 3
dx = [ 50.0 ] * 3

dt = dx[0] / 12500.0
_T = 3.0
_L = 6000.0
nn = [ int( _L / dx[0] + 1.0001 ) ] * 3
nt =   int( _T / dt + 1.0001 )
fixhypo = -1 

# material
_rho, _vp, _vs = 2670.0, 6000.0, 3464.0
fieldio = [
    ( '=', 'rho', [], _rho ),
    ( '=', 'vp',  [], _vp  ),
    ( '=', 'vs',  [], _vs  ),
    ( '=', 'gam', [],  0.0 ),
]

# output
for _f in 'x1', 'x2', 'x3', 'v1', 'v2', 'v3':
    fieldio += [
        ( '=wx', _f, [], 'p1_'+_f, (  -1.,   -1., 3999.) ),
        ( '=wx', _f, [], 'p2_'+_f, (  -1., 2999., 3999.) ),
        ( '=wx', _f, [], 'p3_'+_f, (  -1., 3999., 3999.) ),
        ( '=wx', _f, [], 'p4_'+_f, (2999., 2999., 3999.) ),
        ( '=wx', _f, [], 'p5_'+_f, (2999., 3999., 3999.) ),
        ( '=wx', _f, [], 'p6_'+_f, (3999., 3999., 3999.) ),
    ]

src_function = 'brune'
src_period = 0.1
bc2 = 10, 10, 10

rundir = 'tmp/1'
src_type = 'potency'
bc1 = 1, 1, 1
ihypo = 1, 1, 1
src_w1 = 3 * [ 1.0 ]
src_w2 = 3 * [ 0.0 ]
sord.run( locals() )

rundir = 'tmp/2'
src_type = 'moment'
bc1 = 1, 1, 1
ihypo = 1, 1, 1
src_w1 = 3 * [ 3*_rho*_vp*_vp - 4*_rho*_vs*_vs ]
src_w2 = 3 * [ 0.0 ]
sord.run( locals() )

rundir = 'tmp/3'
src_type = 'moment'
bc1 = 2, 2, 2
ihypo = 1.5, 1.5, 1.5
src_w1 = 3 * [ 3*_rho*_vp*_vp - 4*_rho*_vs*_vs ]
src_w2 = 3 * [ 0.0 ]
sord.run( locals() )

