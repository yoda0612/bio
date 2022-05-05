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
#fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
python=/work/yoda670612/anaconda2/bin/python2
hap=/home/yoda670612/hap.py-build/bin/hap.py
truth_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.b37.vcf
bed=/staging/biology/yoda670612/truth/CTR_hg19.b37.bed
SampleName=$1

# input_vcf=/staging/biology/yoda670612/run8_dragen/$SampleName.SomaticSeq.vcf
# output_prefix=/staging/biology/yoda670612/run8_dragen/$SampleName.SomaticSeq

input_vcf=/staging/biology/yoda670612/run12_somaticseq/SSeq.Classified.sSNV.vcf.gz
output_prefix=/staging/biology/yoda670612/run12_somaticseq/SSeq.Classified.sSNV.hap

echo "$python $hap $truth_vcf $input_vcf -f $bed -o $output_prefix -r $fasta"
$python $hap $truth_vcf $input_vcf -f $bed -o $output_prefix -r $fasta

truth_vcf=/home/yoda670612/somaticseq_example/Varsim.somatic.truth.vcf.gz
input_vcf=/home/yoda670612/somaticseq_example/megred.vcf
output_prefix=/home/yoda670612/somaticseq_example/megred.hap

echo "$python $hap $truth_vcf $input_vcf -f $bed -o $output_prefix -r $fasta"
$python $hap $truth_vcf $input_vcf -f $bed -o $output_prefix -r $fasta
