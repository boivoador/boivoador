# Good practices

[← Home](../../README.md) · 🇧🇷 [Português](../pt/07-boas-praticas.md)

Boi Voador is shared by dozens of research groups. These practices make your jobs run sooner and keep you from getting in others' way.

## Before submitting

1. **Test in the `teste` partition** (30 min) with a small case before submitting the long run.
2. **Pick the shortest partition that fits the job.** Shorter jobs get scheduled more easily.
3. **Ask only for what you'll use.** Reserved but unused CPUs and memory sit idle for everyone. See what your last job actually used:
   ```bash
   sacct -j <JOBID> --format=JobID,Elapsed,TotalCPU,AllocCPUS,ReqMem,MaxRSS
   ```
4. **Give a realistic `--time`**, with some slack. A shorter time helps the scheduler fit your job in earlier (backfill).

## While running

- **No computations on the login node.** Use `sbatch` or `srun`.
- **Use `sbatch` for long runs**, not a backgrounded `srun` or one inside `screen`/`tmux` on the login node.
- **Don't SSH into compute nodes.** To work interactively, use `srun --pty bash`.
- **Save checkpoints** in long jobs so you can resume after a `TIMEOUT` or failure.

## Parallelism

- **MPI across several nodes is not enabled:** MPI jobs must use a single node (`--nodes=1`, up to 128 CPUs).
- For many independent runs (parameters, input files), use **job arrays** instead of submitting hundreds of jobs by hand. See [`examples/03-job-array.sbatch`](../../examples/03-job-array.sbatch).

## Storage

- **There are no backups.** Keep copies of important data outside the cluster.
- Delete temporary files and intermediate results you no longer need.
- Avoid thousands of small files in one directory; pack them with `tar`.
- Talk to the admins before transferring several terabytes.

## GPU

- Request a GPU only for code that actually uses it, and only as many as you need.
- There's a single GPU node with 3 GPUs: release it as soon as you're done (don't leave idle interactive sessions open).
