#!/bin/bash
#PBS -N HPC
#PBS -q uv-large
#PBS -o stdout.log
#PBS -e stderr.log
#PBS -l select=1:ncpus=24:mpiprocs=12
#PBS -l walltime=00:10:00

cd ${PBS_O_WORKDIR}

echo ----------- job starts on `date` ----------
echo
export KMP_AFFINITY=disalbed
export OMP_NUM_THREADS=2

ulimit -s unlimited

mpiexec_mpt -np 12 omplace -nt ${OMP_NUM_THREADS} ./smoke_ring ./params.namelist

echo
echo ----------- job ends on `date` ----------
