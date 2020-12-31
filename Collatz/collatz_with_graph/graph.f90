module graph_m
  use constants_m
  implicit none
  private
  public :: graph__line, graph__line_with_num

contains

  function int_to_str10( i )
    integer(DI), intent(in) :: i
    character(len=10) :: int_to_str10
  !
  ! Converts the input integer into 10 characters.
  !    e.g., i=123456789 --> int_to_str10=" 123456789"
  !
    if ( i < 0_DI ) then
       int_to_str10 = '??????????'
    else if ( i > 9999999999_DI ) then
       int_to_str10 = 'XXXXXXXXXX'
    else
       write(int_to_str10,'(i10)') i
    end if

  end function int_to_str10


  subroutine graph__line( k )
    integer(DI), intent(in) :: k

    print *, repeat( '#', k )
  end subroutine graph__line


  subroutine graph__line_with_num( k )
    integer(DI), intent(in) :: k
    character(len=10) :: str10

    print *, int_to_str10( k ), ' ', repeat( '#', k )
  end subroutine graph__line_with_num

end module graph_m
