#!/bin/bash -l
## Replace with the job name that you intend to use
#SBATCH --job-name=gromacs

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
module load md/gromacs/2018-hpcx-2.1.0-intel-2018.1.163

## The recommended best practice
MPI_FLAGS="--display-map --report-bindings --map-by core --bind-to core"
UCX_FLAGS="-mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1"
HCOLL_FLAGS="-mca coll_fca_enable 0 -mca coll_hcoll_enable 1 -x HCOLL_MAIN_IB=mlx5_0:1"

## The executable
EXE=gmx_mpi

## Prepare example directory
cd $SLURM_SUBMIT_DIR
mkdir gromacs
cd gromacs

## Download benchmark
wget -c ftp://ftp.gromacs.org/pub/benchmarks/gmxbench-3.0.tar.gz
tar zxpvf gmxbench-3.0.tar.gz
cd d.dppc
sed -i.bak 's/#include "spc.itp"/#include "amber99sb-ildn.ff\/tip3p.itp"/' topol.top
sed -i.bak 's/rcoulomb                 = 1.8/rcoulomb                 = 1.0/' grompp.mdp

## Prepare the run
${EXE} grompp -f grompp.mdp -c conf.gro -p topol.top -o mdrun.tpr

## Run it
time mpirun ${MPI_FLAGS} ${UCX_FLAGS} ${HCOLL_FLAGS} ${EXE} mdrun -s mdrun.tpr
