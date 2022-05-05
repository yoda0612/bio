#!/bin/bash
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SRR      # Job name
#SBATCH -p ngs192G           # Partition Name
#SBATCH -c 56               # core preserved
#SBATCH --mem=184G           # memory used
#SBATCH -o out.log          # Path to the standard output file
#SBATCH -e err.log          # Path to the standard error ouput file
#SBATCH --mail-user=
#SBATCH --mail-type=FAIL


tool_dir=/opt/ohpc/Taiwania3/pkg/biology

### Parameters
PICARD=${tool_dir}/Picard/picard_v2.26.0/picard.jar

echo "java  -Xmx40g -jar ${PICARD} SortSam INPUT=/staging/biology/yoda670612/$1.sam OUTPUT=/staging/biology/yoda670612/$1.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true"

java  -Xmx40g -jar ${PICARD} SortSam INPUT=/staging/biology/yoda670612/$1.sam OUTPUT=/staging/biology/yoda670612/$1.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true
