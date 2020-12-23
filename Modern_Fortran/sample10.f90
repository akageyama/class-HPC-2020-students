program sample10
  use mpi
  implicit none
  integer :: nprocs, myrank, ierr
  call mpi_init      (ierr)
  call mpi_comm_size (mpi_comm_world, nprocs, ierr )
  call mpi_comm_rank (mpi_comm_world, myrank, ierr )
  print *, "----start"
  print *, "nprocs =", nprocs, " I am ", myrank
  print *, "----end"
  call mpi_finalize (ierr)
end program sample10
