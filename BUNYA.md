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

## SIGMOD


