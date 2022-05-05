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

release_dir="/staging/reserve/paylong_ntu/AI_SHARE/software/Sentieon/sentieon-genomics-201808"
nt=40 #number of threads to use in computation
fasta=/home/yoda670612/genome.fasta
fastq_1=/staging/biology/yoda670612/${SampleName}_1.fastq
fastq_2=/staging/biology/yoda670612/${SampleName}_2.fastq

printf "#############################################################################\n"
printf "###                  Work started:   $(date +%Y-%m-%d:%H:%M:%S)           ###\n"
printf "#############################################################################\n"

echo "($release_dir/bin/bwa mem -M -R "@RG\tID:$group\tSM:$sample\tPL:$platform" -t $nt -K 10000000 $fasta $fastq_1 $fastq_2 || echo -n 'error' ) | $release_dir/bin/sentieon util sort -r $fasta -o ${SampleName}.sorted.bam -t $nt --sam2bam -i-"
($release_dir/bin/bwa mem -M -R "@RG\tID:$group\tSM:$sample\tPL:$platform" -t $nt -K 10000000 $fasta $fastq_1 $fastq_2 || echo -n 'error' ) | $release_dir/bin/sentieon util sort -r $fasta -o ${SampleName}.sorted.bam -t $nt --sam2bam -i-

# ******************************************
# Remove Duplicate Reads
# ******************************************
echo "$release_dir/bin/sentieon driver  -t $nt -i ${SampleName}.sorted.bam --algo LocusCollector --fun score_info ${SampleName}.score.txt"
$release_dir/bin/sentieon driver  -t $nt -i ${SampleName}.sorted.bam --algo LocusCollector --fun score_info ${SampleName}.score.txt

echo "$release_dir/bin/sentieon driver  -t $nt -i ${SampleName}.sorted.bam --algo Dedup --rmdup --score_info ${SampleName}.score.txt --metrics ${SampleName}.dedup_metrics.txt ${SampleName}.deduped.bam"
$release_dir/bin/sentieon driver  -t $nt -i ${SampleName}.sorted.bam --algo Dedup --rmdup --score_info ${SampleName}.score.txt --metrics ${SampleName}.dedup_metrics.txt ${SampleName}.deduped.bam

echo "$release_dir/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.deduped.bam --algo QualCal ${SampleName}.recal_data.table"
$release_dir/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.deduped.bam --algo QualCal ${SampleName}.recal_data.table

echo "$release_dir/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.deduped.bam -q ${SampleName}.recal_data.table --algo TNscope --tumor_sample $sample ${SampleName}.vcf"
$release_dir/bin/sentieon driver -r $fasta -t $nt -i ${SampleName}.deduped.bam -q ${SampleName}.recal_data.table --algo TNscope --tumor_sample $sample ${SampleName}.vcf
