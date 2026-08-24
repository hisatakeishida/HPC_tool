#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --job-name=pcoa_plot
#SBATCH --time=00:30:00
#SBATCH --partition=general
#SBATCH --account=a_XXXX
#SBATCH -o pcoa_plot.o
#SBATCH -e pcoa_plot.e

echo "#=================== JOB INFO ===================#"
echo ""
echo "    SLURM Job ID      :  ${SLURM_JOB_ID}"
echo "    SLURM Job Name    :  ${SLURM_JOB_NAME}"
echo ""
echo "#================================================#"

module load r/4.4.0-gfbf-2023a

Rscript /scratch/project_mnt/S0026/ishida/0_scripts/R/Rscripts/IMOS_new/fromRDS.R
