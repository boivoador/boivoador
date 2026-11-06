# Acesso e login

[← Início](../../README.md) · 🇬🇧 [English](../en/01-access.md)

## Conta

As contas são criadas pela administração do cluster. Para solicitar uma, escreva para **hpc.propesqi@ufpe.br**.

O login segue o padrão `nome.sobrenome` (UFPE-ID). Logins antigos, com hífen ou sem ponto, podem não funcionar mais.

## Primeiro acesso

O único ponto de entrada é o nó de login **`boivoador0`** (`150.161.151.10`):

```bash
ssh nome.sobrenome@boivoador0
# ou, se o nome não resolver na sua rede:
ssh nome.sobrenome@150.161.151.10
```

Use a senha temporária que você recebeu. Se o sistema pedir a troca, siga o prompt; se não pedir, troque assim que entrar:

```bash
passwd
```

Regras de senha: no mínimo **10 caracteres**, e as **3 últimas senhas** não podem ser reutilizadas.

Se a conexão travar ou fechar durante a troca de senha, force a autenticação interativa:

```bash
ssh -o PreferredAuthentications=keyboard-interactive nome.sobrenome@boivoador0
```

Esqueceu a senha? Peça um reset à administração.

## Para que serve o nó de login

O `boivoador0` serve para **editar arquivos, compilar coisas pequenas, transferir dados e submeter jobs**. Ele **não** é lugar para rodar cálculos:

- Processos no nó de login têm limite de tempo de CPU (cerca de 20 minutos por processo) e de memória. Processos pesados são interrompidos.
- Toda execução deve passar pelo Slurm (`sbatch` ou `srun`). Veja [Slurm](03-slurm.md).
- Não acesse os nós de computação por SSH diretamente. Use `srun --pty bash` para uma sessão interativa.

## Sem sudo

Usuários não têm `sudo` nem podem usar `apt`. Para instalar software, use a sua home (por exemplo, um ambiente virtual Python ou conda) ou peça a instalação à administração. Veja [Software](05-software.md).

## Pedindo ajuda

Escreva para **hpc.propesqi@ufpe.br** e inclua:

- seu login e o nó onde ocorreu o problema (`hostname`);
- o JOBID e a partição, se envolver um job;
- o comando executado e a mensagem de erro completa;
- a data e o horário aproximados.
