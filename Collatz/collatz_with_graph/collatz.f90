program collatz
  use constants_m
  use graph_m
  implicit none

  integer(DI) :: n = 12

  ! print *, " n = ", n

  call graph__line_with_num( n )

  do while ( n > 1 ) 
    if ( mod( n, 2) == 0 ) then
      n = n / 2
    else
      n = 3 * n + 1
    end if
    ! print *, " n = ", n
    call graph__line_with_num( n )
    ! sleep(1;
  end do

end program collatz
