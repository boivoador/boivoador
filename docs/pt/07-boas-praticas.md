# Boas práticas

[← Início](../../README.md) · 🇬🇧 [English](../en/07-good-practices.md)

O Boi Voador é compartilhado por dezenas de grupos de pesquisa. Estas práticas ajudam seus jobs a rodar mais rápido e evitam atrapalhar os outros.

## Antes de submeter

1. **Teste na partição `teste`** (30 min) com um caso pequeno antes de submeter a execução longa.
2. **Escolha a partição mais curta que comporte o job.** Jobs mais curtos são agendados mais facilmente.
3. **Peça só o que vai usar.** CPUs e memória reservados e não usados ficam parados para todo mundo. Veja quanto seu último job usou:
   ```bash
   sacct -j <JOBID> --format=JobID,Elapsed,TotalCPU,AllocCPUS,ReqMem,MaxRSS
   ```
4. **Informe `--time` realista**, com alguma folga. Um tempo menor ajuda o escalonador a encaixar seu job antes (backfill).

## Durante a execução

- **Nada de cálculos no nó de login.** Use `sbatch` ou `srun`.
- **Use `sbatch` para execuções longas**, não `srun` em segundo plano ou dentro de `screen`/`tmux` no login.
- **Não acesse nós de computação por SSH.** Para trabalhar interativamente, use `srun --pty bash`.
- **Salve checkpoints** em jobs longos, para poder retomar após um `TIMEOUT` ou falha.

## Paralelismo

- **MPI entre vários nós não está habilitado:** jobs MPI devem usar um único nó (`--nodes=1`, até 128 CPUs).
- Para muitas execuções independentes (parâmetros, arquivos de entrada), use **job arrays** em vez de submeter centenas de jobs manualmente. Veja [`examples/03-job-array.sbatch`](../../examples/03-job-array.sbatch).

## Armazenamento

- **Não há backup.** Mantenha cópia dos dados importantes fora do cluster.
- Apague arquivos temporários e resultados intermediários que não precisa mais.
- Evite milhares de arquivos pequenos num mesmo diretório; agrupe com `tar`.
- Combine com a administração antes de transferir vários terabytes.

## GPU

- Peça GPU apenas para código que realmente usa GPU, e só a quantidade necessária.
- O nó de GPU é um só, com 3 GPUs: libere-o assim que terminar (não deixe sessões interativas abertas sem uso).
