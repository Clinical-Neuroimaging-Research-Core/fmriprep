#!/bin/bash
#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=48G
#SBATCH --time =10:00:00
#SBATCH -J fmriprep
#SBATCH --output /gpfs/scratch/%u/fmriprep-log%A_%a.txt
#SBATCH --array=1-3

#---------CONFIGURE THESE VARIABLES--------------

mkdir -p /tmp/$SLURM_JOB_ID
root_dir=/gpfs/data/nmclaugh/conte #path to study folder
fmriprep_version=20.2.6

fmriprep="`sed -n ${SLURM_ARRAY_TASK_ID}p subjects.txt`"

echo $fmriprep

#---------END OF VARIABLES------------------------

singularity run --cleanenv                                             \
--bind ${root_dir}:/data                                               \
--bind /tmp/$SLURM_JOB_ID:/scratch                                     \
--bind /gpfs/data/bnc/licenses:/licenses                               \
/gpfs/data/bnc/simgs/nipreps/fmriprep-${fmriprep_version}.sif          \
/data/rawdata /data/derivatives/fmriprep                               \
participant --participant-label ${fmriprep}                            \
--fs-license-file /licenses/freesurfer-license.txt                     \
-w /scratch/$fmriprep --stop-on-first-crash                            \
--omp-nthreads 16 --nthreads 1