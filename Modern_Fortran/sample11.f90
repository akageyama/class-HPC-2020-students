program sample11
  use omp_lib
  use mpi
  implicit none
  integer :: nprocs, myrank, ierr
  call mpi_init      (ierr)
  call mpi_comm_size (mpi_comm_world, nprocs, ierr )
  call mpi_comm_rank (mpi_comm_world, myrank, ierr )
  print *, "----start"
  !$omp parallel
  print *, "my rank and thread_num =", myrank, omp_get_thread_num() 
  !$omp end parallel
  print *, "----end"
  call mpi_finalize (ierr)
end program sample11
