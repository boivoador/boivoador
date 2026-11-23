#!/bin/bash
# =============================================================================
# 02-mpi-1no.sbatch — MPI em um único nó / MPI on a single node
#
# PT: MPI entre vários nós não está habilitado: o job deve usar --nodes=1
#     (até 128 CPUs). boivoador1-6 têm 128 CPUs (64 núcleos físicos) e ~2 TB de RAM.
# EN: MPI across several nodes is not enabled: the job must use --nodes=1
#     (up to 128 CPUs). boivoador1-6 have 128 CPUs (64 physical cores) and ~2 TB RAM.
#
# Compilar / Build:
#   source /mnt/storage/apps/spack/share/spack/setup-env.sh
#   spack load openmpi@5.0.7
#   mpicc -O2 -o meu_programa_mpi meu_programa_mpi.c
#
# Uso / Usage:  sbatch 02-mpi-1no.sbatch
# =============================================================================
#SBATCH --job-name=mpi-1no
#SBATCH --partition=par128-longa      # até/up to 72 h
#SBATCH --nodes=1
#SBATCH --ntasks=64                   # PT: processos MPI / EN: MPI ranks
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=2-00:00:00
#SBATCH --output=%x-%j.out

source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load openmpi@5.0.7

# PT: Para no primeiro erro. / EN: Stop on the first error.
set -eo pipefail

cd "$SLURM_SUBMIT_DIR"

# PT: O mpirun do OpenMPI lê a alocação do Slurm automaticamente.
# EN: OpenMPI's mpirun reads the Slurm allocation automatically.
mpirun -np "${SLURM_NTASKS}" ./meu_programa_mpi
