# Scripts de exemplo / Example scripts

[← Início / Home](../README.md)

> ⚠️ **PT:** Estes scripts foram escritos a partir da configuração atual do cluster, mas ainda **não foram testados no Boi Voador**. Se algo não funcionar, avise em hpc.propesqi@ufpe.br.
>
> ⚠️ **EN:** These scripts follow the cluster's current configuration but have **not yet been tested on Boi Voador**. If something doesn't work, please email hpc.propesqi@ufpe.br.

## 🇧🇷 Como usar

1. Copie o script para o cluster. No nó de login:
   ```bash
   curl -O https://raw.githubusercontent.com/boivoador/boivoador/main/examples/01-serial.sbatch
   ```
2. Edite: nome do programa, `--cpus-per-task`, `--mem`, `--time` e a partição.
3. Teste antes em `teste` (troque `--partition=teste` e `--time=00:10:00`).
4. Submeta com `sbatch arquivo.sbatch` e acompanhe com `squeue --me`.

## 🇬🇧 How to use

1. Copy the script to the cluster. On the login node:
   ```bash
   curl -O https://raw.githubusercontent.com/boivoador/boivoador/main/examples/01-serial.sbatch
   ```
2. Edit it: program name, `--cpus-per-task`, `--mem`, `--time` and partition.
3. Test first in `teste` (set `--partition=teste` and `--time=00:10:00`).
4. Submit with `sbatch file.sbatch` and watch it with `squeue --me`.

## Índice / Index

| Script | 🇧🇷 Uso | 🇬🇧 Use |
|---|---|---|
| [`00-teste-rapido.sbatch`](00-teste-rapido.sbatch) | Teste mínimo na partição `teste` | Minimal test in the `teste` partition |
| [`01-serial.sbatch`](01-serial.sbatch) | Programa serial (1 CPU) | Serial program (1 CPU) |
| [`02-mpi-1no.sbatch`](02-mpi-1no.sbatch) | MPI em um único nó | MPI on a single node |
| [`03-job-array.sbatch`](03-job-array.sbatch) | Muitas execuções independentes | Many independent runs |
| [`04-gpu.sbatch`](04-gpu.sbatch) | GPU (L40S) com PyTorch | GPU (L40S) with PyTorch |
| [`05-python-venv.sbatch`](05-python-venv.sbatch) | Python com ambiente virtual | Python with a virtual environment |
| [`06-r.sbatch`](06-r.sbatch) | Script R | R script |
| [`07-avx512.sbatch`](07-avx512.sbatch) | Evitar nós sem AVX-512 (`boivoador7–8`) | Avoid nodes without AVX-512 (`boivoador7–8`) |
| [`interativo.md`](interativo.md) | Sessões interativas com `srun` | Interactive sessions with `srun` |

## Lembretes / Reminders

| 🇧🇷 | 🇬🇧 |
|---|---|
| Jobs não executam o login: todo script carrega o Spack com `source /mnt/storage/apps/spack/share/spack/setup-env.sh`. | Jobs don't run the login script: every script loads Spack with `source /mnt/storage/apps/spack/share/spack/setup-env.sh`. |
| Sem `--mem`, o job recebe só 2 GB por CPU. | Without `--mem`, a job gets only 2 GB per CPU. |
| Máximo de 128 CPUs por job por nó nas partições `par128-*` e `teste`. | At most 128 CPUs per job per node in `par128-*` and `teste`. |
| `%x-%j.out` = `<nome-do-job>-<jobid>.out`. | `%x-%j.out` = `<job-name>-<jobid>.out`. |

Mais detalhes / More details: [Slurm (PT)](../docs/pt/03-slurm.md) · [Slurm (EN)](../docs/en/03-slurm.md)
