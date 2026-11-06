# Hardware

[← Início](../../README.md) · 🇬🇧 [English](../en/02-hardware.md)

## Nós

| Nó | Função | CPU | Núcleos físicos | CPUs no Slurm | RAM | GPU | Rede |
|---|---|---|---|---|---|---|---|
| `boivoador0` | Login (não roda jobs) | 2× Intel Xeon Silver 4310 | 24 | – | 256 GB | – | 1 GbE |
| `boivoador1–6` | Computação (CPU) | 2× Intel Xeon Gold 6338 (Ice Lake), 2,0 GHz | 64 | 128 | ~2 TB | – | 1 GbE |
| `boivoador7–8` | Computação (CPU) | 2× Intel Xeon 6756E (Sierra Forest) | 256 | 256 | ~504 GB | – | 10 GbE |
| `boivoador9` | Computação (GPU) | 2× Intel Xeon Gold 5416S (Sapphire Rapids) | 32 | 64 | ~251 GB | 3× NVIDIA L40S (46 GB de VRAM cada) | 1 GbE |

**Total no Slurm:** 9 nós, 928 núcleos físicos, 1.344 CPUs, ~13 TiB de RAM e 3 GPUs.

## Coisas importantes de saber

### 1 CPU no Slurm = 1 thread

Nos nós `boivoador1–6` e `boivoador9` o hyperthreading está ligado: cada núcleo físico aparece como 2 CPUs. Pedir `--cpus-per-task=128` em `boivoador1` dá a você os 64 núcleos físicos do nó. Nos nós `boivoador7–8` não há hyperthreading: 256 CPUs = 256 núcleos.

### `boivoador7` e `boivoador8` não têm AVX-512

Esses nós usam núcleos de eficiência (E-cores), sem as instruções AVX-512. Programas compilados com AVX-512 — incluindo os pacotes do Spack, compilados para Ice Lake — podem falhar nesses nós com `Illegal instruction`. Como as partições `par128-*` incluem `boivoador[1-8]`, seu job pode cair em qualquer um deles. Se isso acontecer, exclua esses nós:

```bash
#SBATCH --exclude=boivoador[7-8]
```

Veja [`examples/07-avx512.sbatch`](../../examples/07-avx512.sbatch).

### GPUs

`boivoador9` tem 3 NVIDIA L40S (arquitetura Ada Lovelace, compute capability 8.9, 46 GB de VRAM cada). O driver suporta CUDA até a versão 13.x. Veja [Slurm → GPU](03-slurm.md#gpu) e [Software → CUDA](05-software.md#cuda).

### Rede

A interconexão é **somente Ethernet** (1 GbE na maioria dos nós, 10 GbE em `boivoador7–8`). Não há InfiniBand em uso. Consequências:

- **MPI entre vários nós não está habilitado.** Jobs MPI devem usar um único nó (até 128 CPUs).
- A leitura e escrita no armazenamento compartilhado também passam por essa rede (~110 MB/s por nó em 1 GbE).

### Disco local

Não há área de scratch local disponível pelo Slurm (`--tmp` não funciona). Todo I/O vai para o armazenamento compartilhado. Veja [Armazenamento](04-armazenamento.md).
