program quiz03_bug
  implicit none
  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)
  integer, parameter :: SI = selected_int_kind(8)
  integer, parameter :: DI = selected_int_kind(16)

  integer, parameter :: MAX = 10000000001
  real(DR), parameter :: PI = atan(1.0_DR)*4

  real(DR) :: error
  real(DR) :: sum = 0.0_DR
  integer(DI) :: i

  do i = 1, MAX, 2  ! 1, 3, 5, 7, ...
    call leibniz( sum,  i )
  end do

  error = PI - sum*4

  print *, "sum*4 (error) = ", sum*4, '(', error, ')'

contains

  subroutine leibniz( sum, n )
    real(DR), intent(inout) :: sum
    integer(DI), intent(in) :: n

    real(DR), save :: sign = 1.0_DR

    sum = sum + sign / n 

    sign = -1.0*sign
  end subroutine leibniz
  
end program quiz03_bug
