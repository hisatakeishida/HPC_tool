#!/bin/bash --login
#SBATCH --nodes=1             
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=200G	#memory	
#SBATCH --time=24:00:00 #time 
#SBATCH --account=a_XXXX # change to your account 
#SBATCH --partition=general	
#SBATCH --job-name="rmd_tk"
#SBATCH -e rmd_tk%A_%a.e  # creates rmd_tk${each_jobid}.e   
#SBATCH -o rmd_tk%A_%a.o # creates rmd_tk${each_jobid}.o
#SBATCH --array=1-1000 #max 1000 array jobs per job submission

echo "#=================== JOB INFO ===================#"
echo ""
echo "    SLURM Job ID      :  ${SLURM_JOB_ID}"
echo "    SLURM Job Name    :  ${SLURM_JOB_NAME}"
echo ""
echo "#================================================#"

OUTDIR=derepgenomes-tk
TOTAL_LINES=3899
LINES_PER_JOB=100
REPFILE=RMD_ANI95_AF15.rep.list.txt
mkdir -p ${OUTDIR}

OFFSET=0
START_LINE=$(( (SLURM_ARRAY_TASK_ID - 1) * LINES_PER_JOB + 1 + OFFSET ))
# START_LINE=$(( (1 - 1) * LINES_PER_JOB + 1 + OFFSET ))
END_LINE=$(( START_LINE + LINES_PER_JOB - 1 ))

# Cap END_LINE at TOTAL_LINES
if [ "$END_LINE" -gt "$TOTAL_LINES" ]; then
    END_LINE=$TOTAL_LINES
fi

echo "Processing lines ${START_LINE}–${END_LINE}"

mkdir -p /scratch/temp/${SLURM_JOB_ID}/final_bins

conda activate gtdbtk-2.4.1
# minlen=1000

cat $REPFILE | sort | sed -n "${START_LINE},${END_LINE}p" | while read -r path; do
# ls ${INDIR}/* | sort | sed -n "${START_LINE},${END_LINE}p" | while read -r path; do
    ls ${path}
    cp ${path} /scratch/temp/${SLURM_JOB_ID}/final_bins
done

gtdbtk classify_wf -x fa --skip_ani_screen --cpus ${SLURM_CPUS_PER_TASK} --pplacer_cpus ${SLURM_CPUS_PER_TASK} --genome_dir /scratch/temp/${SLURM_JOB_ID}/final_bins \
--out_dir /scratch/temp/${SLURM_JOB_ID}/tk_${START_LINE}_${END_LINE} --tmpdir /scratch/temp/${SLURM_JOB_ID}

cp -r /scratch/temp/${SLURM_JOB_ID}/tk_${START_LINE}_${END_LINE} ${OUTDIR}
