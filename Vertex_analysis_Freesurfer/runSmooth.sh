#!/bin/bash

#SBATCH -N 1
#SBATCH -n 16
#SBATCH -p short
#SBATCH -t 24:00:00
# Outputs -----------------
#SBATCH --error=%x.%A-%a.err
#SBATCH --array=1-158%50
#SBATCH --mail-user=ai.me@northeastern.edu
#SBATCH --mail-type=ALL

export FREESURFER_HOME=$HOME/software/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECTS_DIR=`pwd`

subject_name=`sed "${SLURM_ARRAY_TASK_ID}q;d" sublist.txt`

recon-all -s ${subject_name} -qcache


