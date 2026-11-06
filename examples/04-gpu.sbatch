#!/bin/bash
# =============================================================================
# 04-gpu.sbatch — Job com GPU / GPU job (NVIDIA L40S, boivoador9)
#
# PT: Partição "gpu" (máx. 24 h), 1 a 3 GPUs com --gres=gpu:N.
#     Sem --gres o job NÃO recebe GPU. --mem é RAM do nó, não VRAM (46 GB/GPU).
#     Não há módulo de CUDA: PyTorch/TensorFlow instalados via pip já trazem
#     as bibliotecas CUDA. Veja 05-python-venv.sbatch para criar o ambiente.
# EN: "gpu" partition (max 24 h), 1 to 3 GPUs with --gres=gpu:N.
#     Without --gres the job gets NO GPU. --mem is host RAM, not VRAM (46 GB/GPU).
#     There's no CUDA module: PyTorch/TensorFlow installed with pip ship the
#     CUDA libraries. See 05-python-venv.sbatch to create the environment.
#
# Preparação / Setup (uma vez / once):
#   source /mnt/storage/apps/spack/share/spack/setup-env.sh
#   spack load python@3.13.2
#   python3 -m venv $HOME/venvs/gpu
#   source $HOME/venvs/gpu/bin/activate
#   pip install torch
#
# Uso / Usage:  sbatch 04-gpu.sbatch
# =============================================================================
#SBATCH --job-name=gpu
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1                  # PT: nº de GPUs (1-3) / EN: number of GPUs (1-3)
#SBATCH --cpus-per-task=8             # PT: CPUs para alimentar a GPU / EN: CPUs to feed the GPU
#SBATCH --mem=64G
#SBATCH --time=04:00:00
#SBATCH --output=%x-%j.out

source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load python@3.13.2
source "$HOME/venvs/gpu/bin/activate"

# PT: Para no primeiro erro. / EN: Stop on the first error.
set -eo pipefail

cd "$SLURM_SUBMIT_DIR"

echo "GPUs do job / Job GPUs: ${CUDA_VISIBLE_DEVICES:-nenhuma/none}"
nvidia-smi

python3 - <<'PY'
import torch
print("CUDA disponível / available:", torch.cuda.is_available())
for i in range(torch.cuda.device_count()):
    print(i, torch.cuda.get_device_name(i))
PY

# srun python3 treino.py
