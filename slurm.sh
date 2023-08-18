#!/bin/bash -l
#SBATCH --cpus-per-task=4
#SBATCH --mem=1024mb
#SBATCH --time=01:00:00
#SBATCH --account=UniKoeln
module load intel/19.0
workdir=/scratch/${USER}/${SLURM_JOB_ID}
mkdir -p $workdir
cp input.dat $workdir
cd $workdir
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
program input.dat
cd -
cp ${workdir}/results.dat .