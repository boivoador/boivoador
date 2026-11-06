# Boi Voador — Cluster HPC da UFPE / UFPE HPC Cluster

🇧🇷 [Português](#português) · 🇬🇧 [English](#english)

---

## Português

O **Boi Voador** é o cluster de computação de alto desempenho (HPC) da UFPE, usado para pesquisa científica. O nome homenageia o folclore pernambucano do boi voador: durante a ocupação holandesa, o governador Maurício de Nassau teria prometido fazer um boi voar sobre a ponte do Recife para atrair visitantes e aumentar a arrecadação do pedágio.

### Resumo do cluster

| | |
|---|---|
| Nó de login | `boivoador0` (`150.161.151.10`) |
| Nós de computação | 9: 8 de CPU (`boivoador1–8`) e 1 de GPU (`boivoador9`) |
| Total | 928 núcleos físicos, 1.344 CPUs no Slurm, ~13 TiB de RAM, 3× NVIDIA L40S |
| Sistema operacional | Ubuntu Server 22.04 LTS |
| Escalonador | Slurm 24.05 |
| Software | Spack + Environment Modules (GCC 11.4, OpenMPI 5, Python 3.13, R 4.5, …) |
| Armazenamento | `/mnt/storage` (NFS), compartilhado por todos os nós |

### Início rápido

```bash
ssh nome.sobrenome@boivoador0            # 1. entre no nó de login
passwd                                    # 2. troque a senha temporária
curl -O https://raw.githubusercontent.com/boivoador/boivoador/main/examples/01-serial.sbatch   # 3. baixe um exemplo
nano 01-serial.sbatch                     # 4. ajuste o programa e os recursos
sbatch 01-serial.sbatch                   # 5. submeta
squeue --me                               # 6. acompanhe
```

### Documentação

| | |
|---|---|
| [Acesso e login](docs/pt/01-acesso.md) | SSH, senha, regras do nó de login |
| [Hardware](docs/pt/02-hardware.md) | Nós, CPUs, memória, GPUs, rede |
| [Slurm](docs/pt/03-slurm.md) | Partições, limites, memória, GPU, comandos |
| [Armazenamento](docs/pt/04-armazenamento.md) | Home, `/mnt/storage`, transferência de dados, backup |
| [Software](docs/pt/05-software.md) | Spack, módulos, Python, R, CUDA |
| [Perguntas frequentes](docs/pt/06-faq.md) | Problemas comuns e soluções |
| [Boas práticas](docs/pt/07-boas-praticas.md) | Como usar o cluster sem atrapalhar os outros |
| [Scripts de exemplo](examples/README.md) | Jobs prontos: serial, MPI, GPU, arrays, Python, R |

### Contato

Dúvidas, criação de conta ou suporte técnico: 📧 **hpc.propesqi@ufpe.br**

---

## English

**Boi Voador** is UFPE's high-performance computing (HPC) cluster for scientific research. It is named after the flying-ox folklore of Pernambuco: during the Dutch occupation, Governor Maurício de Nassau supposedly promised to make an ox fly over the Recife bridge to attract visitors and boost toll revenue.

### Cluster at a glance

| | |
|---|---|
| Login node | `boivoador0` (`150.161.151.10`) |
| Compute nodes | 9: 8 CPU nodes (`boivoador1–8`) and 1 GPU node (`boivoador9`) |
| Total | 928 physical cores, 1,344 Slurm CPUs, ~13 TiB RAM, 3× NVIDIA L40S |
| Operating system | Ubuntu Server 22.04 LTS |
| Scheduler | Slurm 24.05 |
| Software | Spack + Environment Modules (GCC 11.4, OpenMPI 5, Python 3.13, R 4.5, …) |
| Storage | `/mnt/storage` (NFS), shared by every node |

### Quick start

```bash
ssh firstname.lastname@boivoador0         # 1. log in
passwd                                    # 2. change your temporary password
curl -O https://raw.githubusercontent.com/boivoador/boivoador/main/examples/01-serial.sbatch   # 3. download an example
nano 01-serial.sbatch                     # 4. adjust program and resources
sbatch 01-serial.sbatch                   # 5. submit it
squeue --me                               # 6. watch it
```

### Documentation

| | |
|---|---|
| [Access and login](docs/en/01-access.md) | SSH, password, login-node rules |
| [Hardware](docs/en/02-hardware.md) | Nodes, CPUs, memory, GPUs, network |
| [Slurm](docs/en/03-slurm.md) | Partitions, limits, memory, GPU, commands |
| [Storage](docs/en/04-storage.md) | Home, `/mnt/storage`, data transfer, backups |
| [Software](docs/en/05-software.md) | Spack, modules, Python, R, CUDA |
| [FAQ](docs/en/06-faq.md) | Common problems and fixes |
| [Good practices](docs/en/07-good-practices.md) | Using the cluster without getting in others' way |
| [Example scripts](examples/README.md) | Ready-made jobs: serial, MPI, GPU, arrays, Python, R |

### Contact

Questions, account requests or technical support: 📧 **hpc.propesqi@ufpe.br**
