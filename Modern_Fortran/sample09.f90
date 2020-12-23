program sample09
  !$use omp_lib
  implicit none
  integer, parameter :: N = 100
  integer :: i
  integer :: sum = 0.0
  !$omp parallel do reduction(+:sum) private(i)
    do i = 1, N
      sum = sum + i
    end do
  !$omp end parallel do

  print *, 'sum = ', sum
end program sample09
