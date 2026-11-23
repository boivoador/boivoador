# Software

[← Home](../../README.md) · 🇧🇷 [Português](../pt/05-software.md)

Scientific software is installed centrally with **[Spack](https://spack.io)** in `/mnt/storage/apps/spack` and exposed as **modules** (Environment Modules). Every node sees the same installation.

## In the terminal (interactive session)

When you log in, Spack and the modules are loaded automatically (you'll see `[Cluster] Spack carregado` messages).

```bash
module avail                 # list every module (~350)
module avail python          # filter by name
module load python/3.13.2-gcc-11.4.0-z6ykm2u   # load a module by its full name
module list                  # loaded modules
module purge                 # unload everything

spack find                   # packages installed in Spack
spack find -v openmpi        # versions and variants of a package
spack load python@3.13.2     # alternative to module load
```

If the login warns that Spack is unavailable (slow storage), load it by hand:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
```

## Using Spack inside a job

**Batch jobs don't run the login script.** Load the environment inside the script itself, always with the full path:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load python@3.13.2
```

All [example scripts](../../examples/README.md) do this.

## What's installed

Every package was built with **GCC 11.4.0** for the **Ice Lake** architecture (with AVX-512) — see the warning about [`boivoador7–8`](02-hardware.md#boivoador7-and-boivoador8-have-no-avx-512).

| Category | Packages (versions) |
|---|---|
| Compilers | gcc 11.4.0 |
| MPI | openmpi 5.0.7 (with pmix 5.0.5, hwloc 2.11.1) |
| Linear algebra and numerics | openblas 0.3.29, fftw 3.3.10, petsc 3.23.2, hypre 2.33.0, superlu-dist 9.1.0, scotch 7.0.7, metis 5.1.0, parmetis 4.0.3, gsl 2.8, eigen 3.4.0, boost 1.88.0, cgal 5.6 |
| Data formats and I/O | hdf5 1.14.4-3, netcdf-c 4.9.2, netcdf-fortran 4.6.1, parallel-netcdf 1.14.0, adios2 2.10.2 |
| Geosciences | gdal 3.11.0, proj 9.4.1, geos 3.13.1, esmf 8.8.1 |
| CFD | openfoam 2412 |
| Bioinformatics | gatk 4.5.0.0, samtools 1.19.2, bcftools 1.21, bwa 0.7.17, blast-plus 2.16.0 |
| Python | python 3.13.2 and 3.9.21, py-numpy 2.2.6, py-matplotlib 3.10.3, py-pip 25.1.1 |
| R | r 4.5.0, with package collections in `r/4.5.0.ext/*`: tidyverse, data-table, devtools, reports, timeseries, web, import |
| Other | openjdk 17, cmake 3.31.6, git 2.48.1, perl 5.40.0, pandoc 2.19.2 |

This is a summary. Use `module avail` or `spack find` to see everything. Need something that isn't installed? Ask the admins.

The base system (outside Spack) also has gcc 11.4.0, Python 3.10, R 4.1, cmake 3.22 and git 2.34.

## Python

To install your own Python packages, create a **virtual environment in your home**:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load python@3.13.2
python3 -m venv $HOME/venvs/my-project
source $HOME/venvs/my-project/bin/activate
pip install --upgrade pip
pip install numpy pandas    # or whatever you need
```

Activate it the same way in jobs. See [`examples/05-python-venv.sbatch`](../../examples/05-python-venv.sbatch).

You can also install Conda/Miniforge in your home if you prefer. Avoid `pip install --user` outside an environment: it mixes versions across projects.

## R

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load r@4.5.0
Rscript my_script.R
```

Package collections (tidyverse, data.table, etc.) are in the `r/4.5.0.ext/*` modules (`module avail r/`). Extra packages installed with `install.packages()` go to your personal library in `$HOME`. See [`examples/06-r.sbatch`](../../examples/06-r.sbatch).

## CUDA

**There is no CUDA module in Spack.** The GPU driver supports CUDA up to 13.x. Options:

- **PyTorch, TensorFlow, JAX:** install with `pip` in a virtual environment. The official wheels ship the CUDA libraries they need. Example: `pip install torch`.
- **Building your own CUDA code:** the system `nvcc` (CUDA 11.5) exists only on `boivoador9`. Compile inside a job in the `gpu` partition. For a newer CUDA, install the toolkit with conda (`conda install -c nvidia cuda-toolkit`) in your home, or ask the admins.

Remember: the login node has no GPU. Test everything inside a job. See [`examples/04-gpu.sbatch`](../../examples/04-gpu.sbatch).

## Compiling your code

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load openmpi@5.0.7 openblas
mpicc -O2 -o my_program my_program.c -lopenblas
```

- Compile inside a job (`srun -p teste ... --pty bash`) if the build is heavy — the login node has a CPU limit.
- For a binary that runs on **every** node, including `boivoador7–8`, avoid `-march=native` and `-mavx512*`. Use for instance `-O2 -march=x86-64-v3` (AVX2), which works on all compute nodes.
