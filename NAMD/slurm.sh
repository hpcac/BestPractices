#!/bin/bash -l
## Replace with the job name that you intend to use
#SBATCH --job-name=namd2

## Replace with the actual account on the cluster that you intend to use (run "sacctmgr show assoc user=$USER" to check your account)
#SBATCH --account=hpcac

## Replace with the actual partition that you intend to use
#SBATCH --partition=thor

## Replace with the actual number of nodes that you intend to use
#SBATCH --nodes=2

## Replace with the actual number of cores that you intend to use on each node
#SBATCH --ntasks-per-node=32

## Replace with the actual wall clock time limit that you intend to use
#SBATCH --time=30:00

## Load the current version of module
module purge
module load md/namd/2.12-hpcx-2.0.0-intel-2018.1.163

## The recommended best practice
MPI_FLAGS="--display-map --report-bindings --map-by core --bind-to core"
UCX_FLAGS="-mca pml ucx -mca mtl ^mxm -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc_x,shm,self"
HCOLL_FLAGS="-mca coll_fca_enable 0 -mca coll_hcoll_enable 1 -x HCOLL_MAIN_IB=mlx5_0:1"

## The executable
EXE=namd2

## Replace with the actual input file that you intend to use
INPUT=apoa1.namd

## Prepare example directory
cd $SLURM_SUBMIT_DIR
mkdir namd
cd namd

## Download ApoA1 benchmark
wget -c http://www.ks.uiuc.edu/Research/namd/utilities/apoa1.tar.gz
tar zxpvf apoa1.tar.gz
cd apoa1
sed -i.bak 's/\/usr//' apoa1.namd

## Run it
time mpirun ${MPI_FLAGS} ${UCX_FLAGS} ${HCOLL_FLAGS} ${EXE} ${INPUT}
