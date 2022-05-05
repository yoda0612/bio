#! /bin/bash

job_id1=$(sbatch job1.sh)
echo $job_id1

if [[ "$job_id1" =~ Submitted\ batch\ job\ ([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    sbatch --dependency=afterok:${BASH_REMATCH[1]} job2.sh
    exit 0
else
    echo "sbatch failed"
    exit 1
fi
