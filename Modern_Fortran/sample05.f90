program sample05
  implicit none
  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)
  real(SR) :: pi_single
  real(DR) :: pi_double

  print *, " SR, DR = ", SR, DR
  pi_single = 3.1415926_SR
  pi_double = 3.141592653589793_DR
  print *, " pi_single = ", pi_single
  print *, " pi_double = ", pi_double
end program sample05
