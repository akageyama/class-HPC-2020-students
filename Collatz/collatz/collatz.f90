program collatz
  use constants_m
  implicit none

  integer(DI) :: n = 30

  print *, " n = ", n

  do while ( n > 1 ) 
    if ( mod( n, 2) == 0 ) then
      n = n / 2
    else
      n = 3 * n + 1
    end if
    print *, " n = ", n
    call sleep(1)
  end do

end program collatz
