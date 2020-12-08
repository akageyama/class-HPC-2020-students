module constants_m
  implicit none

  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)
  real(DR), parameter :: PI = atan(1.0_DR)*4
  real(DR), parameter :: TWO_PI = PI*2

contains

  subroutine constants__print
    print *, " SR, DR = ", SR, DR
    print *, " PI, TWO_PI = ", PI, TWO_PI
  end subroutine constants__print

end module constants_m

program template05
  use constants_m
  implicit none

  call constants__print
end program template05
