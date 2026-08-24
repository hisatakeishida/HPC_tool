#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --job-name=BUSCO
#SBATCH --time=24:00:00
#SBATCH --partition=general
#SBATCH --account=a_XXX
#SBATCH -o BUSCO.o
#SBATCH -e BUSCO.e

echo "#=================== JOB INFO ===================#"
echo ""
echo "    SLURM Job ID      :  ${SLURM_JOB_ID}"
echo "    SLURM Job Name    :  ${SLURM_JOB_NAME}"
echo ""
echo "#================================================#"

alvdb=alveolata_odb12
buscosif=busco_v6.0.0_cv1.sif #download your container sif file 
ASS_PATH=contigs.fa
ASS_ID=ASS_1
OUTDIR=/scratch/project_mnt/S0026/ishida

cd /scratch/temp/${SLURM_JOB_ID}
cp ${ASS_PATH} /scratch/temp/${SLURM_JOB_ID}/${ASS_ID}_final_contigs.fasta 

# apptainer loaded already on compute node for BUNYA
# docker pull ezlabgva/busco:v6.0.0_cv1 is what you will see in docker page 
# apptainer pull busco_v6.0.0_cv1.sif docker://ezlabgva/busco:v6.0.0_cv1 

apptainer run --bind /scratch/temp/${SLURM_JOB_ID}:/working ${buscosif} busco -i /scratch/temp/${SLURM_JOB_ID}/${ASS_ID}_final_contigs.fasta  -m genome -l ${alvdb} -c ${SLURM_CPUS_PER_TASK} -o ${ASS_ID}_alvdb --offline --miniprot

cp -r ${ASS_ID}_alvdb ${OUTDIR}
