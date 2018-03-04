#!/bin/bash -l
## Replace with the job name that you intend to use
#SBATCH --job-name=openfoam

## Replace with the actual account on the cluster that you intend to use (run "sacctmgr show assoc user=$USER" to check your account)
#SBATCH --account=hpcac

## Replace with the actual partition that you intend to use
#SBATCH --partition=thor

## Replace with the actual QoS that you intend to use (no need to change in most cases)
#SBATCH --qos=low

## Replace with the actual number of nodes that you intend to use
#SBATCH --nodes=1

## Replace with the actual number of cores that you intend to use on each node
#SBATCH --ntasks-per-node=4

## Replace with the actual wall clock time limit that you intend to use
#SBATCH --time=30:00

## Load the current version of NAMD module
module purge
module load cfd/openfoam/v1712-hpcx-2.1.0-intel-2018.1.163

## The recommended best practice to run NAMD
MPI_FLAGS="--display-map --report-bindings --map-by core --bind-to core"
UCX_FLAGS="-mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1"
HCOLL_FLAGS="-mca coll_fca_enable 0 -mca coll_hcoll_enable 1 -x HCOLL_MAIN_IB=mlx5_0:1"

cd $SLURM_SUBMIT_DIR
mkdir openfoam
cd openfoam

## Copy a tutorial
cp -r $OPENFOAM_DIR/tutorials/incompressible/simpleFoam/pitzDailyExptInlet ./
cd pitzDailyExptInlet

## Run blockMesh
blockMesh

## Run simpleFoam in serial to make sure it works
time simpleFoam

## Decompose the mesh
decomposePar

## Run simpleFoam in parallel
time mpirun ${MPI_FLAGS} ${UCX_FLAGS} ${HCOLL_FLAGS} simpleFoam -parallel
