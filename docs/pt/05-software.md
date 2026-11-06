# Software

[← Início](../../README.md) · 🇬🇧 [English](../en/05-software.md)

O software científico do cluster é instalado de forma central com o **[Spack](https://spack.io)** em `/mnt/storage/apps/spack` e disponibilizado como **módulos** (Environment Modules). A mesma instalação é vista por todos os nós.

## No terminal (sessão interativa)

Ao entrar no cluster, o Spack e os módulos são carregados automaticamente (você verá mensagens `[Cluster] Spack carregado`).

```bash
module avail                 # lista todos os módulos (~350)
module avail python          # filtra pelo nome
module load python/3.13.2-gcc-11.4.0-z6ykm2u   # carrega um módulo pelo nome completo
module list                  # módulos carregados
module purge                 # descarrega todos

spack find                   # pacotes instalados no Spack
spack find -v openmpi        # versões e variantes de um pacote
spack load python@3.13.2     # alternativa ao module load
```

Se o login avisar que o Spack está indisponível (armazenamento lento), carregue-o manualmente:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
```

## Usando o Spack dentro de um job

**Jobs em lote não executam o script de login.** Carregue o ambiente dentro do próprio script, sempre com o caminho completo:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load python@3.13.2
```

Todos os [scripts de exemplo](../../examples/README.md) fazem isso.

## O que está instalado

Todos os pacotes foram compilados com **GCC 11.4.0** para a arquitetura **Ice Lake** (com AVX-512) — veja o aviso sobre [`boivoador7–8`](02-hardware.md#boivoador7-e-boivoador8-não-têm-avx-512).

| Categoria | Pacotes (versões) |
|---|---|
| Compiladores | gcc 11.4.0 |
| MPI | openmpi 5.0.7 (com pmix 5.0.5, hwloc 2.11.1) |
| Álgebra linear e numérica | openblas 0.3.29, fftw 3.3.10, petsc 3.23.2, hypre 2.33.0, superlu-dist 9.1.0, scotch 7.0.7, metis 5.1.0, parmetis 4.0.3, gsl 2.8, eigen 3.4.0, boost 1.88.0, cgal 5.6 |
| Formatos de dados e I/O | hdf5 1.14.4-3, netcdf-c 4.9.2, netcdf-fortran 4.6.1, parallel-netcdf 1.14.0, adios2 2.10.2 |
| Geociências | gdal 3.11.0, proj 9.4.1, geos 3.13.1, esmf 8.8.1 |
| CFD | openfoam 2412 |
| Bioinformática | gatk 4.5.0.0, samtools 1.19.2, bcftools 1.21, bwa 0.7.17, blast-plus 2.16.0 |
| Python | python 3.13.2 e 3.9.21, py-numpy 2.2.6, py-matplotlib 3.10.3, py-pip 25.1.1 |
| R | r 4.5.0, com coleções de pacotes em `r/4.5.0.ext/*`: tidyverse, data-table, devtools, reports, timeseries, web, import |
| Outros | openjdk 17, cmake 3.31.6, git 2.48.1, perl 5.40.0, pandoc 2.19.2 |

A lista acima é um resumo. Use `module avail` ou `spack find` para ver tudo. Precisa de algo que não está instalado? Peça à administração.

O sistema (fora do Spack) também tem gcc 11.4.0, Python 3.10, R 4.1, cmake 3.22 e git 2.34.

## Python

Para instalar pacotes Python próprios, crie um **ambiente virtual na sua home**:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load python@3.13.2
python3 -m venv $HOME/venvs/meu-projeto
source $HOME/venvs/meu-projeto/bin/activate
pip install --upgrade pip
pip install numpy pandas    # ou o que precisar
```

Nos jobs, ative o ambiente da mesma forma. Veja [`examples/05-python-venv.sbatch`](../../examples/05-python-venv.sbatch).

Conda/Miniforge também pode ser instalado na sua home, se preferir. Evite instalar pacotes com `pip install --user` fora de um ambiente: isso mistura versões entre projetos.

## R

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load r@4.5.0
Rscript meu_script.R
```

As coleções de pacotes (tidyverse, data.table, etc.) estão nos módulos `r/4.5.0.ext/*` (`module avail r/`). Pacotes adicionais instalados com `install.packages()` vão para a sua biblioteca pessoal em `$HOME`. Veja [`examples/06-r.sbatch`](../../examples/06-r.sbatch).

## CUDA

**Não há módulo de CUDA no Spack.** O driver das GPUs suporta CUDA até 13.x. Opções:

- **PyTorch, TensorFlow, JAX:** instale com `pip` num ambiente virtual. Os pacotes oficiais já trazem as bibliotecas CUDA necessárias. Exemplo: `pip install torch`.
- **Compilar código CUDA próprio:** o `nvcc` do sistema (CUDA 11.5) existe apenas em `boivoador9`. Compile dentro de um job na partição `gpu`. Para CUDA mais recente, use o toolkit via conda (`conda install -c nvidia cuda-toolkit`) na sua home, ou peça à administração.

Lembre-se: o nó de login não tem GPU. Teste tudo dentro de um job. Veja [`examples/04-gpu.sbatch`](../../examples/04-gpu.sbatch).

## Compilando seu código

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load openmpi@5.0.7 openblas
mpicc -O2 -o meu_programa meu_programa.c -lopenblas
```

- Compile em um job (`srun -p teste ... --pty bash`) se a compilação for pesada — o nó de login tem limite de CPU.
- Para que o binário rode em **todos** os nós, inclusive `boivoador7–8`, evite `-march=native` e `-mavx512*`. Use, por exemplo, `-O2 -march=x86-64-v3` (AVX2), compatível com todos os nós de computação.
