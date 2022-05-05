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
SAMTOOLS=/opt/ohpc/Taiwania3/pkg/biology/SAMTOOLS/SAMTOOLS_v1.13/bin/samtools
SAMTBAMBA=/opt/ohpc/Taiwania3/pkg/biology/sambamba/sambamba_v0.8.1/sambamba
SampleName=$1

sample="SM_"${SampleName}
group="GP_"${SampleName}
platform="ILLUMINA"

SENTIEON_INSTALL_DIR="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-202112"
nt=40 #number of threads to use in computation
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
fastq_1=/staging/biology/yoda670612/${SampleName}_1.fastq
fastq_2=/staging/biology/yoda670612/${SampleName}_2.fastq
# Update with the location of the reference data files

dbsnp="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/dbsnp_138.b37.vcf"
known_Mills_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf"
known_1000G_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/1000G_phase1.indels.b37.vcf"

printf "#############################################################################\n"
printf "###                  Work started:   $(date +%Y-%m-%d:%H:%M:%S)           ###\n"
printf "#############################################################################\n"

#align
# $SENTIEON_INSTALL_DIR/bin/sentieon bwa mem -R "@RG\tID:$group\tSM:$sample\tPL:$platform" \
# -M  -t 1 \
# $fasta $fastq_1 $fastq_2 \
# | $SAMTOOLS view -Sbh - \
# | $SAMTOOLS sort -m 4G --threads 1 -o /staging/biology/yoda670612/bam_somatic/aligned.bwa.bam

#index
#$SAMTOOLS index -@1 /staging/biology/yoda670612/bam_somatic/aligned.bwa.bam


$SAMTBAMBA markdup -t 20  \
--tmpdir /staging/biology/yoda670612/bam_somatic/temp \
/staging/biology/yoda670612/bam_somatic/aligned.bwa.bam \
/staging/biology/yoda670612/bam_somatic/aligned.marked_dup.bwa.bam



#
# bwa mem \
# -R '@RG\tID:$group\tSM:$sample\tPL:$platform' \
# -M  -t 1 \
# /828d3d2ab7e84553a81ace34728efdbd/human_g1k_v37_decoy.fasta \
# /7245323466ae4116b80e3f4d68f6c967/Reads_Merged_R1.fq.gz \
# /7151b388651b4fce9d0664537465e405/Reads_Merged_R2.fq.gz \
# | samtools view -Sbh - \
# | samtools sort -m 4G --threads 1 -o /439d815cf47c4854b3ab0b071ab17e04/bam/aligned.bwa.bam"
