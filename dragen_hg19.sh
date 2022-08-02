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

SampleName=$1

sample="SM_"${SampleName}
group="GP_"${SampleName}
platform="ILLUMINA"
aligner="dragen"
SENTIEON_INSTALL_DIR="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-202112"
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
SAMTOOLS=/opt/ohpc/Taiwania3/pkg/biology/SAMTOOLS/SAMTOOLS_v1.13/bin/samtools

ref="hg19"
nt=40 #number of threads to use in computation
workdir=/staging/biology/yoda670612/seq2_dragen
#fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
fastq_1=$workdir/${SampleName}_R1.fastq.gz
fastq_2=$workdir/${SampleName}_R2.fastq.gz
sam=$workdir/${SampleName}.${aligner}.${ref}.sam
sorted_untaged_bam=$workdir/${SampleName}.${aligner}.${ref}.sorted.bam
sorted_bam=$workdir/${SampleName}.${aligner}.${ref}.sorted.taged.bam
deduped_bam=$workdir/${SampleName}.${aligner}.${ref}.deduped.bam
score_info=$workdir/${SampleName}.${aligner}.${ref}.score.txt
dedup_metrics=$workdir/${SampleName}.${aligner}.${ref}.dedup_metrics.txt
realigned_bam=$workdir/${SampleName}.${aligner}.${ref}_tumor.bam
recal_data=$workdir/${SampleName}.${aligner}.${ref}.recal_data.table
vcf=$workdir/${SampleName}.${aligner}.${ref}.TNscope.vcf
vcf_mu2=$workdir/${SampleName}.${aligner}.${ref}.Mutect2.vcf

# Update with the location of the reference data files

dbsnp="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/dbsnp_138.hg19.vcf"
known_Mills_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19//Mills_and_1000G_gold_standard.indels.hg19.sites.vcf"
known_1000G_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/1000G_phase1.indels.hg19.sites.vcf"

printf "#############################################################################\n"
printf "###                  Work started:   $(date +%Y-%m-%d:%H:%M:%S)           ###\n"
printf "#############################################################################\n"

# $gatk AddOrReplaceReadGroups I=$sorted_untaged_bam O=$sorted_bam  \
#        RGID=$group \
#        RGLB=$group \
#        RGPL=$platform \
#        RGPU=$group \
#        RGSM=$sample
#$SAMTOOLS index $sorted_bam


$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i $realigned_bam --algo QualCal -k $dbsnp -k $known_Mills_indels -k $known_1000G_indels $recal_data


### TNscope calling
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i $realigned_bam -q $recal_data --algo TNscope --tumor_sample $sample --dbsnp $dbsnp $vcf
$gatk --java-options "-Xmx80g" Mutect2 -I $realigned_bam  -O $vcf_mu2 -R $fasta
