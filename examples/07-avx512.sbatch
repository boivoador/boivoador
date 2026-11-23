#!/bin/bash
# =============================================================================
# 07-avx512.sbatch — Evitar nós sem AVX-512 / Avoid nodes without AVX-512
#
# PT: As partições par128-* e teste incluem boivoador7-8 (Xeon 6756E), que NÃO
#     têm AVX-512. Os pacotes do Spack e códigos compilados com
#     -march=native/-mavx512 em outros nós podem falhar ali com
#     "Illegal instruction". Este exemplo exclui esses nós.
#     Alternativa: compile com -march=x86-64-v3 para rodar em todos os nós.
# EN: The par128-* and teste partitions include boivoador7-8 (Xeon 6756E),
#     which have NO AVX-512. Spack packages and code built with
#     -march=native/-mavx512 elsewhere may crash there with
#     "Illegal instruction". This example excludes those nodes.
#     Alternative: build with -march=x86-64-v3 to run on every node.
#
# Uso / Usage:  sbatch 07-avx512.sbatch
# =============================================================================
#SBATCH --job-name=avx512
#SBATCH --partition=par128-media
#SBATCH --exclude=boivoador[7-8]
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --time=08:00:00
#SBATCH --output=%x-%j.out

source /mnt/storage/apps/spack/share/spack/setup-env.sh
# spack load <pacote/package>

# PT: Para no primeiro erro. / EN: Stop on the first error.
set -eo pipefail

cd "$SLURM_SUBMIT_DIR"
echo "Nó / Node: $(hostname)"
grep -q avx512f /proc/cpuinfo && echo "AVX-512: sim/yes" || echo "AVX-512: não/no"

srun ./meu_programa
