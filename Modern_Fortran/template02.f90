program template02
  implicit none
  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)

  print *, " func(4) = ", func(4)

contains

  function func(i)
    integer, intent(in) :: i
    real(DR) :: func

    func = i*2.0_DR
  end function func

end program template02
