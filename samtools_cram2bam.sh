#!/usr/bin/bash
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SRR      # Job name
#SBATCH -p ngs192G           # Partition Name
#SBATCH -c 56               # core preserved
#SBATCH --mem=184G           # memory used
#SBATCH -o %j.out          # Path to the standard output file
#SBATCH -e %j.log          # Path to the standard error ouput file
#SBATCH --mail-user=cycheng1978@g.ntu.edu.tw
#SBATCH --mail-type=FAIL



SAMTOOLS=/opt/ohpc/Taiwania3/pkg/biology/SAMTOOLS/SAMTOOLS_v1.13/bin/samtools
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
output=/staging/biology/yoda670612/run8_dragen/SRR13076390.dragen.bam
input=/staging/biology/yoda670612/run8_dragen/dragen_v3.9_b37_SRR13076390_tumor.cram
$SAMTOOLS view -b -T $fasta -o $output $input
