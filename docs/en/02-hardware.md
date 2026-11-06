# Hardware

[← Home](../../README.md) · 🇧🇷 [Português](../pt/02-hardware.md)

## Nodes

| Node | Role | CPU | Physical cores | Slurm CPUs | RAM | GPU | Network |
|---|---|---|---|---|---|---|---|
| `boivoador0` | Login (runs no jobs) | 2× Intel Xeon Silver 4310 | 24 | – | 256 GB | – | 1 GbE |
| `boivoador1–6` | Compute (CPU) | 2× Intel Xeon Gold 6338 (Ice Lake), 2.0 GHz | 64 | 128 | ~2 TB | – | 1 GbE |
| `boivoador7–8` | Compute (CPU) | 2× Intel Xeon 6756E (Sierra Forest) | 256 | 256 | ~504 GB | – | 10 GbE |
| `boivoador9` | Compute (GPU) | 2× Intel Xeon Gold 5416S (Sapphire Rapids) | 32 | 64 | ~251 GB | 3× NVIDIA L40S (46 GB VRAM each) | 1 GbE |

**Total in Slurm:** 9 nodes, 928 physical cores, 1,344 CPUs, ~13 TiB RAM and 3 GPUs.

## Things worth knowing

### 1 Slurm CPU = 1 thread

On `boivoador1–6` and `boivoador9` hyperthreading is on: each physical core shows up as 2 CPUs. Asking for `--cpus-per-task=128` on `boivoador1` gives you all 64 physical cores of that node. `boivoador7–8` have no hyperthreading: 256 CPUs = 256 cores.

### `boivoador7` and `boivoador8` have no AVX-512

These nodes use efficiency cores (E-cores) without AVX-512 instructions. Programs built with AVX-512 — including the Spack packages, which are built for Ice Lake — may crash there with `Illegal instruction`. Since the `par128-*` partitions span `boivoador[1-8]`, your job can land on any of them. If this happens, exclude those nodes:

```bash
#SBATCH --exclude=boivoador[7-8]
```

See [`examples/07-avx512.sbatch`](../../examples/07-avx512.sbatch).

### GPUs

`boivoador9` has 3 NVIDIA L40S (Ada Lovelace architecture, compute capability 8.9, 46 GB VRAM each). The driver supports CUDA up to 13.x. See [Slurm → GPU](03-slurm.md#gpu) and [Software → CUDA](05-software.md#cuda).

### Network

The interconnect is **Ethernet only** (1 GbE on most nodes, 10 GbE on `boivoador7–8`). No InfiniBand is in use. As a result:

- **MPI across several nodes is not enabled.** MPI jobs must use a single node (up to 128 CPUs).
- Reads and writes to shared storage also go over this network (~110 MB/s per node on 1 GbE).

### Local disk

There is no local scratch space available through Slurm (`--tmp` doesn't work). All I/O goes to shared storage. See [Storage](04-storage.md).
