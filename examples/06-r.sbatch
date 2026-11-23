#!/bin/bash
# =============================================================================
# 06-r.sbatch — Script R / R script
#
# PT: R 4.5.0 do Spack. Pacotes extras instalados com install.packages()
#     ficam na sua biblioteca pessoal em $HOME (instale no nó de login antes).
# EN: R 4.5.0 from Spack. Extra packages installed with install.packages()
#     go to your personal library in $HOME (install them on the login node first).
#
# Uso / Usage:  sbatch 06-r.sbatch
# =============================================================================
#SBATCH --job-name=r
#SBATCH --partition=par128-curta
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=%x-%j.out

source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load r@4.5.0

# PT: Para pacotes paralelos (parallel, future), use este valor como nº de workers.
# EN: For parallel packages (parallel, future), use this as the number of workers.
export R_NCORES=${SLURM_CPUS_PER_TASK}

# PT: Para no primeiro erro. / EN: Stop on the first error.
set -eo pipefail

cd "$SLURM_SUBMIT_DIR"
srun Rscript meu_script.R
