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
SampleName=$1

fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta

# echo "/work/yoda670612/VarDict-1.8.3/bin/VarDict -G $fasta -f 0.01 -N $SampleName -b /staging/biology/yoda670612/$SampleName.deduped.bam -c 1 -S 2 -E 3  /staging/biology/yoda670612/truth/CTR_hg19.bed > $SampleName.var"
# /work/yoda670612/VarDict-1.8.3/bin/VarDict -G $fasta -f 0.01 -N $SampleName -b /staging/biology/yoda670612/$SampleName.deduped.bam -c 1 -S 2 -E 3  /staging/biology/yoda670612/truth/CTR_hg19.bed > $SampleName.var

# echo "/work/yoda670612/VarDict-1.8.3/bin/./teststrandbias.R SRR13076390.var > SRR13076390.var2"
# /work/yoda670612/VarDict-1.8.3/bin/./teststrandbias.R SRR13076390.var > SRR13076390.var2

echo "cat $SampleName.var | /work/yoda670612/VarDict-1.8.3/bin/teststrandbias.R | /work/yoda670612/VarDict-1.8.3/bin/var2vcf_valid.pl -N $SampleName -E -f 0.01 > $SampleName.vcf"
cat $SampleName.var | /work/yoda670612/VarDict-1.8.3/bin/teststrandbias.R | /work/yoda670612/VarDict-1.8.3/bin/var2vcf_valid.pl -N $SampleName -E -f 0.01 > $SampleName.vcf
