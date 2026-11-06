# Access and login

[← Home](../../README.md) · 🇧🇷 [Português](../pt/01-acesso.md)

## Account

Accounts are created by the cluster administrators. To request one, email **hpc.propesqi@ufpe.br**.

Logins follow the `firstname.lastname` pattern (UFPE-ID). Old logins with a hyphen or without a dot may no longer work.

## First login

The only entry point is the login node **`boivoador0`** (`150.161.151.10`):

```bash
ssh firstname.lastname@boivoador0
# or, if the name doesn't resolve on your network:
ssh firstname.lastname@150.161.151.10
```

Use the temporary password you were given. If you are prompted to change it, follow the prompt; otherwise change it right away:

```bash
passwd
```

Password rules: at least **10 characters**, and your **last 3 passwords** can't be reused.

If the connection hangs or drops while changing the password, force interactive authentication:

```bash
ssh -o PreferredAuthentications=keyboard-interactive firstname.lastname@boivoador0
```

Forgot your password? Ask the administrators for a reset.

## What the login node is for

`boivoador0` is for **editing files, small compilations, transferring data and submitting jobs**. It is **not** for running computations:

- Processes on the login node have a CPU-time limit (about 20 minutes per process) and a memory limit. Heavy processes get killed.
- All work must go through Slurm (`sbatch` or `srun`). See [Slurm](03-slurm.md).
- Don't SSH into compute nodes directly. Use `srun --pty bash` for an interactive session.

## No sudo

Users have no `sudo` and can't use `apt`. To install software, use your home directory (for example a Python virtual environment or conda) or ask the administrators. See [Software](05-software.md).

## Getting help

Email **hpc.propesqi@ufpe.br** and include:

- your login and the node where the problem happened (`hostname`);
- the JOBID and partition, if a job is involved;
- the exact command and the full error message;
- the approximate date and time.
