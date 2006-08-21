! Convert floating point binary files to ASCII
program flt2asc
implicit none
integer :: n, i, ii, iii, command_argument_count
real :: vals(255)
character(255) :: filename
n = command_argument_count()
inquire( iolength=ii ) vals(1)
do i = 1, n
  call get_command_argument( i, filename )
  open( i+6, file=filename, recl=ii, form='unformatted', access='direct', status='old' )
end do
ii = 0
loop: do
  ii = ii + 1
  do i = 1, n
    read( i+6, rec=ii, iostat=iii ) vals(i)
    if ( iii /= 0 ) exit loop
  end do
  print *, ii, vals(1:n)
end do loop
end program
