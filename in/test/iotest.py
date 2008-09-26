#!/usr/bin/env python
from sord import *

# I/O test
nt = 10
nn = 50, 50, 50
np = 4, 4, 2
mpin  = 1
mpout = 1
faultnormal = 3
io = [
  ( 'w', ('u1','u2','u3'), _[1,:,:,:], 1 ),
  ( 'w', ('v1','v2','v3'), _[:,1,:,:], 1 ),
  ( 'w', ('a1','a2','a3'), _[:,:,1,:], 1 ),
  ( 'w', ('su1','su2','su3'), _[:,:,:,:], 1 ),
  ( 'w', ('sv1','sv2','sv3'), _[:,:,:,:], 1 ),
  ( 'w', ('sa1','sa2','sa3'), _[:,:,:,:], 1 ),
]