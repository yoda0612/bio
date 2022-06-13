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

set -euo pipefail

export SENTIEON_LICENSE=140.110.16.119:8990

SampleName="Merged"

sample="SM_"${SampleName}
group="GP_"${SampleName}
platform="ILLUMINA"

SENTIEON_INSTALL_DIR="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-202112"
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
hisat2=/work/yoda670612/hisat2-2.1.0/hisat2
hisat2_build=/work/yoda670612/hisat2-2.1.0/hisat2-build

nt=40 #number of threads to use in computation
workdir=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/seq2
fastqdir=/staging/biology/yoda670612
sam=$workdir/${SampleName}.hisat2.sam
fastadir=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/seq2/fastq
fasta=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/seq2/fastq/human_g1k_v37_decoy.fasta
fastq_1=$fastqdir/${SampleName}1.fastq
fastq_2=$fastqdir/${SampleName}2.fastq
sorted_bam=$workdir/${SampleName}.sorted.bam
deduped_bam=$workdir/${SampleName}.deduped.bam
score_info=$workdir/${SampleName}.score.txt
dedup_metrics=$workdir/${SampleName}.dedup_metrics.txt
realigned_bam=$workdir/${SampleName}.realigned.bam
recal_data=$workdir/${SampleName}.recal_data.table
vcf=$workdir/${SampleName}.b37.TNscope.vcf
vcf_mu2=$workdir/${SampleName}.b37.Mutect2.vcf

# Update with the location of the reference data files

dbsnp="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/dbsnp_138.b37.vcf"
known_Mills_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf"
known_1000G_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/1000G_phase1.indels.b37.vcf"

# echo "$hisat2_build $fasta $fastadir/human_g1k_v37_decoy"
# $hisat2_build $fasta $fastadir/human_g1k_v37_decoy

echo "$hisat2 -x $fastadir/human_g1k_v37_decoy -1 $fastq_1 -2 $fastq_2 -S $sam"
$hisat2 -x $fastadir/human_g1k_v37_decoy -1 $fastq_1 -2 $fastq_2 -S $sam
