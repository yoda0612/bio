#!/bin/bash
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SRR      # Job name
#SBATCH -p ngs192G           # Partition Name
#SBATCH -c 56               # core preserved
#SBATCH --mem=184G           # memory used
#SBATCH -o %j.out          # Path to the standard output file
#SBATCH -e %j.log          # Path to the standard error ouput file
#SBATCH --mail-user=
#SBATCH --mail-type=FAIL



### Parameters
PICARD=/opt/ohpc/Taiwania3/pkg/biology/Picard/picard_v2.26.0/picard.jar

echo "java  -Xmx40g -jar ${PICARD} AddOrReplaceReadGroups INPUT=/staging/biology/yoda670612/$1.marked.bam OUTPUT=/staging/biology/yoda670612/$1.marked.addmarked.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20"
java  -Xmx80g -jar ${PICARD} AddOrReplaceReadGroups INPUT=/staging/biology/yoda670612/$1.marked.bam OUTPUT=/staging/biology/yoda670612/$1.marked.addmarked.bam RGID=1 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
