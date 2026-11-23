#!/bin/bash
# =============================================================================
# 05-python-venv.sbatch — Python com ambiente virtual / Python with a virtualenv
#
# PT: Crie o ambiente UMA VEZ no nó de login e reutilize nos jobs.
# EN: Create the environment ONCE on the login node and reuse it in jobs.
#
# Preparação / Setup (uma vez / once):
#   source /mnt/storage/apps/spack/share/spack/setup-env.sh
#   spack load python@3.13.2
#   python3 -m venv $HOME/venvs/meu-projeto
#   source $HOME/venvs/meu-projeto/bin/activate
#   pip install --upgrade pip
#   pip install numpy pandas scipy
#
# Uso / Usage:  sbatch 05-python-venv.sbatch
# =============================================================================
#SBATCH --job-name=python
#SBATCH --partition=par128-curta
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --output=%x-%j.out

source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load python@3.13.2
source "$HOME/venvs/meu-projeto/bin/activate"

# PT: Para no primeiro erro. / EN: Stop on the first error.
set -eo pipefail

cd "$SLURM_SUBMIT_DIR"
srun python3 meu_script.py
