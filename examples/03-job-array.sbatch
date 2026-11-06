#!/bin/bash
# =============================================================================
# 03-job-array.sbatch — Muitas execuções independentes / Many independent runs
#
# PT: Roda o mesmo programa para vários arquivos de entrada. Cada tarefa do
#     array é um job separado, com o índice em SLURM_ARRAY_TASK_ID.
#     "%10" limita a 10 tarefas rodando ao mesmo tempo (seja gentil com a fila).
#     Máximo: 1001 tarefas por array (índices 0-1000).
# EN: Runs the same program over many input files. Each array task is a
#     separate job, with its index in SLURM_ARRAY_TASK_ID.
#     "%10" caps it at 10 tasks running at once (be nice to the queue).
#     Max: 1001 tasks per array (indices 0-1000).
#
# Preparação / Setup:
#   ls entradas/*.txt > lista.txt          # uma entrada por linha / one input per line
#   wc -l lista.txt                        # ajuste --array=1-N / set --array=1-N
#   mkdir -p logs                          # PT: obrigatório antes do sbatch / EN: required before sbatch
#
# Uso / Usage:  sbatch 03-job-array.sbatch
# =============================================================================
#SBATCH --job-name=array
#SBATCH --partition=par128-curta
#SBATCH --array=1-100%10
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=01:00:00
#SBATCH --output=logs/%x-%A_%a.out    # %A = job do array / array job, %a = índice / index

source /mnt/storage/apps/spack/share/spack/setup-env.sh
# spack load <pacote/package>

# PT: Para no primeiro erro. / EN: Stop on the first error.
set -eo pipefail

cd "$SLURM_SUBMIT_DIR"

# PT: Pega a linha N de lista.txt. / EN: Take line N of lista.txt.
ENTRADA=$(sed -n "${SLURM_ARRAY_TASK_ID}p" lista.txt)
echo "Tarefa / Task ${SLURM_ARRAY_TASK_ID}: ${ENTRADA}"

mkdir -p resultados
srun ./meu_programa "${ENTRADA}" > "resultados/$(basename "${ENTRADA}" .txt).out"
