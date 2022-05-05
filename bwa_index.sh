#!/bin/bash
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SRR      # Job name
#SBATCH -p ngs192G           # Partition Name
#SBATCH -c 56               # core preserved
#SBATCH --mem=184G           # memory used
#SBATCH -o %j.out          # Path to the standard output file
#SBATCH -e %j.log          # Path to the standard error ouput file
#SBATCH --mail-user=cycheng1978@g.ntu.edu.tw
#SBATCH --mail-type=FAIL

# Update with the location of the Sentieon software package and license file
# export SENTIEON_LICENSE=140.110.16.119:8990
#
# /staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-201808/bin/sentieon bwa index genome.fasta


tool_dir=/opt/ohpc/Taiwania3/pkg/biology
PICARD=${tool_dir}/Picard/picard_v2.26.0/picard.jar
echo "${tool_dir}/SAMTOOLS/SAMTOOLS_v1.13/bin/samtools faidx genome.fasta"
${tool_dir}/SAMTOOLS/SAMTOOLS_v1.13/bin/samtools faidx genome.fasta

# echo "java  -Xmx40g -jar ${PICARD} CreateSequenceDictionary INPUT=genome.fasta OUTPUT=genome.dict"
# java  -Xmx40g -jar ${PICARD} CreateSequenceDictionary INPUT=genome.fasta OUTPUT=genome.dict
