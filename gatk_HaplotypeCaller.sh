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
# output_vcf=/staging/biology/yoda670612/$SampleName.gakt_HaplotypeCaller.vcf
# fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
# echo "$gatk HaplotypeCaller -I $input_bam -O $output_vcf -R $fasta"
# $gatk --java-options "-Xmx40g" HaplotypeCaller -I $input_bam -O $output_vcf -R $fasta

input_bam=/staging/biology/yoda670612/bam_b37/$SampleName.deduped.bam
output_vcf=/staging/biology/yoda670612/run4_b37_gatk/$SampleName.gakt_HaplotypeCaller.vcf
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
echo "$gatk HaplotypeCaller -I $input_bam -O $output_vcf -R $fasta"
$gatk --java-options "-Xmx180g" HaplotypeCaller -I $input_bam -O $output_vcf -R $fasta
