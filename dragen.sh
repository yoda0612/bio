
ssh yoda670612@140.110.141.212
yoda670612/yoda670612@NTU
for i in {1..8};
do
  Alinger=dragen
  SampleName=SRR1307639${i}
  ref=hg19
  somatic_ref_dir=/staging/yoda670612/ref_hg19
  somatic_output_dir=/staging/yoda670612/output
  somatic_output_prefix=${SampleName}.${Alinger}.${ref}
  fasta=${somatic_ref_dir}/human_g1k_v37_decoy.fasta
  fastq_1=/staging/yoda670612/fastq/${SampleName}_1.fastq.gz
  fastq_2=/staging/yoda670612/fastq/${SampleName}_2.fastq.gz
  bam=/staging/yoda670612/bam/${SampleName}.${Alinger}.realigned.bam
  somatic_RGSM="SM_"${SampleName}
  somatic_RGID="GP_"${SampleName}

  dragen -r ${somatic_ref_dir} \
  --output-dir ${somatic_output_dir} \
  --output-file-prefix ${somatic_output_prefix} \
  --output-format BAM \
  --enable-map-align-output true \
  --vc-emit-ref-confidence GVCF \
  --vc-enable-vcf-output true \
  --repeat-genotype-enable true \
  --enable-duplicate-marking true \
  --remove-duplicates true \
  --tumor-fastq1 ${fastq_1}  \
  --tumor-fastq2 ${fastq_2} \
  --RGID-tumor ${somatic_RGID} \
  --RGSM-tumor ${somatic_RGSM} \
  --enable-variant-caller true \
  --enable-map-align true
done

for i in {1..8};
do
  i=0
  Alinger=hisat2
  SampleName=SRR1307639${i}
  ref=hg19
  somatic_ref_dir=/staging/yoda670612/ref_hg19
  somatic_output_dir=/staging/yoda670612/output
  somatic_output_prefix=${SampleName}.${Alinger}.${ref}.dragen
  fasta=${somatic_ref_dir}/human_g1k_v37_decoy.fasta
  fastq_1=/staging/yoda670612/fastq/${SampleName}_1.fastq.gz
  fastq_2=/staging/yoda670612/fastq/${SampleName}_2.fastq.gz
  bam=/staging/yoda670612/bam/${SampleName}.${Alinger}.${ref}.realigned.bam
  somatic_RGSM="SM_"${SampleName}
  somatic_RGID="GP_"${SampleName}
  dragen -f \
  -r ${somatic_ref_dir} \
  --output-dir ${somatic_output_dir} \
  --output-file-prefix ${somatic_output_prefix} \
  --tumor-bam-input  $bam \
  --enable-variant-caller true  \
  --enable-map-align false \
  --prepend-filename-to-rgid true
done

i=0
Alinger=bwa
SampleName=SRR1307639${i}
ref=hg19
somatic_ref_dir=/staging/yoda670612/ref_hg19
somatic_output_dir=/staging/yoda670612/output
somatic_output_prefix=${SampleName}.${Alinger}.${ref}.dragen
fasta=${somatic_ref_dir}/human_g1k_v37_decoy.fasta
fastq_1=/staging/yoda670612/fastq/${SampleName}_1.fastq.gz
fastq_2=/staging/yoda670612/fastq/${SampleName}_2.fastq.gz
bam=/staging/yoda670612/bam/${SampleName}.${Alinger}.${ref}.realigned.bam
somatic_RGSM="SM_"${SampleName}
somatic_RGID="GP_"${SampleName}


nohup dragen -f \
-r ${somatic_ref_dir} \
--output-dir ${somatic_output_dir} \
--output-file-prefix ${somatic_output_prefix} \
--tumor-bam-input  $bam \
--enable-variant-caller true  \
--enable-map-align false \
--prepend-filename-to-rgid true



nohup dragen -r ${somatic_ref_dir} \
--output-dir ${somatic_output_dir} \
--output-file-prefix ${somatic_output_prefix} \
--output-format BAM \
--enable-map-align-output true \
--vc-emit-ref-confidence GVCF \
--vc-enable-vcf-output true \
--repeat-genotype-enable true \
--enable-duplicate-marking true \
--remove-duplicates true \
--tumor-fastq1 ${fastq_1}  \
--tumor-fastq2 ${fastq_2} \
--RGID-tumor ${somatic_RGID} \
--RGSM-tumor ${somatic_RGSM} \
--enable-variant-caller true \
--enable-map-align true &

nohup dragen -r ${somatic_ref_dir} \
--output-dir ${somatic_output_dir} \
--output-file-prefix ${somatic_output_prefix} \
--output-format BAM \
--enable-map-align-output true \
--vc-emit-ref-confidence GVCF \
--vc-enable-vcf-output true \
--repeat-genotype-enable true \
--enable-duplicate-marking true \
--remove-duplicates true \
-1 ${fastq_1}  \
-2 ${fastq_2} \
--RGID ${somatic_RGID} \
--RGSM ${somatic_RGSM} \
--enable-variant-caller true \
--enable-map-align true &

dragen --build-hash-table true \
--ht-reference $fasta \
--output-directory $somatic_ref_dir

# --enable-sv true \
# --enable-hla true \
# --hla-bed-file /opt/edico/config/hla_exons_grch37.bed \
# --hla-reference-file /opt/edico/config/hla_classI_ref_freq.fasta \
# --hla-allele-frequency-file /opt/edico/config/hla_classI_allele_frequency.csv \
# --hla-tiebreaker-threshold 0.97 \
# --hla-zygosity-threshold 0.15
