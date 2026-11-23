#!/bin/bash
# =============================================================================
# 01-serial.sbatch — Programa serial (1 CPU) / Serial program (1 CPU)
#
# PT: Para programas que usam um único núcleo. Ajuste --mem: o padrão é só
#     2 GB por CPU.
# EN: For programs that use a single core. Adjust --mem: the default is only
#     2 GB per CPU.
#
# Uso / Usage:  sbatch 01-serial.sbatch
# =============================================================================
#SBATCH --job-name=serial
#SBATCH --partition=par128-curta      # até/up to 12 h
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=02:00:00
#SBATCH --output=%x-%j.out

source /mnt/storage/apps/spack/share/spack/setup-env.sh
# spack load <pacote/package>         # PT: carregue o que precisar / EN: load what you need

# PT: Para no primeiro erro. / EN: Stop on the first error.
set -eo pipefail

cd "$SLURM_SUBMIT_DIR"                # PT: diretório de onde você rodou sbatch / EN: where you ran sbatch

srun ./meu_programa entrada.txt > saida.txt
