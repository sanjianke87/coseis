!------------------------------------------------------------------------------!
! MPIOUTPUT

subroutine mpioutput( iz, comm )
use globals 
include 'mpif.h'

integer :: i, iz, comm, err, filetype, mtype, fh, disp = 0, fields, lsize(4), gsize(4), start(4)
character(255) :: ofile

do ic = 1, outnc(iz)
  write ( ofile, '(a,i2.2,a,i1,a,i5.5)' ) 'out/', iz, '/', ic, '/', it
  call mpi_file_set_errhandler( mpi_file_null, mpi_errors_are_fatal, err )
  call mpi_file_open( comm, ofile, mpi_mode_create + mpi_mode_wronly + mpi_mode_excl, mpi_info_null, fh, err )
  gsize(1:3) = i2outg(iz,:) - i1outg(iz,:) + 1
  lsize(1:3) = i2outl(iz,:) - i1outl(iz,:) + 1
  start(1:3) = i1outl(iz,:) - 1
  call mpi_type_create_subarray( 3, gsize, lsize, start, mpi_order_fortran, mpi_real, filetype, err )
  call mpi_type_commit( filetype, err )
  call mpi_file_set_view( fh, disp, mpi_real, filetype, 'native', mpi_info_null, err )
  gsize(1:3) = np + 2 * nhalo
  lsize(1:3) = outli2(iz,:) - outli1(iz,:) + 1
  start(1:3) = outli1(iz,:) - i1node
  gsize(4) = outnc(iz)
  lsize(4) = 1
  start(4) = ic - 1
  call mpi_type_create_subarray( 4, gsize, lsize, start, mpi_order_fortran, mpi_real, mtype, err )
  call mpi_type_commit( mtype, err )
  select case ( outvar(iz) )
  case('x'); call mpi_file_write_all( fh, x, 1, mtype, mpi_status_ignore, err )
  case('u'); call mpi_file_write_all( fh, u, 1, mtype, mpi_status_ignore, err )
  case('v'); call mpi_file_write_all( fh, v, 1, mtype, mpi_status_ignore, err )
  end select
  call mpi_type_free( mtype, err )
  call mpi_file_close( fh )
  call mpi_type_free( filetype, err )
end do

end subroutine
