#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=riechers-exclusive
#SBATCH --time=00:45:00
#SBATCH --mail-type=ALL
#SBATCH --no-requeue

#! Enter the script to run here
module load singularity
singularity exec casa.sif casa -c casa_script.py