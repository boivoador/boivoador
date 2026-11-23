# Perguntas frequentes

[← Início](../../README.md) · 🇬🇧 [English](../en/06-faq.md)

- [Acesso e login](#acesso-e-login)
- [Jobs no Slurm](#jobs-no-slurm)
- [GPU](#gpu)
- [Arquivos e software](#arquivos-e-software)

## Acesso e login

### Como faço o primeiro acesso?

Conecte com seu login e a senha temporária que você recebeu:

```bash
ssh <seu.login>@boivoador0
```

Se o sistema pedir a troca de senha, siga o prompt. Se não pedir, troque a senha assim que entrar, com o comando `passwd`.

### A conexão trava ou fecha durante a troca de senha. O que faço?

Force a autenticação interativa, que é o modo compatível com a troca obrigatória de senha:

```bash
ssh -o PreferredAuthentications=keyboard-interactive <seu.login>@boivoador0
```

Se o problema continuar, peça ajuda à administração.

### Minha senha não funciona. E agora?

Primeiro confira o login, que normalmente segue o formato `nome.sobrenome`. Logins antigos, com hífen ou sem ponto, podem não valer mais. Se o login estiver certo ou você tiver esquecido a senha, peça um reset à administração.

### Entrei, mas minha home está vazia ou parece antiga. Perdi meus arquivos?

Provavelmente não. Rode os comandos abaixo e envie a saída para a administração:

```bash
hostname
echo $HOME
getent passwd $USER
```

O caminho esperado é `/mnt/storage/home/<CENTRO>/<seu.login>`.

### O login demora ou trava depois da mensagem de boas-vindas. Por quê?

O login carrega o Spack a partir do armazenamento compartilhado, o que pode demorar quando ele está sobrecarregado. Se a resposta for lenta demais, o login mostra um aviso e segue sem carregar o Spack. Nesse caso, abra outra sessão mais tarde ou carregue-o manualmente com `source /mnt/storage/apps/spack/share/spack/setup-env.sh`. Se o login ficar parado por vários minutos, avise a administração e informe o nó.

### Meu programa foi interrompido no nó de login. Por quê?

O nó de login tem limite de tempo de CPU e de memória por processo. Ele serve para editar, compilar coisas pequenas e submeter jobs. Rode cálculos pelo Slurm.

## Jobs no Slurm

### Como submeto um job?

Crie um arquivo `job.sbatch`:

```bash
#!/bin/bash
#SBATCH --job-name=meu-job
#SBATCH --partition=par128-curta
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=%x-%j.out
srun ./meu_programa
```

Depois use estes comandos:

```bash
sbatch job.sbatch     # submete o job
squeue --me           # lista seus jobs
scancel <JOBID>       # cancela um job
```

Para uma sessão interativa de teste:

```bash
srun -p teste --cpus-per-task=2 --mem=4G --time=00:20:00 --pty bash
```

Mais modelos em [`examples/`](../../examples/README.md).

### Qual partição devo escolher?

Escolha a de menor tempo máximo que comporte seu job. Use `teste` para validar o script antes de uma execução longa. As partições `par128-*` e `teste` usam os mesmos nós, e só o limite de tempo muda. Veja a [tabela de partições](03-slurm.md#partições).

### Por que meu job está em PENDING se há nós livres?

Um nó com CPUs livres pode não ter memória suficiente para o seu pedido. Veja o motivo da espera:

```bash
squeue -j <JOBID> -o "%i %T %R"
```

`Resources` indica que faltam recursos livres, e `Priority` indica que outros jobs estão à frente. Se o pedido for maior do que o necessário, reduza `--mem`, `--cpus-per-task` ou `--time` para facilitar o agendamento.

### Existe limite de jobs por usuário?

Não há limite de quantidade de jobs por usuário. Cada job pode usar até 128 CPUs por nó nas partições `par128-*` e `teste`. Assim, `boivoador7` e `boivoador8` podem receber dois jobs de 128 CPUs ao mesmo tempo.

### Quanta memória meu job recebe se eu não usar `--mem`?

Ele recebe 2.000 MB por CPU nas partições de CPU e 85.000 MB por GPU na partição `gpu`. Esse é só o padrão: você pode pedir mais com `--mem` ou `--mem-per-cpu`. Pedidos acima de ~504 GB em um nó só cabem em `boivoador1–6`.

### Meu job terminou de repente. Como descubro o motivo?

Consulte o estado final do job e o arquivo de saída:

```bash
sacct -j <JOBID> --format=JobID,State,ExitCode,Elapsed,ReqMem,MaxRSS
```

| Estado | O que significa | O que fazer |
|---|---|---|
| `OUT_OF_MEMORY` | O job passou da memória pedida | Aumente `--mem` ou `--mem-per-cpu` |
| `TIMEOUT` | O job atingiu o limite de tempo | Aumente `--time`, troque de partição ou salve checkpoints |
| `FAILED` | O programa terminou com erro | Veja o arquivo de saída e o `ExitCode` |
| `NODE_FAIL` | O nó falhou durante a execução | Submeta o job novamente e avise a administração se repetir |

### Meu job falhou com `Illegal instruction`. O que é isso?

O job provavelmente rodou em `boivoador7` ou `boivoador8`, que não têm instruções AVX-512, com um programa compilado para elas (como os pacotes do Spack). Adicione `#SBATCH --exclude=boivoador[7-8]` ou recompile sem AVX-512. Veja [Hardware](02-hardware.md#boivoador7-e-boivoador8-não-têm-avx-512).

### Meu `srun` parou ao fechar o terminal ou usar `&`. Por quê?

O `srun` depende da sessão de onde foi iniciado. Em segundo plano, ele também pode ficar parado esperando o terminal. Use `sbatch` para qualquer execução longa ou que precise continuar depois que você sair.

### O que significa "Invalid account or account/partition combination"?

Seu usuário provavelmente não tem acesso àquela partição. Peça a liberação à administração, informando seu login e a partição.

### Como vejo se um nó está indisponível?

Use `sinfo`. Nós em estado `down` ou `drain` não recebem novos jobs, e o Slurm usa os demais automaticamente.

### Posso rodar MPI em vários nós?

Não. MPI entre vários nós não está habilitado no cluster. Jobs MPI devem rodar em um único nó (`--nodes=1`), com até 128 CPUs. Veja [`examples/02-mpi-1no.sbatch`](../../examples/02-mpi-1no.sbatch).

## GPU

### Como peço uma GPU?

Use a partição `gpu` e informe a quantidade com `--gres`, de 1 a 3:

```bash
#!/bin/bash
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --time=04:00:00
srun ./meu_programa
```

Sem `--gres`, o job não recebe GPU, mesmo estando na partição `gpu`.

### Por que o `nvidia-smi` não funciona ou mostra só uma GPU?

O nó de login não tem GPU, e cada job só deve usar as GPUs que pediu. Para testar, rode o comando dentro de um job:

```bash
srun -p gpu --gres=gpu:1 --time=00:05:00 nvidia-smi
```

### Quanta memória meu job de GPU recebe?

Cada GPU tem 46 GB de VRAM. A RAM padrão é de 85.000 MB por GPU pedida, e `--mem` controla apenas a RAM, não a VRAM. Se precisar de mais RAM, peça com `--mem`, respeitando o total de ~251 GB do nó.

### Por que meu job de GPU está na fila?

A partição tem um único nó, com 3 GPUs e 64 CPUs compartilhadas. Veja o que está em uso com `squeue -p gpu`. Pedir menos GPUs, CPUs, memória ou tempo pode reduzir a espera. O limite de tempo é de 24 h.

### Como uso CUDA, PyTorch ou TensorFlow?

Não há módulo de CUDA. Instale o framework com `pip` num ambiente virtual: os pacotes já trazem as bibliotecas CUDA. Veja [Software → CUDA](05-software.md#cuda).

## Arquivos e software

### Meus arquivos ficam disponíveis em todos os nós?

Sim. As homes ficam em `/mnt/storage`, compartilhado por NFS. Nos scripts, use `$HOME` em vez de escrever o caminho completo, porque ele inclui o centro e pode mudar.

### Meus dados têm backup?

**Não.** Mantenha sempre uma cópia dos seus dados importantes fora do cluster. Veja [Armazenamento](04-armazenamento.md#não-há-backup).

### Como copio muitos dados sem atrapalhar os outros usuários?

Use `rsync` com limite de banda, pois ele também permite retomar uma cópia interrompida:

```bash
rsync -ah --partial --bwlimit=100M dados/ <seu.login>@boivoador0:~/dados/
```

Combine com a administração antes de mover vários terabytes. Uma única cópia grande pode deixar o armazenamento lento para todo o cluster.

### Meu software funciona no terminal, mas não no `sbatch`. Por quê?

Jobs em lote não executam o script de login que carrega o Spack. Carregue o ambiente dentro do próprio script:

```bash
source /mnt/storage/apps/spack/share/spack/setup-env.sh
spack load <pacote>
```

### Posso usar `sudo` ou `apt` para instalar um programa?

Não, o `sudo` é restrito à administração. Instale o programa na sua home, por exemplo em um ambiente Python, ou peça a instalação à administração.

## Ainda precisa de ajuda?

Escreva para **hpc.propesqi@ufpe.br** e inclua:

- seu login e o nó onde ocorreu o problema (`hostname`);
- o JOBID e a partição, se envolver um job;
- o comando executado e a mensagem de erro completa;
- a data e o horário aproximados do problema.
