# Storage

[← Home](../../README.md) · 🇧🇷 [Português](../pt/04-armazenamento.md)

## `/mnt/storage`

All shared storage lives in **`/mnt/storage`**, served over NFS from the login node. The path is the same on every node: a file saved on the login node shows up immediately on the compute nodes, and vice versa.

| Path | Contents |
|---|---|
| `/mnt/storage/home/<CENTRE>/<login>` | Your home (`$HOME`). `<CENTRE>` is your unit, e.g. `CIN`, `CCEN`, `CTG`, `CB`, `CAA` |
| `/mnt/storage/apps/spack` | Central Spack installation (read-only for users) |
| `/mnt/storage/apps/R` | Central R installation |

> In your scripts, use **`$HOME`** instead of the full path: it contains your centre and may change.

Total space is about 58 TB, shared by all users. There are no per-user quotas at the moment, but please delete what you no longer need and avoid keeping duplicate copies.

## There are no backups

⚠️ **Data on the cluster is not backed up.** The cluster is a place to compute, not to keep data permanently. Always keep a copy of your important data (inputs, code and results) outside the cluster, and copy results back as soon as a piece of work is finished.

## Scratch

There is no separate scratch area and no local disk available to jobs. Read and write job files in your home. Since all I/O goes over the network, prefer:

- a few large files rather than many small ones;
- writing results periodically, not on every iteration;
- packing directories with thousands of files (`tar`) before transferring them.

## Transferring data

From your computer to the cluster (swap the arguments for the other direction):

```bash
# small files or folders
scp -r data/ firstname.lastname@boivoador0:~/data/

# large volumes: rsync with a bandwidth limit; resumable if interrupted
rsync -ah --partial --progress --bwlimit=100M data/ firstname.lastname@boivoador0:~/data/
```

- Always use the login node (`boivoador0`) for transfers.
- **Talk to the admins before moving several terabytes.** A single large copy can slow storage down for the whole cluster.
- If your home looks empty or old, **don't copy data by hand to "fix" it**. Run `hostname; echo $HOME; getent passwd $USER` and send the output to the admins.

## Checking your usage

```bash
du -sh $HOME              # how much your home uses
du -sh $HOME/* | sort -h  # what takes the most space
df -h /mnt/storage        # free space on shared storage
```
