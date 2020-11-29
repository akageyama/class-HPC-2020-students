program template02_bug1
  implicit none
  integer, parameter :: SR = selected_real_kind(6)
  integer, parameter :: DR = selected_real_kind(15)

  print *, " func(4) = ", func(4)

contains ! これ以降に内部副プログラムを置く

  function func(i)
    integer, intent(in) :: i
    real(DR) :: func

    i = 10
    func = i*2.0_DR
  end function func
  
end program template02_bug1
