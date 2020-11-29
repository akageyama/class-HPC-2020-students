program quiz01
  implicit none
  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)
  real(DR) :: pi

  pi = 3.141592653589793238
  print *, " pi/2 = ", pi/2
end program quiz01
