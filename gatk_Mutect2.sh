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

SampleName=$1
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk

# input_bam=/staging/biology/yoda670612/bam_hg19/$SampleName.deduped.bam
# output_vcf=/staging/biology/yoda670612/$SampleName.Mutect2.vcf
# fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
# echo "$gatk Mutect2 -I $input_bam -O $output_vcf -R $fasta"
# $gatk --java-options "-Xmx40g" Mutect2 -I $input_bam -O $output_vcf -R $fasta

SampleName=SRR13076390
input_bam=/staging/biology/yoda670612/bam_b37_2/SRR13076390.realigned.bam
output_vcf=/staging/biology/yoda670612/MuTect2_test/$SampleName.Mutect2.all3.vcf
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
echo "$gatk Mutect2 -I $input_bam -O $output_vcf -R $fasta --min-base-quality-score 1"
$gatk --java-options "-Xmx180g" Mutect2 -I $input_bam -O $output_vcf -R $fasta \
      --min-base-quality-score -125 \
      --max-reads-per-alignment-start 0 \
      --max-population-af -100000 \
      --min-dangling-branch-length 0 \
      --min-pruning -999999 \
      --normal-lod 999999
