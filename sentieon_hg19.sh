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
nt=40 #number of threads to use in computation
#fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
fastq_1=/staging/biology/yoda670612/${SampleName}_1.fastq
fastq_2=/staging/biology/yoda670612/${SampleName}_2.fastq
# Update with the location of the reference data files

dbsnp="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/dbsnp_138.hg19.vcf"
known_Mills_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19//Mills_and_1000G_gold_standard.indels.hg19.sites.vcf"
known_1000G_indels="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/1000G_phase1.indels.hg19.sites.vcf"

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
#($SENTIEON_INSTALL_DIR/bin/bwa mem -M -R "@RG\tID:$group\tSM:$sample\tPL:$platform" -t $nt -K 10000000 $fasta $fastq_1 $fastq_2 || echo -n 'error' ) | $SENTIEON_INSTALL_DIR/bin/sentieon util sort -r $fasta -o ${SampleName}.sorted.bam -t $nt --sam2bam -i-

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
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i ${SampleName}.sorted.bam --algo LocusCollector --fun score_info ${SampleName}.score.txt
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt -i ${SampleName}.sorted.bam --algo Dedup --rmdup --score_info ${SampleName}.score.txt --metrics ${SampleName}.dedup_metrics.txt ${SampleName}.deduped.bam


# ******************************************
# 4. Indel realigner
# ******************************************
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta  -t $nt -i ${SampleName}.deduped.bam --algo Realigner -k $known_Mills_indels -k $known_1000G_indels ${SampleName}.realigned.bam


# ******************************************
# 5. Base recalibration
# ******************************************
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.realigned.bam --algo QualCal -k $dbsnp -k $known_Mills_indels -k $known_1000G_indels ${SampleName}.recal_data.table
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i deduped.bam -q recal_data.table --algo QualCal -k $dbsnp -k $known_Mills_indels -k $known_1000G_indels recal_data.table.post
#$SENTIEON_INSTALL_DIR/bin/sentieon driver -t $nt --algo QualCal --plot --before recal_data.table --after recal_data.table.post recal.csv
#$SENTIEON_INSTALL_DIR/bin/sentieon plot QualCal -o recal_plots.pdf recal.csv




### TNscope calling
echo "$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.realigned.bam -q ${SampleName}.recal_data.table --algo TNscope --tumor_sample $sample --dbsnp $dbsnp ${SampleName}.hg19.TNscope.vcf"
$SENTIEON_INSTALL_DIR/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.realigned.bam -q ${SampleName}.recal_data.table --algo TNscope --tumor_sample $sample  --dbsnp $dbsnp ${SampleName}.hg19.TNscope.vcf
