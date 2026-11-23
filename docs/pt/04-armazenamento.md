# Armazenamento

[← Início](../../README.md) · 🇬🇧 [English](../en/04-storage.md)

## `/mnt/storage`

Todo o armazenamento compartilhado fica em **`/mnt/storage`**, servido por NFS a partir do nó de login. O caminho é o mesmo em todos os nós: um arquivo salvo no login aparece imediatamente nos nós de computação, e vice-versa.

| Caminho | Conteúdo |
|---|---|
| `/mnt/storage/home/<CENTRO>/<login>` | Sua home (`$HOME`). `<CENTRO>` é a sua unidade, por exemplo `CIN`, `CCEN`, `CTG`, `CB`, `CAA` |
| `/mnt/storage/apps/spack` | Instalação central do Spack (somente leitura para usuários) |
| `/mnt/storage/apps/R` | Instalação central do R |

> Nos seus scripts, use **`$HOME`** em vez de escrever o caminho completo: ele inclui o centro e pode mudar.

O espaço total é de cerca de 58 TB, compartilhado por todos os usuários. Não há cota por usuário no momento, mas apague o que não precisa mais e evite guardar cópias duplicadas.

## Não há backup

⚠️ **Os dados do cluster não têm backup.** O cluster é um ambiente de processamento, não de armazenamento definitivo. Mantenha sempre uma cópia dos seus dados importantes (dados de entrada, códigos e resultados) fora do cluster, e traga os resultados de volta assim que um trabalho terminar.

## Scratch

Não há área de scratch separada nem disco local disponível para jobs. Leia e escreva os arquivos do job na sua home. Como todo I/O passa pela rede, prefira:

- poucos arquivos grandes em vez de muitos arquivos pequenos;
- escrever resultados em intervalos, não a cada iteração;
- compactar diretórios com milhares de arquivos (`tar`) antes de transferi-los.

## Transferindo dados

Do seu computador para o cluster (e o inverso trocando a ordem dos argumentos):

```bash
# arquivos ou pastas pequenas
scp -r dados/ nome.sobrenome@boivoador0:~/dados/

# grandes volumes: rsync com limite de banda; pode ser retomado se cair
rsync -ah --partial --progress --bwlimit=100M dados/ nome.sobrenome@boivoador0:~/dados/
```

- Use sempre o nó de login (`boivoador0`) para transferências.
- **Combine com a administração antes de mover vários terabytes.** Uma única cópia grande pode deixar o armazenamento lento para todo o cluster.

## Verificando seu uso

```bash
du -sh $HOME              # quanto sua home ocupa
du -sh $HOME/* | sort -h  # o que ocupa mais espaço
df -h /mnt/storage        # espaço livre no armazenamento compartilhado
```
