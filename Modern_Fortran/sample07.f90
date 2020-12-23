program sample07
!$ use omp_lib
implicit none
  print *, "----start"
  !$omp parallel
  print *, "thread_num =", omp_get_num_threads(), " I am ", omp_get_thread_num()
  !$omp end parallel
  print *, "----end"
end program sample07
