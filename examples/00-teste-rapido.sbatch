#!/bin/bash
# =============================================================================
# 00-teste-rapido.sbatch — Teste rápido / Quick test
#
# PT: Job mínimo na partição "teste" (máx. 30 min). Use para conferir se o
#     script, os módulos e os caminhos funcionam antes da execução real.
# EN: Minimal job in the "teste" partition (max 30 min). Use it to check that
#     your script, modules and paths work before the real run.
#
# Uso / Usage:  sbatch 00-teste-rapido.sbatch
# =============================================================================
#SBATCH --job-name=teste-rapido
#SBATCH --partition=teste
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:05:00
#SBATCH --output=%x-%j.out

echo "Job ${SLURM_JOB_ID} no nó / on node: $(hostname)"
echo "CPUs: ${SLURM_CPUS_PER_TASK}  |  Diretório / Directory: $(pwd)"
echo "Início / Start: $(date)"

# PT: Carrega o Spack (jobs não executam o script de login).
# EN: Load Spack (jobs don't run the login script).
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load python@3.13.2
python3 --version

echo "Fim / End: $(date)"
