This repo includes a set of best practices that can help to improve productivity and efficiency on the clusters that managed by HPC Advisory Council.

In all the examples, your account name and available QoS can be determined by running `sacctmgr show assoc user=$USER`.

In order to use in in the HPCAC Cluster Center, simply clone the repo and edit the relevant script (e.g. NAMD slurm script).

```
$ git clone https://github.com/hpcac/BestPractices
$ ls
BestPractices
$ cd BestPractices/NAMD/
$ ls
slurm.sh
```

After edit, simpliy run the slurm job script via `sbatch slurm.sh`.
