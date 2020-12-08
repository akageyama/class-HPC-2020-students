module constants_m
  implicit none
  private
  public :: SR, DR, PI

  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)
  real(DR), parameter :: PI = atan(1.0_DR)*4
  real(DR), parameter :: TWO_PI = PI*2
end module constants_m

program template04
  use constants_m
  implicit none

  print *, " SR, DR = ", SR, DR
  print *, " PI = ", PI
  print *, " TWO_PI = ", TWO_PI
end program template04
