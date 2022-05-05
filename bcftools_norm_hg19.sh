#!/usr/bin/bash
#for i in {0..8};
# do
#   SampleName=SRR1307639$i
#   bcftools=/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools
#   input_vcf=$SampleName.Mutect2.selected.vcf
#   output_vcf=$SampleName.Mutect2.selected.norm.vcf
#
#   echo "$bcftools norm -m- $input_vcf -O z -o $output_vcf"
#   $bcftools norm -m- $input_vcf -O z -o $output_vcf
# done

for i in {0..8};
do
  SampleName=SRR1307639$i
  fix_mutech2_vcf2=/home/yoda670612/fix_mutech2_vcf2.py
  input_vcf=$SampleName.Mutect2.selected.norm.vcf
  output_vcf=$SampleName.Mutect2.selected.norm.fixed.vcf

  echo "python $fix_mutech2_vcf2 $input_vcf $output_vcf"
  python $fix_mutech2_vcf2 $input_vcf $output_vcf
done
