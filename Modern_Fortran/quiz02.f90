program quiz02
  implicit none
  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)
  real(DR), parameter :: PI = atan(1.0_DR)*4

  real(DR) :: sum = 0.0

  call leibniz( sum,  1 )
  call leibniz( sum,  3 )
  call leibniz( sum,  5 )
  call leibniz( sum,  7 )
  call leibniz( sum,  9 )
  call leibniz( sum, 11 )
  call leibniz( sum, 13 )
  call leibniz( sum, 15 )

contains

  subroutine leibniz( sum, n )
    real(DR), intent(???) :: sum
    integer, intent(in) :: n

    real(DR), save :: sign = 1.0_DR
    real(DR) :: error

    sum = sum + sign / n 

    error = PI - sum*4

    print *, "sum*4 (error) = ", sum*4, '(', error, ')'

    sign = -1.0*sign
  end subroutine leibniz
  
end program quiz02
