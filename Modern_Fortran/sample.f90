subroutine func()
  implicit none

  integer, save :: m = 10
  print *, m
  m = m + 1
end subroutine func

program main
  implicit none

  integer :: i

  do i = 1 , 3
    call func()
  end do
end program main
