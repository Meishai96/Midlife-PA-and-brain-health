# open computing node

srun --partition=short --nodes=1 --mem=24Gb --time=02:00:00 --pty /bin/bash

# load freesurfer
module load gnu-parallel/20210922

export FREESURFER_HOME=$HOME/software/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECTS_DIR=`pwd`

# make fsgd file in excel and save as text, and run below to convert it into fsgd

tr '\r' '\n' < past_mvpa.txt > mvpa.fsgd 

# create folder FSGD under study folder and upload FSGD files to the study folder

cd /work/cbhlab/Meishan/PAD_pastPA_2022/derivatives/freesurfer

mkdir FSGD

# check if this folder has fsaverage (do not need to worry for fmriprep outputs data)

# create contrasts matrix for two groups and 4 covars 

cd /Contrasts 
echo 0 1 0 0 0 0 > past_mvpa.mtx

echo 1 -1 0 0 0 0 0 0 0 0 0 > past_activeness.mtx

# then define subject directory for freesurfer

cd /work/cbhlab/Meishan/PAD_pastPA_2022/derivatives/freesurfer
export SUBJECTS_DIR=`pwd` 
echo $SUBJECTS_DIR # to check if worked

# run sbatch scrit for smoothing (re-do recon-all -qcache)

sbatch runSmooth.sh

# compile all data through mris_preproc (change variable if needed)

tcsh runMrisPreproc.sh

# run GLM analysis (change variable if needed)

tcsh runGLM.sh

# correct for multiple comparisons using permuation (https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/MultipleComparisonsV6.0Perm) Did not work for the current dataset

tcsh runPermu.sh 

# correct for multiple comparisons using pre-cached monticarlo z distrubution (threshold set at 3 abs)

tcsh runClustmczsimstc.sh

# see results

freeview -f $SUBJECTS_DIR/fsaverage/surf/rh.inflated:overlay=rh.area.past_mvpa.10.glmdir/exer/cache.th30.abs.sig.cluster.mgh

# extract DK atlas mean values- create list of subjects first (https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI)

list=`ls HCD* -d`

tcsh

tcsh runStats2table.sh 



# convert the result MNI305 coordinates to MNI152 coordinates
Define a matrix in Matlab like the follow:
M= [0.9975   -0.0073    0.0176   -0.0429;
    0.0146    1.0009   -0.0024    1.5496;
   -0.0130   -0.0093    0.9971    1.1840]

Define a vector by the MNI305 coords
v=[X Y Z 1]'

Then get the MNI152 coordinate by M*v
For pastmvpa_controlCurr_trans left_hemi area: -28.7693 12.9223 46.0272
For pasttotal_controlCurr_trans right_hemi area: 21.6690 41.6235 32.0427

Next, follow Andy's brain book tutorial to create the ROI sphere: (remember to use voxel coord rather than MNI152 for the sphere)
https://andysbrainbook.readthedocs.io/en/latest/fMRI_Short_Course/fMRI_09_ROIAnalysis.html









