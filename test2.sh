#! /bin/bash
sbr="Submitted batch job 719362"
if [[ "$sbr" =~ Submitted\ batch\ job\ ([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]}"
    ls -all
    exit 0
else
    echo "sbatch failed"
    exit 1
fi
ß
