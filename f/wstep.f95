!------------------------------------------------------------------------------!
! WSTEP

module wstep_m
contains
subroutine wstep
use globals_m
use dfnc_m
use utils_m

implicit none
integer :: ic, id, ix, iz

if ( verb > 1 ) print '(a)', 'Wstep'
! Gadient
! G = grad(U + gam*V)    non PML region
! G' + DG = gradV          PML region
s2 = 0.
w2 = 0.
outer: do ic = 1, 3
s1 = u(:,:,:,ic) + gam(1) * v(:,:,:,ic)
inner: do id = 1, 3
  ix = 6 - ic - id
  do iz = 1, noper
    call zoneselect( i1, i2, ioper(iz,:), ng, offset, hypocenter, nrmdim )
    i1 = max( i1, i1cellpml )
    i2 = min( i2 - 1, i2cellpml )
    call dfnc( s2, oper(iz), s1, x, dx, 1, id, i1, i2 )
  end do
  do i = 1, npml
    if ( id /= 1 .and. bc(1) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      j = i1(1) + i - 1
      i1(1) = j
      i2(1) = j
      call dfnc( s2, oper(1), u, x, dx, ic, id, i1, i2 )
    end if
    if ( id /= 1 .and. bc(4) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      j = i2(1) - i + 1
      i1(1) = j
      i2(1) = j
      call dfnc( s2, oper(1), u, x, dx, ic, id, i1, i2 )
    end if
    if ( id /= 2 .and. bc(2) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      k = i1(2) + i - 1
      i1(2) = k
      i2(2) = k
      call dfnc( s2, oper(1), u, x, dx, ic, id, i1, i2 )
    end if
    if ( id /= 2 .and. bc(5) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      k = i2(2) - i + 1
      i1(2) = k
      i2(2) = k
      call dfnc( s2, oper(1), u, x, dx, ic, id, i1, i2 )
    end if
    if ( id /= 3 .and. bc(3) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      l = i1(3) + i - 1
      i1(3) = l
      i2(3) = l
      call dfnc( s2, oper(1), u, x, dx, ic, id, i1, i2 )
    end if
    if ( id /= 3 .and. bc(6) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      l = i2(3) - i + 1
      i1(3) = l
      i2(3) = l
      call dfnc( s2, oper(1), u, x, dx, ic, id, i1, i2 )
    end if
  end do
  do i = 1, npml
    if ( id == 1 .and. bc(1) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      j = i1(1) + i - 1
      i1(1) = j
      i2(1) = j
      call dfnc( s2, oper(1), v, x, dx, ic, id, i1, i2 )
      forall( k=i1(2):i2(2), l=i1(3):i2(3) )
        s2(j,k,l) = dc2(i) * s2(j,k,l) + dc1(i) * g1(i,k,l,ic)
        g1(i,k,l,ic) = s2(j,k,l)
      end forall
    end if
    if ( id == 1 .and. bc(4) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      j = i2(1) - i + 1
      i1(1) = j
      i2(1) = j
      call dfnc( s2, oper(1), v, x, dx, ic, id, i1, i2 )
      forall( k=i1(2):i2(2), l=i1(3):i2(3) )
        s2(j,k,l) = dc2(i) * s2(j,k,l) + dc1(i) * g4(i,k,l,ic)
        g4(i,k,l,ic) = s2(j,k,l)
      end forall
    end if
    if ( id == 2 .and. bc(2) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      k = i1(2) + i - 1
      i1(2) = k
      i2(2) = k
      call dfnc( s2, oper(1), v, x, dx, ic, id, i1, i2 )
      forall( j=i1(1):i2(1), l=i1(3):i2(3) )
        s2(j,k,l) = dc2(i) * s2(j,k,l) + dc1(i) * g2(j,i,l,ic)
        g2(j,i,l,ic) = s2(j,k,l)
      end forall
    end if
    if ( id == 2 .and. bc(5) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      k = i2(2) - i + 1
      i1(2) = k
      i2(2) = k
      call dfnc( s2, oper(1), v, x, dx, ic, id, i1, i2 )
      forall( j=i1(1):i2(1), l=i1(3):i2(3) )
        s2(j,k,l) = dc2(i) * s2(j,k,l) + dc1(i) * g5(j,i,l,ic)
        g5(j,i,l,ic) = s2(j,k,l)
      end forall
    end if
    if ( id == 3 .and. bc(3) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      l = i1(3) + i - 1
      i1(3) = l
      i2(3) = l
      call dfnc( s2, oper(1), v, x, dx, ic, id, i1, i2 )
      forall( j=i1(1):i2(1), k=i1(2):i2(2) )
        s2(j,k,l) = dc2(i) * s2(j,k,l) + dc1(i) * g3(j,k,i,ic)
        g3(j,k,i,ic) = s2(j,k,l)
      end forall
    end if
    if ( id == 3 .and. bc(6) == 1 ) then
      i1 = i1cell
      i2 = i2cell
      l = i2(3) - i + 1
      i1(3) = l
      i2(3) = l
      call dfnc( s2, oper(1), v, x, dx, ic, id, i1, i2 )
      forall( j=i1(1):i2(1), k=i1(2):i2(2) )
        s2(j,k,l) = dc2(i) * s2(j,k,l) + dc1(i) * g6(j,k,i,ic)
        g6(j,k,i,ic) = s2(j,k,l)
      end forall
    end if
  end do
  if ( ic == id ) then
    w1(:,:,:,ic) = s2
  else
    w2(:,:,:,ix) = w2(:,:,:,ix) + s2
  end if
end do inner
end do outer

! Hook's Law, linear stress/strain relation
! W = lam*trace(G)*I + miu*(G + G^T)
s1 = lam * sum( w1, 4 )
do i = 1, 3
  w1(:,:,:,i) = 2. * miu * w1(:,:,:,i) + s1
  w2(:,:,:,i) =      miu * w2(:,:,:,i)
end do

! Moment source
!if msrcradius, momentsrc, end

! Magnitudes
s1 = sqrt( sum( u * u, 4 ) )
s2 = sqrt( sum( w1 * w1, 4 ) + 2. * sum( w2 * w2, 4 ) )
umax = maxval( s1 ); umaxi = maxloc( s1 )
wmax = maxval( s2 ); wmaxi = maxloc( s2 )
if ( umax > dx / 10. ) print *, 'Warning: u !<< dx\n'

end subroutine
end module
