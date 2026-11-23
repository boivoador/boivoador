# Sessões interativas / Interactive sessions

[← Exemplos / Examples](README.md)

🇧🇷 Para trabalhar diretamente num nó de computação (testar, depurar, compilar algo pesado), peça uma sessão interativa. **Não use SSH para os nós.** A sessão termina quando você sai do shell (`exit`) ou o tempo acaba.

🇬🇧 To work directly on a compute node (testing, debugging, a heavy build), request an interactive session. **Don't SSH into nodes.** The session ends when you leave the shell (`exit`) or time runs out.

```bash
# PT: shell rápido para testes (máx. 30 min)
# EN: quick test shell (max 30 min)
srun -p teste --cpus-per-task=2 --mem=4G --time=00:20:00 --pty bash

# PT: sessão maior, 16 CPUs e 64 GB por 4 h
# EN: bigger session, 16 CPUs and 64 GB for 4 h
srun -p par128-curta --cpus-per-task=16 --mem=64G --time=04:00:00 --pty bash

# PT: num nó específico
# EN: on a specific node
srun -p par128-curta -w boivoador7 --cpus-per-task=32 --mem=32G --time=01:00:00 --pty bash

# PT: com 1 GPU (máx. 24 h) — teste rápido do nvidia-smi
# EN: with 1 GPU (max 24 h) — quick nvidia-smi check
srun -p gpu --gres=gpu:1 --time=00:05:00 nvidia-smi
srun -p gpu --gres=gpu:1 --cpus-per-task=8 --time=01:00:00 --pty bash
```

🇧🇷 Dentro da sessão, o Spack é carregado como no login. Se não for, rode `source /mnt/storage/apps/spack/share/spack/setup-env.sh`.

🇬🇧 Inside the session, Spack loads as it does at login. If it doesn't, run `source /mnt/storage/apps/spack/share/spack/setup-env.sh`.

🇧🇷 **Libere os recursos** assim que terminar (`exit`): enquanto a sessão está aberta, as CPUs, a memória e a GPU ficam reservadas para você.

🇬🇧 **Release the resources** as soon as you're done (`exit`): while the session is open, its CPUs, memory and GPU stay reserved for you.
