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
$SAMTOOLS merge -@ 20 /staging/biology/yoda670612/bam_hg19_merge/WES1.bam /staging/biology/yoda670612/bam_hg19_merge/SRR13076396.sorted.bam /staging/biology/yoda670612/bam_hg19_merge/SRR13076397.sorted.bam /staging/biology/yoda670612/bam_hg19_merge/SRR13076398.sorted.bam
$SAMTOOLS index -@ 20 /staging/biology/yoda670612/bam_hg19_merge/WES1.bam /staging/biology/yoda670612/bam_hg19_merge/WES1.bai
