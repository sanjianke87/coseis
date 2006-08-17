! Collective routines - MPI version
module m_collective
use mpi
implicit none
integer :: comm3d, comm2d(3)
integer, private :: ip, ipmaster
contains

! Initialize
subroutine initialize( ipout, np0, master )
logical, intent(out) :: master
integer, intent(out) :: ipout, np0
integer :: e
call mpi_init( e )
call mpi_comm_rank( mpi_comm_world, ip, e  )
call mpi_comm_size( mpi_comm_world, np0, e  )
ipout = ip
master = .false.
if ( ip == 0 ) master = .true.
end subroutine

! Finalize
subroutine finalize
integer :: e
call mpi_finalize( e )
end subroutine

! Processor rank
subroutine rank( ipout, ip3, np )
integer, intent(out) :: ipout, ip3(3)
integer, intent(in) :: np(3)
integer :: i, e
logical :: period(3) = .false.
call mpi_cart_create( mpi_comm_world, 3, np, period, .true., comm3d, e )
if ( comm3d == mpi_comm_null ) then
  print *, 'Unused processor:', ip
  call mpi_finalize( e )
  stop
end if
call mpi_comm_rank( comm3d, ip, e  )
call mpi_cart_coords( comm3d, ip, 3, ip3, e )
ipout = ip
do i = 1, 3
  call mpi_comm_split( comm3d, ip3(i), 0, comm2d(i), e )
end do
end subroutine

! Set master processor
subroutine setmaster( ip3master )
integer, intent(in) :: ip3master(3)
integer :: e
call mpi_cart_rank( comm3d, ip3master, ipmaster, e )
end subroutine

! Integer broadcast
subroutine ibroadcast( i )
real, intent(inout) :: i
integer :: e
call mpi_bcast( i, 1, mpi_real, ipmaster, comm3d, e )
end subroutine

! Real broadcast
subroutine broadcast( r )
real, intent(inout) :: r(:)
integer :: i, e
i = size(r)
call mpi_bcast( r, i, mpi_real, ipmaster, comm3d, e )
end subroutine

! Real sum
subroutine psum( rr, r, i2d )
real, intent(out) :: rr
real, intent(in) :: r
integer, intent(in) :: i2d
integer :: e, comm
comm = comm3d
if ( i2d /= 0 ) comm = comm2d(i2d)
call mpi_allreduce( r, rr, 1, mpi_real, mpi_sum, comm, e )
end subroutine

! Integer minimum
subroutine pimin( ii, i )
integer, intent(out) :: ii
integer, intent(in) :: i
integer :: e
call mpi_allreduce( i, ii, 1, mpi_integer, mpi_min, comm3d, e )
end subroutine

! Real minimum
subroutine pmin( rr, r )
real, intent(out) :: rr
real, intent(in) :: r
integer :: e
call mpi_allreduce( r, rr, 1, mpi_real, mpi_min, comm3d, e )
end subroutine

! Real maximum
subroutine pmax( rr, r )
real, intent(out) :: rr
real, intent(in) :: r
integer :: e
call mpi_allreduce( r, rr, 1, mpi_real, mpi_max, comm3d, e )
end subroutine

! Real global minimum & location
subroutine pminloc( rr, ii, r, nn, nnoff, i2d )
real, intent(out) :: rr
real, intent(in) :: r(:,:,:)
integer, intent(out) :: ii(3)
integer, intent(in) :: nn(3), nnoff(3), i2d
integer :: i, comm, e
real :: local(2), global(2)
ii = minloc( r )
local(1) = r(ii(1),ii(2),ii(3))
ii = ii - nnoff - 1
local(2) = ii(1) + nn(1) * ( ii(2) + nn(2) * ii(3) )
comm = comm3d
if ( i2d /= 0 ) comm = comm2d(i2d)
call mpi_allreduce( local, global, 1, mpi_2real, mpi_minloc, comm, e )
rr = global(1)
i = global(2)
ii(3) = i / ( nn(1) * nn(2) )
ii(2) = modulo( i / nn(1), nn(2) )
ii(1) = modulo( i, nn(1) )
ii = ii + 1 + nnoff
end subroutine

! Real global maximum & location
subroutine pmaxloc( rr, ii, r, nn, nnoff, i2d )
real, intent(out) :: rr
real, intent(in) :: r(:,:,:)
integer, intent(out) :: ii(3)
integer, intent(in) :: nn(3), nnoff(3), i2d
integer :: i, comm, e
real :: local(2), global(2)
ii = maxloc( r )
local(1) = r(ii(1),ii(2),ii(3))
ii = ii - nnoff - 1
local(2) = ii(1) + nn(1) * ( ii(2) + nn(2) * ii(3) )
comm = comm3d
if ( i2d /= 0 ) comm = comm2d(i2d)
call mpi_allreduce( local, global, 1, mpi_2real, mpi_maxloc, comm, e )
rr = global(1)
i = global(2)
ii(3) = i / ( nn(1) * nn(2) )
ii(2) = modulo( i / nn(1), nn(2) )
ii(1) = modulo( i, nn(1) )
ii = ii + 1 + nnoff
end subroutine

! Vector send
subroutine vectorsend( f, i1, i2, i )
real, intent(inout) :: f(:,:,:,:)
integer, intent(in) :: i1(3), i2(3), i
integer :: ng(4), nl(4), i0(4), prev, next, dtype, e
ng = (/ size(f,1), size(f,2), size(f,3), size(f,4) /)
nl = (/ i2 - i1 + 1, ng(4) /)
i0 = (/ i1 - 1, 0 /)
call mpi_cart_shift( comm3d, abs(i)-1, sign(1,i), prev, next, e )
call mpi_type_create_subarray( 4, ng, nl, i0, mpi_order_fortran, mpi_real, dtype, e )
call mpi_type_commit( dtype, e )
call mpi_send( f(1,1,1,1), 1, dtype, next, 0, comm3d, e )
do e = 1,1; end do ! bug work-around, need slight delay here for MPICH2
call mpi_type_free( dtype, e )
end subroutine

! Vector recieve
subroutine vectorrecv( f, i1, i2, i )
real, intent(inout) :: f(:,:,:,:)
integer, intent(in) :: i1(3), i2(3), i
integer :: ng(4), nl(4), i0(4), prev, next, dtype, e
ng = (/ size(f,1), size(f,2), size(f,3), size(f,4) /)
nl = (/ i2 - i1 + 1, ng(4) /)
i0 = (/ i1 - 1, 0 /)
call mpi_cart_shift( comm3d, abs(i)-1, sign(1,i), prev, next, e )
call mpi_type_create_subarray( 4, ng, nl, i0, mpi_order_fortran, mpi_real, dtype, e )
call mpi_type_commit( dtype, e )
call mpi_recv( f(1,1,1,1), 1, dtype, next, 0, comm3d, mpi_status_ignore, e )
call mpi_type_free( dtype, e )
end subroutine

! Scalar swap halo
subroutine scalarswaphalo( f, nhalo )
real, intent(inout) :: f(:,:,:)
integer, intent(in) :: nhalo
integer :: i, e, prev, next, ng(3), nl(3), isend(4), irecv(4), tsend, trecv
ng = (/ size(f,1), size(f,2), size(f,3) /)
do i = 1, 3
if ( ng(i) > 1 ) then
  call mpi_cart_shift( comm3d, i-1, 1, prev, next, e )
  nl = ng
  nl(i) = nhalo
  isend = 0
  irecv = 0
  isend(i) = ng(i) - 2 * nhalo
  call mpi_type_create_subarray( 3, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 3, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f(1,1,1), 1, tsend, next, 0, f(1,1,1), 1, trecv, prev, 0, comm3d, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
  isend(i) = nhalo
  irecv(i) = ng(i) - nhalo
  call mpi_type_create_subarray( 3, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 3, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f(1,1,1), 1, tsend, prev, 1, f(1,1,1), 1, trecv, next, 1, comm3d, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
end if
end do
end subroutine

! Vector swap halo
subroutine vectorswaphalo( f, nhalo )
real, intent(inout) :: f(:,:,:,:)
integer, intent(in) :: nhalo
integer :: i, e, prev, next, ng(4), nl(4), isend(4), irecv(4), tsend, trecv
ng = (/ size(f,1), size(f,2), size(f,3), size(f,4) /)
do i = 1, 3
if ( ng(i) > 1 ) then
  call mpi_cart_shift( comm3d, i-1, 1, prev, next, e )
  nl = ng
  nl(i) = nhalo
  isend = 0
  irecv = 0
  isend(i) = ng(i) - 2 * nhalo
  call mpi_type_create_subarray( 4, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 4, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f(1,1,1,1), 1, tsend, next, 0, f(1,1,1,1), 1, trecv, prev, 0, comm3d, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
  isend(i) = nhalo
  irecv(i) = ng(i) - nhalo
  call mpi_type_create_subarray( 4, ng, nl, isend, mpi_order_fortran, mpi_real, tsend, e )
  call mpi_type_create_subarray( 4, ng, nl, irecv, mpi_order_fortran, mpi_real, trecv, e )
  call mpi_type_commit( tsend, e )
  call mpi_type_commit( trecv, e )
  call mpi_sendrecv( f(1,1,1,1), 1, tsend, prev, 1, f(1,1,1,1), 1, trecv, next, 1, comm3d, mpi_status_ignore, e )
  call mpi_type_free( tsend, e )
  call mpi_type_free( trecv, e )
end if
end do
end subroutine

end module

