#!/usr/bin/bash
for i in {0..8};
do
  SampleName=SRR1307639$i
  gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
  input_vcf=/staging/biology/yoda670612/bam_hg19_2/$SampleName.hg19.TNscope.vcf
  output_vcf=/staging/biology/yoda670612/bam_hg19_2/$SampleName.hg19.TNscope.selected.vcf
  fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
  interval=/staging/biology/yoda670612/truth/CTR_hg19.interval_list
  echo "$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval"
  $gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval
done
