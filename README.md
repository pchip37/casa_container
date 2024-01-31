# CASA Container

This repository contains the necessary files to build containerized environments for running different versions of [CASA](https://casadocs.readthedocs.io/en/stable/index.html).

## Container Details

- **Base Image**: Ubuntu 22.04
- **CASA Versions**: 
  - 6.4.1 (Refer to `casa_6.4.1_singularity.def`)
  - 6.2.1 (Refer to `casa_6.2.1_singularity.def`)

## Makefile Usage

The Makefile contains several targets for building and running the CASA containers:

### General

- `make all`: Build both 6.4.1 and 6.2.1 Singularity images.
- `bake xvfb` (virtual buffer) into the CASA Singularity container image (e.g. in Docker files, add the installation of xvfb) for its usage on HPC. The reason to include `xvfb` is that `CASA/plotms` on Linux needs X11 to get the plots done, w/o which it may not create all the necessary output plots as CASA pipeline result. 

### CASA Version 6.4.1

- `make casa_6.4.1.sif` or `make casa_6.4.1_with_xvfb.sif`: Build Singularity image for CASA 6.4.1 (w/o and with xvfb, respectively).

### CASA Version 6.2.1

- `make casa_6.2.1.sif` or `make casa_6.2.1_with_xvfb.sif`: Build Singularity image for CASA 6.2.1 (w/o and with xvfb, respectively).

### Downloads

- `make casa-6.4.1-12-pipeline-2022.2.0.64-py3.6.tar.xz`: Download CASA 6.4.1.
- `make casa-6.2.1-7-pipeline-2021.2.0.128.tar.xz`: Download CASA 6.2.1.

## Quick Start

1. Clone the repository.
2. Run `make all` to build both Singularity images.
3. Use the `.sif` files as needed for your CASA tasks.

## Working with Data

Singularity automatically mounts the current working directory (PWD) inside the container at the same path, allowing you to easily access and work with your local data. By default, Singularity changes to the `$HOME` directory when a container starts. To make it stay in the PWD, use the `--pwd` flag:

```bash
singularity exec --pwd $(pwd) casa_6.4.1.sif your_command
```

### Running Custom Commands

You can run any command inside the container by prefixing it with `singularity exec`:

```bash
singularity exec casa_6.4.1.sif your_command
```

### Mounting PWD to Container and Setting as Initial Working Directory

If your current working directory (PWD) is different from `$HOME`, you can use the `--bind` and `--pwd` flags together to both mount the PWD and set it as the initial working directory:

```bash
singularity exec --bind $PWD:$PWD --pwd $(pwd) casa.sif your_command
```

### Executing the CASA VLA pipeline on HPC using batch-job

The `-c` flag indicates the way to run an external script using CASA. `xvfb-run` is a typical execution command sent to HPC scheduler (i.e. SLURM) in the batch-job shell script, where `-a` can be appended if HPC uses Ubuntu as a base OS. So, the entire command now will be:

```bash
singularity exec --pwd /data --bind [PATH_DATA_DIR]:/data casa_6.4.1_with_xvfb.sif xvfb-run -a mpicasa casa --pipeline -c CASA_VLA_pipescript.py
```

#### Batch-job submisssion on CHEOPS: Example
Job allocation and utility management are done using SLURM routine on CHEOPS. When we submit a batch-job, we need to make sure that we provide the necessary requirements from our task/program's side to the CHEOPS in the form of a shell script (as shown below).

```bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --partition=riechers-exclusive
#SBATCH --mail-type=ALL
#SBATCH --no-requeue
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --mem=128GB
#SBATCH --time=0-7:00:00
#SBATCH -J casatest
#!SBATCH -o casa_vzgal_001_helms45_trial2-%j.out   # Write the standard output to file named 'jMPItest-<job_number>.out'
#!SBATCH -e casa_vzgal_001_helms45_trial2-%j.err   # Write the standard error to file named 'jMPItest-<job_number>.err'

#! Enter the script to run here (e.g. python3 helloworld.py)
```
