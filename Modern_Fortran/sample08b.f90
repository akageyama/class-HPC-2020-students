program sample08b
  !$use omp_lib
  implicit none
  integer, parameter :: N = 100
  integer :: i
  integer, dimension(N) :: a
  !$omp parallel do
    do i = 1, N
      a(i) = i
    end do
  !$omp end parallel do
  print *, 'sum(a) = ', sum(a)
end program sample08b
