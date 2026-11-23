# Slurm

[← Home](../../README.md) · 🇧🇷 [Português](../pt/03-slurm.md)

All work on Boi Voador goes through the **Slurm** scheduler (version 24.05). You describe what you need (CPUs, memory, time, GPUs) and Slurm finds a free node.

## Partitions

| Partition | Nodes | Max time | Default memory | Use |
|---|---|---|---|---|
| `teste` | `boivoador[1-8]` | 30 min | 2,000 MB per CPU | Validate scripts before a real run |
| `par128-curta` | `boivoador[1-8]` | 12 h | 2,000 MB per CPU | **Default** (used if you don't pick one) |
| `par128-media` | `boivoador[1-8]` | 24 h | 2,000 MB per CPU | Jobs up to 1 day |
| `par128-longa` | `boivoador[1-8]` | 72 h | 2,000 MB per CPU | Jobs up to 3 days |
| `gpu` | `boivoador9` | 24 h | 85,000 MB per GPU | GPU jobs |

`teste` and `par128-*` use the same nodes; only the time limit differs. **Pick the shortest partition that fits your job**: shorter jobs get scheduled more easily.

## Limits and policies

- **At most 128 CPUs per node per job** in `teste` and `par128-*`. The 256-CPU nodes (`boivoador7–8`) can run two 128-CPU jobs at the same time.
- **MPI across several nodes is not enabled:** MPI jobs must use a single node (`--nodes=1`). See [`examples/02-mpi-1no.sbatch`](../../examples/02-mpi-1no.sbatch).
- **No limit on the number of jobs** per user.
- **Priority:** fairshare (whoever used less recently gets higher priority, with a 7-day half-life), with a slight preference for smaller jobs. No preemption: a running job is never interrupted by another.
- **Resources aren't oversubscribed**: the CPUs and memory a job requests are reserved for it.
- **Job arrays:** up to 1,001 tasks per array (`--array=0-1000`).
- **Local disk:** `--tmp` is not available.

## Memory

Memory is reserved just like CPUs. Without `--mem` you get **2,000 MB per CPU** (or 85,000 MB per GPU in the `gpu` partition).

Common pitfalls:

- A 1-CPU job without `--mem` has only **2 GB**. If the program uses more, it ends with `OUT_OF_MEMORY`.
- A 128-CPU job without `--mem` reserves **256 GB**, even if it uses far less — and may wait for a node with that much free memory.
- Requests above **~504 GB** on one node only fit on `boivoador1–6` (~2 TB each).
- `--mem=0` reserves **the whole node's memory**. Use it only when you really need it.

To see how much your job actually used, check `MaxRSS` in `sacct` (below) and adjust your next requests.

## GPU

Use the `gpu` partition and request GPUs with `--gres=gpu:N` (N from 1 to 3):

```bash
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
```

- **Without `--gres` the job gets no GPU**, even in the `gpu` partition.
- Use plain `gpu:N` with no type (`gpu:l40s:1` doesn't work).
- Slurm sets `CUDA_VISIBLE_DEVICES` to your job's GPUs; don't change it.
- `--mem` controls host RAM, not VRAM. Each GPU has 46 GB of VRAM; the node has ~251 GB RAM and 64 CPUs, shared between jobs.
- The login node has no GPU: run `nvidia-smi` inside a job.

See [`examples/04-gpu.sbatch`](../../examples/04-gpu.sbatch).

## Essential commands

```bash
sbatch job.sbatch            # submit a script
srun -p teste --cpus-per-task=2 --mem=4G --time=00:20:00 --pty bash   # interactive session
squeue --me                  # your queued/running jobs
squeue -j <JOBID> -o "%i %T %R"   # state and pending reason
scancel <JOBID>              # cancel a job
scancel --me                 # cancel all your jobs
sinfo                        # partition and node state
scontrol show job <JOBID>    # job details
scontrol show node boivoador9     # node details
sacct -j <JOBID> --format=JobID,JobName,State,ExitCode,Elapsed,ReqMem,MaxRSS   # history
```

## Job states

| State | Meaning | What to do |
|---|---|---|
| `PENDING` (`Resources`) | Not enough free resources | Wait, or reduce `--mem`, `--cpus-per-task` or `--time` |
| `PENDING` (`Priority`) | Other jobs are ahead | Wait |
| `OUT_OF_MEMORY` | Exceeded the requested memory | Increase `--mem` or `--mem-per-cpu` |
| `TIMEOUT` | Hit the time limit | Increase `--time`, change partition or use checkpoints |
| `FAILED` | The program exited with an error | Check the output file and `ExitCode` |
| `NODE_FAIL` | The node failed during the run | Resubmit; tell the admins if it repeats |

## Common errors

- **`Invalid account or account/partition combination`** — your user has no access to that partition. Ask the admins, giving your login and the partition.
- **`Illegal instruction`** — the job landed on `boivoador7` or `boivoador8` with an AVX-512 program. Use `--exclude=boivoador[7-8]`. See [Hardware](02-hardware.md#boivoador7-and-boivoador8-have-no-avx-512).
- **`srun` stopped when I closed the terminal** — `srun` is tied to your session. For long runs, use `sbatch`.
- **Works in the terminal but not under `sbatch`** — the login script doesn't run inside jobs. Load Spack in the script. See [Software](05-software.md#using-spack-inside-a-job).

Ready-made examples: [`examples/`](../../examples/README.md).
