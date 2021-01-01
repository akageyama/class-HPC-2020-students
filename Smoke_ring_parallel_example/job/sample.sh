#!/bin/bash
#PBS -N HPC
#PBS -q uv-large
#PBS -o stdout.log
#PBS -e stderr.log
#PBS -l select=1:ncpus=24:mpiprocs=12

cd ${PBS_O_WORKDIR}

echo ----------- job starts on `date` ----------
echo
export KMP_AFFINITY=disalbed
export OMP_NUM_THREADS=2

mpiexec_mpt -np 12 omplace -nt ${OMP_NUM_THREADS} -c 0-23 ./smoke_ring ./params.namelist
echo
echo ----------- job ends on `date` ----------
