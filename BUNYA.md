BUNYA CHEAT SHEET

# get job allocation 
```
salloc 
```
# run job right now
```
srun slurm.sh 
```

#submit a job slurm script for later execution
```
sbatch slurm.sh 
```

# check storage and quota (kind of lquot) 
```
rquota 
```

# list fileset shown in rquota 
```
ls -lh /scratch/project
```

# view info about jobs (kind of qstat) 
```
squeue --account group_account_name
squeue --jobs job_id
squeue --users user_id
```

# view info about all partition (general, ai, etc) 
```
sinfo
```
# kill job 
```
scancel job_id 
```
