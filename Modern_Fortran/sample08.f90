program sample08
  !$use omp_lib
  implicit none
  integer, parameter :: N = 100
  integer :: i
  integer, dimension(N) :: a
  !$omp parallel
  !$omp do
    do i = 1, N
      a(i) = i
    end do
  !$omp end do
  !$omp end parallel
  print *, 'sum(a) = ', sum(a)
end program sample08
