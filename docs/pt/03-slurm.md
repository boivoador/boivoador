# Slurm

[← Início](../../README.md) · 🇬🇧 [English](../en/03-slurm.md)

Toda execução no Boi Voador passa pelo escalonador **Slurm** (versão 24.05). Você descreve os recursos de que precisa (CPUs, memória, tempo, GPUs) e o Slurm encontra um nó livre.

## Partições

| Partição | Nós | Tempo máximo | Memória padrão | Uso |
|---|---|---|---|---|
| `teste` | `boivoador[1-8]` | 30 min | 2.000 MB por CPU | Validar scripts antes de rodar de verdade |
| `par128-curta` | `boivoador[1-8]` | 12 h | 2.000 MB por CPU | **Padrão** (usada se você não escolher) |
| `par128-media` | `boivoador[1-8]` | 24 h | 2.000 MB por CPU | Jobs de até 1 dia |
| `par128-longa` | `boivoador[1-8]` | 72 h | 2.000 MB por CPU | Jobs de até 3 dias |
| `gpu` | `boivoador9` | 24 h | 85.000 MB por GPU | Jobs que usam GPU |

As partições `teste` e `par128-*` usam os mesmos nós; só muda o limite de tempo. **Escolha a de menor tempo que comporte seu job**: jobs mais curtos são agendados com mais facilidade.

## Limites e políticas

- **Até 128 CPUs por nó por job** nas partições `teste` e `par128-*`. Nos nós de 256 CPUs (`boivoador7–8`) cabem dois jobs de 128 CPUs ao mesmo tempo.
- **MPI entre vários nós não está habilitado:** jobs MPI devem usar um único nó (`--nodes=1`). Veja [`examples/02-mpi-1no.sbatch`](../../examples/02-mpi-1no.sbatch).
- **Não há limite de número de jobs** por usuário.
- **Prioridade:** fairshare (quem usou menos recentemente tem mais prioridade, com meia-vida de 7 dias), com leve favorecimento a jobs menores. Não há preempção: um job iniciado não é interrompido por outro.
- **Os nós não são compartilhados entre recursos**: CPUs e memória pedidos por um job ficam reservados para ele.
- **Job arrays:** até 1.001 tarefas por array (`--array=0-1000`).
- **Disco local:** `--tmp` não está disponível.

## Memória

A memória é um recurso reservado, assim como as CPUs. Se você não usar `--mem`, recebe **2.000 MB por CPU** (ou 85.000 MB por GPU na partição `gpu`).

Armadilhas comuns:

- Um job com 1 CPU e sem `--mem` tem apenas **2 GB**. Se o programa usar mais, termina com `OUT_OF_MEMORY`.
- Um job com 128 CPUs e sem `--mem` reserva **256 GB**, mesmo que use muito menos — e pode ficar esperando um nó com tanta memória livre.
- Pedidos acima de **~504 GB** em um nó só cabem em `boivoador1–6` (~2 TB cada).
- `--mem=0` reserva **toda a memória do nó**. Use só quando realmente precisar.

Para descobrir quanto seu job realmente usou, veja `MaxRSS` em `sacct` (abaixo) e ajuste os próximos pedidos.

## GPU

Use a partição `gpu` e peça a quantidade de GPUs com `--gres=gpu:N` (N de 1 a 3):

```bash
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
```

- **Sem `--gres`, o job não recebe GPU**, mesmo estando na partição `gpu`.
- Use apenas `gpu:N`, sem tipo (`gpu:l40s:1` não funciona).
- O Slurm define `CUDA_VISIBLE_DEVICES` com as GPUs do seu job; não altere essa variável.
- `--mem` controla a RAM do nó, não a VRAM. Cada GPU tem 46 GB de VRAM; o nó tem ~251 GB de RAM e 64 CPUs, compartilhados entre os jobs.
- O nó de login não tem GPU: rode `nvidia-smi` dentro de um job.

Veja [`examples/04-gpu.sbatch`](../../examples/04-gpu.sbatch).

## Comandos essenciais

```bash
sbatch job.sbatch            # submete um script
srun -p teste --cpus-per-task=2 --mem=4G --time=00:20:00 --pty bash   # sessão interativa
squeue --me                  # seus jobs na fila ou rodando
squeue -j <JOBID> -o "%i %T %R"   # estado e motivo da espera
scancel <JOBID>              # cancela um job
scancel --me                 # cancela todos os seus jobs
sinfo                        # estado das partições e nós
scontrol show job <JOBID>    # detalhes de um job
scontrol show node boivoador9     # detalhes de um nó
sacct -j <JOBID> --format=JobID,JobName,State,ExitCode,Elapsed,ReqMem,MaxRSS   # histórico
```

## Estados de um job

| Estado | Significado | O que fazer |
|---|---|---|
| `PENDING` (`Resources`) | Faltam recursos livres | Aguarde, ou reduza `--mem`, `--cpus-per-task` ou `--time` |
| `PENDING` (`Priority`) | Outros jobs estão à frente | Aguarde |
| `OUT_OF_MEMORY` | Passou da memória pedida | Aumente `--mem` ou `--mem-per-cpu` |
| `TIMEOUT` | Atingiu o tempo limite | Aumente `--time`, troque de partição ou use checkpoints |
| `FAILED` | O programa terminou com erro | Veja o arquivo de saída e o `ExitCode` |
| `NODE_FAIL` | O nó falhou durante a execução | Submeta de novo; avise a administração se repetir |

## Erros comuns

- **`Invalid account or account/partition combination`** — seu usuário não tem acesso àquela partição. Peça liberação à administração, informando login e partição.
- **`Illegal instruction`** — o job caiu em `boivoador7` ou `boivoador8` com um programa AVX-512. Use `--exclude=boivoador[7-8]`. Veja [Hardware](02-hardware.md#boivoador7-e-boivoador8-não-têm-avx-512).
- **O `srun` parou ao fechar o terminal** — `srun` depende da sessão. Para execuções longas, use `sbatch`.
- **O programa funciona no terminal mas não no `sbatch`** — o script de login não roda em jobs. Carregue o Spack dentro do script. Veja [Software](05-software.md#usando-o-spack-dentro-de-um-job).

Exemplos prontos: [`examples/`](../../examples/README.md).
