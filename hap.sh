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
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
python=/work/yoda670612/anaconda2/bin/python2
hap=/home/yoda670612/hap.py-build/bin/hap.py
truth_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.vcf.gz
bed=/staging/biology/yoda670612/truth/CTR_hg19.bed
SampleName=$1
aligner=$2
folder=$3
caller=$4
input_vcf=$5


input_vcf=/staging/biology/yoda670612/${folder}/${SampleName}.${aligner}.hg19.${caller}.vcf
output_prefix=/staging/biology/yoda670612/results/${SampleName}.${aligner}.hg19.${caller}


echo "$python $hap $truth_vcf $input_vcf -f $bed -o $output_prefix -r $fasta"
$python $hap $truth_vcf $input_vcf -f $bed -o $output_prefix -r $fasta
