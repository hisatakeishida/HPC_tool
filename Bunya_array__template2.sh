#!/bin/bash --login
#SBATCH --job-name="ortho_blast_array"    
#SBATCH --nodes=1             
#SBATCH --ntasks-per-node=1     
#SBATCH --cpus-per-task=8
#SBATCH --mem=5G
#SBATCH --time=6:00:00		
#SBATCH --account=a_ace	
#SBATCH --partition=general	       	
#SBATCH -e ortho_blast_array%A_%a.e    
#SBATCH -o ortho_blast_array%A_%a.o
#SBATCH --array=1-1000

echo "#=================== JOB INFO ===================#"
echo ""
echo "    SLURM Job ID      :  ${SLURM_JOB_ID}"
echo "    SLURM Job Name    :  ${SLURM_JOB_NAME}"
echo ""
echo "#================================================#"

OFFSET=0 #1-1000
#D OFFSET=1000 #1001-2000 
#D OFFSET=2000 #2001-3000
#D OFFSET=3000 #3001-4000
#D OFFSET=4000 #4001-5000
#D OFFSET=5000 #5001-5184

# wc -l orthod_scratch.log
# 5184 orthod_scratch.log

LINE=$(( (SLURM_ARRAY_TASK_ID + OFFSET )))
# LINE=$(( (304 + OFFSET )))
# echo $LINE

r1_list=orthod_scratch.log
COMMAND=$(sed -n "${LINE}p" "$r1_list")

# Append the number of threads
COMMAND="$COMMAND --threads $SLURM_CPUS_PER_TASK"
echo "$COMMAND"

conda activate /scratch/user/s4573340/orthofinder
cd  /scratch/temp/${SLURM_JOB_ID}/

eval "$COMMAND"

