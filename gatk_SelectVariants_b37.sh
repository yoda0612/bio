#!/usr/bin/bash
for i in {0..8};
do
  SampleName=SRR1307639$i
  gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
  input_vcf=/staging/biology/yoda670612/run4_b37_gatk/$SampleName.Mutect2.vcf
  output_vcf=/staging/biology/yoda670612/run4_b37_gatk/$SampleName.Mutect2.selected.vcf
  fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
  interval=/staging/biology/yoda670612/truth/CTR_hg19.b37.interval_list
  echo "$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval"
  $gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval
done

gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
input_vcf=/staging/biology/yoda670612/plan/SRR13076390.dragmap.b37.Mutect2.vcf
output_vcf=/staging/biology/yoda670612/plan/SRR13076390.dragmap.b37.Mutect2.PanelA.selected.vcf
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
interval=/staging/biology/yoda670612/truth/CTR_hg19.b37.interval_list
echo "$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval"
$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval


gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
input_vcf=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/seq2/Merged.b37.Mutect2.new.vcf
output_vcf=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/seq2/Merged.b37.Mutect2.selected.vcf
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
interval=/staging/biology/yoda670612/truth/CTR_hg19.b37.interval_list
echo "$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval"
$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval



gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
input_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.b37.vcf
output_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.b37.selected.vcf
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
interval=/staging/biology/yoda670612/truth/CTR_hg19.b37.interval_list
echo "$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval"
$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval
