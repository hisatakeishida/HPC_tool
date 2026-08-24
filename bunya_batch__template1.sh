#!/bin/bash -l
#SBATCH --nodes=1 #DONT CHANGE
#SBATCH --ntasks-per-node=1 #DONT CHANGE
#SBATCH --cpus-per-task=24 # number of threads/CPU you want to use
#SBATCH --mem=80G #memory 
#SBATCH --time=24:00:00 #job time 
#SBATCH --partition=general #choose partition
#SBATCH --account=a_XXX
#SBATCH --job-name=mmseqs_test 
#SBATCH -o mmseqs_test.o
#SBATCH -e mmseqs_test.e

echo "#=================== JOB INFO ===================#"
echo ""
echo "    SLURM Job ID      :  ${SLURM_JOB_ID}"
echo "    SLURM Job Name    :  ${SLURM_JOB_NAME}"
echo ""
echo "#================================================#"

infile=final_contigs.fasta
uniref_db=UniRef90
OUTDIR=03_ncass_mmseqs

# conda env list check which conda env you want to use 
conda activate /home/s4573340/.conda/envs/gtdbtk-2.4.1 

# module spider mmseqs 
module load mmseqs2/15-6f452

# some other databases 
# /scratch/opendata/genomics/GTDB/releases/release226

# /scratch/temp/${SLURM_JOB_ID} is the temp you should be using for batch job. Will be deleted at the end of the job, so make sure to copy them!!!!!
mmseqs easy-taxonomy ${infile} ${uniref_db} ${OUTDIR}/test_uniref90.taxonomy /scratch/temp/${SLURM_JOB_ID} --threads ${SLURM_CPUS_PER_TASK} --split-memory-limit 50G --tax-lineage 1



