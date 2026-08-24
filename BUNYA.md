# BUNYA CHEAT SHEET

## get job allocation 
```
salloc 
```
## run job right now
```
srun slurm.sh 
```

## submit a job slurm script for later execution
```
sbatch slurm.sh 
```

## check storage and quota (kind of lquot) 
```
rquota 
```

## check runnin jobs 
```
module spider jobstats 
module load jobstats/2024.08
jobstats -h 

```

## list fileset shown in rquota 
```
ls -lh /scratch/project
```

## view info about jobs (kind of qstat) 
```
squeue --account group_account_name
squeue --me
squeue --jobs job_id
squeue --users user_id
squeue --users s4573340 -o "%12i %7q %.9P %.20j %.10u %.2t %.11M %.4D %.4C %.14b %8m %16R %18p %10B %.10L" | sort
```

## view info about all partition (general, ai, etc) 
```
sinfo
```

## kill job 
```
scancel job_id 
```

## Reduce walltime (cant increase unless sudo access)
```
scontrol update  jobid=6199891 TimeLimit=24:00:00
```

## Time your job in your slurm script
```
res1=$(date +%s.%N)

Actual job execution 

res2=$(date +%s.%N)

dt=$(echo "$res2 - $res1" | bc)
dd=$(echo "$dt/86400" | bc)
dt2=$(echo "$dt-86400*$dd" | bc)
dh=$(echo "$dt2/3600" | bc)
dt3=$(echo "$dt2-3600*$dh" | bc)
dm=$(echo "$dt3/60" | bc)
ds=$(echo "$dt3-60*$dm" | bc)

LC_NUMERIC=C printf "Total runtime: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds
```

# other useful things 
## check completed array jobs 
```
27269758_
for i in {1..1000}; do
    echo 27269758_${i} | grep "State:" 
    seff  27269758_${i} | grep  "Memory Utilized:" | cut -f 2 -d ":" | cut -f 1 -d "G"   >> /scratch/temp/${SLURM_JOB_ID}/temp.txt
    seff  27269758_${i} | grep  "Job Wall-clock time:"  | cut -f 2 -d "e" | cut -f 2-4 -d ":" >> /scratch/temp/${SLURM_JOB_ID}/temp2.txt
  # 
done
```

## check state of array jobs from .o files 
```
for file in ortho_blast_array27319314*.o
do
    id=$(grep "SLURM Job ID      :" "${file}" | cut -f 2 -d ":" | tr -d ' ')
    if [[ -n "$id" ]]; then
        state=$(PERL5LIB=/usr/lib64/perl5/5.32 seff "$id" 2>/dev/null | grep "State:" | awk '{print $2}')
        if [[ "$state" != "COMPLETED" && -n "$state" ]]; then
            echo "File: $file Job ID: $id - State: $state"
        fi
    fi
done
```

# things to check before you go 
## are all jobs running from scratch (RDM directories should never be a working directory)
```
squeue --users s4573340 -o "%12i" | tail -n +2 | while IFS= read -r line; do  scontrol show job $line  | grep "WorkDir" ; done
squeue --users s4573340 -o "%12i" | tail -n +2 | while IFS= read -r line; do  scontrol show job $line  | grep "WorkDir" | grep -v "/scratch/project_mnt/S0026/ishida"; done
scontrol show job 27269755 | grep "WorkDir" | grep -v "/scratch/project_mnt/S0026/ishida"

rquota
```

# files on scratch get removed if not edited for long time (i think it is 3 months now?)
## to change the modification time
```
find /scratch/project_mnt/S0026/ishida  \( -type f -o -type d \) -exec touch {} +
```

## RUN R scripts 
```
module load r/4.4.0-gfbf-2023a
original_d2s=k21_72genomes.d2s.original.txt
d2s_dir=jk_distmat_60_1000
NJ_dir=jk_NJ_60_1000
mkdir -p $NJ_dir

Rscript nj_tree.R ${original_d2s} ${original_d2s%.txt}.nwk 
```

