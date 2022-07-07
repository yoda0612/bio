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
aligner="dragmap"
SENTIEON_INSTALL_DIR="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-202112"
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk

nt=40 #number of threads to use in computation
workdir=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
fastq_1=$workdir/${SampleName}_R1.fastq.gz
fastq_2=$workdir/${SampleName}_R2.fastq.gz
sam=$workdir/${SampleName}.${aligner}.sam
sorted_bam=$workdir/${SampleName}.${aligner}.sorted.bam
deduped_bam=$workdir/${SampleName}.${aligner}.deduped.bam
score_info=$workdir/${SampleName}.${aligner}.score.txt
dedup_metrics=$workdir/${SampleName}.${aligner}.dedup_metrics.txt
realigned_bam=$workdir/${SampleName}.${aligner}.realigned.bam
recal_data=$workdir/${SampleName}.${aligner}.recal_data.table
vcf=$workdir/${SampleName}.${aligner}.b37.TNscope.vcf
vcf_mu2=$workdir/${SampleName}.${aligner}.b37.Mutect2.vcf

# Update with the location of the reference data files

dbsnp="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/dbsnp_138.b37.vcf"
known_Mills_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/Mills_and_1000G_gold_standard.indels.b37.vcf"
known_1000G_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/1000G_phase1.indels.b37.vcf"

printf "#############################################################################\n"
printf "###                  Work started:   $(date +%Y-%m-%d:%H:%M:%S)           ###\n"
printf "#############################################################################\n"
#!/bin/sh
# *******************************************
# Script to perform DNA seq variant calling
# using a single sample with fastq files
# named 1.fastq.gz and 2.fastq.gz
# *******************************************




# Update with the location of the Sentieon software package and license file
# export SENTIEON_INSTALL_DIR=/home/release/sentieon-genomics-202010
# export SENTIEON_LICENSE=/home/Licenses/Sentieon.lic

# Other settings
#nt=$(nproc) #number of threads to use in computation, set to number of cores in the server
# workdir="$PWD/test/DNAseq" #Determine where the output files will be stored

# ******************************************
# 0. Setup
# ******************************************
# mkdir -p $workdir
# logfile=$workdir/run.log
# exec >$logfile 2>&1
# cd $workdir

# ******************************************
# 1. Mapping reads with BWA-MEM, sorting
# ******************************************
#The results of this call are dependent on the number of threads used. To have number of threads independent results, add chunk size option -K 10000000
cat $sam | $SENTIEON_INSTALL_DIR/bin/sentieon util sort -r $fasta -o $sorted_bam -t $nt --sam2bam -i -


#用不到
# ******************************************
# 2. Metrics
# ******************************************
# $SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i sorted.bam --algo MeanQualityByCycle mq_metrics.txt --algo QualDistribution qd_metrics.txt --algo GCBias --summary gc_summary.txt gc_metrics.txt --algo AlignmentStat --adapter_seq '' aln_metrics.txt --algo InsertSizeMetricAlgo is_metrics.txt
# $SENTIEON_INSTALL_DIR/bin/sentieon plot GCBias -o gc-report.pdf gc_metrics.txt
# $SENTIEON_INSTALL_DIR/bin/sentieon plot QualDistribution -o qd-report.pdf qd_metrics.txt
# $SENTIEON_INSTALL_DIR/bin/sentieon plot MeanQualityByCycle -o mq-report.pdf mq_metrics.txt
# $SENTIEON_INSTALL_DIR/bin/sentieon plot InsertSizeMetricAlgo -o is-report.pdf is_metrics.txt

# ******************************************
# 3. Remove Duplicate Reads. It is possible
# to mark instead of remove duplicates
# by ommiting the --rmdup option in Dedup
# ******************************************
$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i $sorted_bam --algo LocusCollector --fun score_info $score_info
$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i $sorted_bam --algo Dedup --rmdup --score_info $score_info --metrics $dedup_metrics $deduped_bam


# ******************************************
# 4. Indel realigner
# ******************************************
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta  -t $nt -i $deduped_bam --algo Realigner -k $known_Mills_indels -k $known_1000G_indels $realigned_bam


# ******************************************
# 5. Base recalibration
# ******************************************
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i $realigned_bam --algo QualCal -k $dbsnp -k $known_Mills_indels -k $known_1000G_indels $recal_data
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i deduped.bam -q recal_data.table --algo QualCal -k $dbsnp -k $known_Mills_indels -k $known_1000G_indels recal_data.table.post
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt --algo QualCal --plot --before recal_data.table --after recal_data.table.post recal.csv
#$SENTIEON_INSTALL_DIR/bin/sentieon plot QualCal -o recal_plots.pdf recal.csv


### TNscope calling
# echo "$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.realigned.bam -q ${SampleName}.recal_data.table --algo TNscope --tumor_sample $sample --dbsnp $dbsnp ${SampleName}.b37.TNscope.vcf"
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i $realigned_bam -q $recal_data --algo TNscope --tumor_sample $sample --dbsnp $dbsnp $vcf
$gatk --java-options "-Xmx40g" Mutect2 -I $realigned_bam  -O $vcf_mu2 -R $fasta
