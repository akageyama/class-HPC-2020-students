program quiz04
  implicit none

  integer, parameter :: STRLEN_MAX = 100
  character(len=*), parameter :: MESSAGE1 = "hello,"
  character(len=*), parameter :: MESSAGE2 = "from a wonderful world."
  character(len=STRLEN_MAX) :: full_message

  full_message = "H"//MESSAGE1(2:len(MESSAGE1))//" "//MESSAGE2

  print *, "my_message = ", trim(full_message)
end program quiz04
