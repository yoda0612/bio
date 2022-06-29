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

SampleName="SRR13076390"

sample="SM_"${SampleName}
group="GP_"${SampleName}
platform="ILLUMINA"

SENTIEON_INSTALL_DIR="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-202112"
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
SAMTOOLS=/opt/ohpc/Taiwania3/pkg/biology/SAMTOOLS/SAMTOOLS_v1.13/bin/samtools

nt=40 #number of threads to use in computation
fastqdir=/staging/biology/yoda670612
workdir=/staging/biology/yoda670612/plan
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta

sam=$workdir/${SampleName}.dragmap.sam
notag_bam=$workdir/${SampleName}.dragmap.notag.bam
bam=$workdir/${SampleName}.dragmap.bam

sorted_bam=$workdir/${SampleName}.dragmap.sorted.bam
deduped_bam=$workdir/${SampleName}.dragmap.deduped.bam
score_info=$workdir/${SampleName}.dragmap.score.txt
dedup_metrics=$workdir/${SampleName}.dragmap.dedup_metrics.txt
realigned_bam=$workdir/${SampleName}.dragmap.realigned.bam
recal_data=$workdir/${SampleName}.dragmap.ecal_data.table
vcf=$workdir/${SampleName}.dragmap.b37.TNscope.vcf
vcf_mu2=$workdir/${SampleName}.dragmap.b37.Mutect2.vcf

# Update with the location of the reference data files

dbsnp="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/dbsnp_138.b37.vcf"
known_Mills_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf"
known_1000G_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/1000G_phase1.indels.b37.vcf"



echo "$SAMTOOLS view -bS $sam > $bam"
$SAMTOOLS view -bS $sam > $notag_bam

$gatk AddOrReplaceReadGroups I=$notag_bam O=$bam  \
       RGID=$group \
       RGLB=$group \
       RGPL=$platform \
       RGPU=$group \
       RGSM=$sample

echo "$SAMTOOLS sort $bam -o $sorted_bam"
$SAMTOOLS sort $bam -o $sorted_bam

echo "$SAMTOOLS index $sorted_bam"
$SAMTOOLS index $sorted_bam


#sort
#$SENTIEON_INSTALL_DIR/bin/sentieon util sort -r $fasta -i $bam -o $sorted_bam -t $nt
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
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i deduped.bam -q recal_data.table --algo QualCal -k $dbsnp -k $known_Mills_indels -k $known_1000G_indels recal_data.table.post
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt --algo QualCal --plot --before recal_data.table --after recal_data.table.post recal.csv
#$SENTIEON_INSTALL_DIR/bin/sentieon plot QualCal -o recal_plots.pdf recal.csv


### TNscope calling
# echo "$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.realigned.bam -q ${SampleName}.recal_data.table --algo TNscope --tumor_sample $sample --dbsnp $dbsnp ${SampleName}.b37.TNscope.vcf"
echo "TNScopt"
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i $realigned_bam -q $recal_data --algo TNscope --tumor_sample $sample --dbsnp $dbsnp $vcf

echo "MuTect2"
$gatk --java-options "-Xmx60g" Mutect2 -I $realigned_bam  -O $vcf_mu2 -R $fasta
