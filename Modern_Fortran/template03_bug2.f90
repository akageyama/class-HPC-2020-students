program template03_bug2
  implicit none
  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)

  real(DR) :: left=15.0_DR, right=0.0_DR

  print *, "[before] left, right = ", left, right 
  call double( left, right ) 
  print *, "[ after] left, right = ", left, right 

contains

  subroutine double(a, b)
    real(DR), intent(in) :: a
    real(DR), intent(out) :: b
    ! b = a*2
  end subroutine double
  
end program template03_bug2
