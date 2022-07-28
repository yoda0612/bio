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

SENTIEON_INSTALL_DIR="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-202112"
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
hisat2=/work/yoda670612/hisat2-2.1.0/hisat2
hisat2_build=/work/yoda670612/hisat2-2.1.0/hisat2-build
ref=hg19
aligner=hisat2
nt=40 #number of threads to use in computation
hisat2_index=/staging/biology/yoda670612/hisat2_hg19_index/hisat2_hg19
workdir=/staging/biology/yoda670612/seq2_hisat2
fastqdir=/staging/biology/yoda670612
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
fastq_1=$fastqdir/${SampleName}_1.fastq.gz
fastq_2=$fastqdir/${SampleName}_2.fastq.gz

sam=$workdir/${SampleName}.${aligner}.${ref}.sam
sorted_bam=$workdir/${SampleName}.${aligner}.${ref}.sorted.bam
deduped_bam=$workdir/${SampleName}.${aligner}.${ref}.deduped.bam
score_info=$workdir/${SampleName}.${aligner}.${ref}.score.txt
dedup_metrics=$workdir/${SampleName}.${aligner}.${ref}.dedup_metrics.txt
realigned_bam=$workdir/${SampleName}.${aligner}.${ref}.realigned.bam
recal_data=$workdir/${SampleName}.${aligner}.${ref}.recal_data.table
vcf=$workdir/${SampleName}.${aligner}.${ref}.TNscope.vcf
vcf_mu2=$workdir/${SampleName}.${aligner}.${ref}.Mutect2.vcf

# Update with the location of the reference data files
dbsnp="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/dbsnp_138.hg19.vcf"
known_Mills_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19//Mills_and_1000G_gold_standard.indels.hg19.sites.vcf"
known_1000G_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/1000G_phase1.indels.hg19.sites.vcf"



#$bowtie2_build $fasta $bw2_index
echo "$hisat2 -x $hisat2_index -1 $fastq_1 -2 $fastq_2 -S $sam"
$hisat2 -p $nt --rg-id $group --rg "SM:$sample" --rg "PL:$platform" -x $hisat2_index -1 $fastq_1 -2 $fastq_2 -S $sam

#sort
cat $sam | $SENTIEON_INSTALL_DIR/bin/sentieon util sort -r $fasta -o $sorted_bam -t $nt --sam2bam -i -
$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i $sorted_bam --algo LocusCollector --fun score_info $score_info
$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i $sorted_bam --algo Dedup --rmdup --score_info $score_info --metrics $dedup_metrics $deduped_bam


# ******************************************
# 4. Indel realigner
# ******************************************
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta  -t $nt -i $deduped_bam --algo Realigner -k $known_Mills_indels -k $known_1000G_indels $realigned_bam


# ******************************************
# 5. Base recalibration
# ******************************************
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i $realigned_bam --algo QualCal -k $dbsnp -k $known_Mills_indels -k $known_1000G_indels $recal_data


### TNscope calling
echo "TNScopt"
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i $realigned_bam -q $recal_data --algo TNscope --tumor_sample $sample --dbsnp $dbsnp $vcf

echo "MuTect2"
$gatk --java-options "-Xmx80g" Mutect2 -I $realigned_bam  -O $vcf_mu2 -R $fasta
