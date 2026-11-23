# Frequently asked questions

[← Home](../../README.md) · 🇧🇷 [Português](../pt/06-faq.md)

- [Access and login](#access-and-login)
- [Slurm jobs](#slurm-jobs)
- [GPU](#gpu)
- [Files and software](#files-and-software)

## Access and login

### How do I log in for the first time?

Connect with your login and the temporary password you were given:

```bash
ssh <your.login>@boivoador0
```

If you're prompted to change the password, follow the prompt. If not, change it right after logging in with `passwd`.

### The connection hangs or drops while changing my password. What do I do?

Force interactive authentication, which is the mode that works with mandatory password changes:

```bash
ssh -o PreferredAuthentications=keyboard-interactive <your.login>@boivoador0
```

If it keeps happening, ask the admins for help.

### My password doesn't work. What now?

First check your login, which normally follows the `firstname.lastname` format. Old logins with a hyphen or without a dot may no longer be valid. If the login is right or you forgot your password, ask the admins for a reset.

### I logged in but my home is empty or looks old. Did I lose my files?

Probably not. Run the commands below and send the output to the admins:

```bash
hostname
echo $HOME
getent passwd $USER
```

The expected path is `/mnt/storage/home/<CENTRE>/<your.login>`. Don't copy your data by hand to fix it: that can create diverging copies and slow storage down for everyone.

### Login is slow or hangs after the welcome message. Why?

Login loads Spack from shared storage, which can be slow when storage is busy. If it takes too long, login prints a warning and continues without Spack. In that case, open another session later or load it by hand with `source /mnt/storage/apps/spack/share/spack/setup-env.sh`. If login sits there for several minutes, tell the admins which node it was.

### My program was killed on the login node. Why?

The login node has per-process CPU-time and memory limits. It's for editing, small compilations and submitting jobs. Run computations through Slurm.

## Slurm jobs

### How do I submit a job?

Create a file `job.sbatch`:

```bash
#!/bin/bash
#SBATCH --job-name=my-job
#SBATCH --partition=par128-curta
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=%x-%j.out
srun ./my_program
```

Then use:

```bash
sbatch job.sbatch     # submit the job
squeue --me           # list your jobs
scancel <JOBID>       # cancel a job
```

For a quick interactive session:

```bash
srun -p teste --cpus-per-task=2 --mem=4G --time=00:20:00 --pty bash
```

More templates in [`examples/`](../../examples/README.md).

### Which partition should I pick?

The one with the shortest time limit that fits your job. Use `teste` to validate the script before a long run. `par128-*` and `teste` use the same nodes; only the time limit changes. See the [partition table](03-slurm.md#partitions).

### Why is my job PENDING when there are free nodes?

A node with free CPUs may not have enough free memory for your request. Check the pending reason:

```bash
squeue -j <JOBID> -o "%i %T %R"
```

`Resources` means not enough free resources; `Priority` means other jobs are ahead. If you asked for more than you need, reduce `--mem`, `--cpus-per-task` or `--time` to make scheduling easier.

### Is there a limit on jobs per user?

There's no limit on the number of jobs per user. Each job can use up to 128 CPUs per node in `par128-*` and `teste`. So `boivoador7` and `boivoador8` can run two 128-CPU jobs at once.

### How much memory does my job get if I don't use `--mem`?

2,000 MB per CPU in the CPU partitions and 85,000 MB per GPU in `gpu`. That's only the default: ask for more with `--mem` or `--mem-per-cpu`. Requests above ~504 GB on one node only fit on `boivoador1–6`.

### My job ended suddenly. How do I find out why?

Check the job's final state and its output file:

```bash
sacct -j <JOBID> --format=JobID,State,ExitCode,Elapsed,ReqMem,MaxRSS
```

| State | Meaning | What to do |
|---|---|---|
| `OUT_OF_MEMORY` | The job exceeded the requested memory | Increase `--mem` or `--mem-per-cpu` |
| `TIMEOUT` | The job hit its time limit | Increase `--time`, change partition or save checkpoints |
| `FAILED` | The program exited with an error | Check the output file and `ExitCode` |
| `NODE_FAIL` | The node failed during the run | Resubmit and tell the admins if it repeats |

### My job failed with `Illegal instruction`. What's that?

The job probably ran on `boivoador7` or `boivoador8`, which lack AVX-512, with a program built for it (such as the Spack packages). Add `#SBATCH --exclude=boivoador[7-8]` or rebuild without AVX-512. See [Hardware](02-hardware.md#boivoador7-and-boivoador8-have-no-avx-512).

### My `srun` stopped when I closed the terminal or used `&`. Why?

`srun` is tied to the session it started from. In the background it may also stop waiting for the terminal. Use `sbatch` for anything long or that should keep running after you log out.

### What does "Invalid account or account/partition combination" mean?

Your user probably has no access to that partition. Ask the admins for access, giving your login and the partition.

### How do I see whether a node is unavailable?

Use `sinfo`. Nodes in `down` or `drain` state don't take new jobs, and Slurm uses the others automatically.

### Can I run MPI across several nodes?

No. MPI across several nodes is not enabled on the cluster. MPI jobs must run on a single node (`--nodes=1`), with up to 128 CPUs. See [`examples/02-mpi-1no.sbatch`](../../examples/02-mpi-1no.sbatch).

## GPU

### How do I request a GPU?

Use the `gpu` partition and give the count with `--gres`, from 1 to 3:

```bash
#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --time=04:00:00
srun ./my_program
```

Without `--gres` the job gets no GPU, even in the `gpu` partition.

### Why doesn't `nvidia-smi` work, or show only one GPU?

The login node has no GPU, and each job should only use the GPUs it requested. To test, run it inside a job:

```bash
srun -p gpu --gres=gpu:1 --time=00:05:00 nvidia-smi
```

### How much memory does my GPU job get?

Each GPU has 46 GB of VRAM. Default host RAM is 85,000 MB per requested GPU, and `--mem` only controls RAM, not VRAM. If you need more RAM, ask with `--mem`, within the node's ~251 GB total.

### Why is my GPU job waiting in the queue?

The partition has a single node with 3 GPUs and 64 shared CPUs. See what's in use with `squeue -p gpu`. Asking for fewer GPUs, CPUs, memory or time can shorten the wait. The time limit is 24 h.

### How do I use CUDA, PyTorch or TensorFlow?

There's no CUDA module. Install the framework with `pip` in a virtual environment: the wheels ship the CUDA libraries. See [Software → CUDA](05-software.md#cuda).

## Files and software

### Are my files available on every node?

Yes. Homes live in `/mnt/storage`, shared over NFS. In scripts, use `$HOME` instead of the full path, because it contains your centre and may change.

### Is my data backed up?

**No.** Always keep a copy of your important data outside the cluster. See [Storage](04-storage.md#there-are-no-backups).

### How do I copy lots of data without disturbing other users?

Use `rsync` with a bandwidth limit; it can also resume an interrupted copy:

```bash
rsync -ah --partial --bwlimit=100M data/ <your.login>@boivoador0:~/data/
```

Talk to the admins before moving several terabytes. A single large copy can slow storage down for the whole cluster.

### My software works in the terminal but not under `sbatch`. Why?

Batch jobs don't run the login script that loads Spack. Load the environment inside the script:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load <package>
```

### Can I use `sudo` or `apt` to install a program?

No, `sudo` is restricted to the admins. Install the program in your home, for example in a Python environment, or ask the admins to install it.

## Still need help?

Email **hpc.propesqi@ufpe.br** and include:

- your login and the node where the problem happened (`hostname`);
- the JOBID and partition, if a job is involved;
- the exact command and the full error message;
- the approximate date and time.
