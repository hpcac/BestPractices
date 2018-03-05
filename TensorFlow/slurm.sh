#!/bin/bash -l
## Replace with the job name that you intend to use
#SBATCH --job-name=tensorflow

## Replace with the actual account on the cluster that you intend to use
#SBATCH --account=hpcac

## Replace with the actual partition that you intend to use
#SBATCH --partition=jupiter

## Require nodes with K20 GPUs
#SBATCH --constraint=jupiter_k20

## Replace with the actual number of nodes that you intend to use
#SBATCH --nodes=1

## Replace with the actual wall clock time limit that you intend to use
#SBATCH --time=30:00

## Load the current version of TensorFlow module
module purge
module load ml/tensorflow/1.4.1-py27

## Run it
python test.py
