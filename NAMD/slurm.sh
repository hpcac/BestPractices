#!/bin/sh
## Replace with the job name that you intend to use
#SBATCH --job-name=namd2

## Replace with the actual account on the cluster that you intend to use (run "sacctmgr show assoc user=$USER" to check your account)
#SBATCH --account=hpcac

## Replace with the actual partition that you intend to use
#SBATCH --partition=thor

## Replace with the actual QoS that you intend to use (no need to change in most cases)
#SBATCH --qos=low

## Replace with the actual number of nodes that you intend to use
#SBATCH --nodes=2

## Replace with the actual number of cores that you intend to use on each node
#SBATCH --ntasks-per-node=32

## Replace with the actual wall clock time limit that you intend to use
#SBATCH --time=30:00

## Load the current version of NAMD module
module purge
module load md/namd/2.12-hpcx-2.0.0-intel-2018.1.163

## The recommended best practice to run NAMD
MPI_FLAGS="--display-map --report-bindings --map-by core --bind-to core"
UCX_FLAGS="-mca pml ucx -mca mtl ^mxm -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc_x,shm,self"
HCOLL_FLAGS="-mca coll_fca_enable 0 -mca coll_hcoll_enable 1 -x HCOLL_MAIN_IB=mlx5_0:1"

## The executable of NAMD
EXE=namd2

## Replace with the actual input file that you intend to use
INPUT=apoa1/apoa1.namd

## Run it
mpirun ${MPI_FLAGS} ${UCX_FLAGS} ${HCOLL_FLAGS} ${EXE} ${INPUT}
