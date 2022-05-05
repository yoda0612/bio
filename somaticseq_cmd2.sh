/opt/somaticseq/somaticseq/run_somaticseq.py \
--output-directory /volume/cyvolume/somaticseq/output/truth_set \
--genome-reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
--inclusion-region /volume/cyvolume/somaticseq/CTR_hg19.b37.bed \
--dbsnp-vcf /volume/cyvolume/somaticseq/dbsnp_138.b37.vcf \
--algorithm xgboost \
--somaticseq-train \
--truth-snv /volume/cyvolume/somaticseq/KP_snvs.sorted.vcf \
--truth-indel /volume/cyvolume/somaticseq/KP_indels.sorted.vcf \
single \
--bam-file  /volume/cyvolume/somaticseq/SRR13076390.realigned.bam \
--arbitrary-snvs /volume/cyvolume/somaticseq/KP_snvs.sorted.vcf \
--arbitrary-indels /volume/cyvolume/somaticseq/KP_indels.sorted.vcf


sample="SM_SRR13076390"
group="GP_SRR13076390"
platform="ILLUMINA"

makeAlignmentScripts.py \
--output-directory /volume/cyvolume/somaticseq/bam \
--in-fastq1s       /volume/cyvolume/somaticseq/fastq/SRR13076390_1.fastq \
--in-fastq2s       /volume/cyvolume/somaticseq/fastq/SRR13076390_2.fastq \
--genome-reference /volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
--out-bam          SRR13076390.trimmed.aligned.marked_dup.bam \
--bam-header       '@RG\tID:$group\tSM:$sample\tPL:$platform' \
--run-trimming  \
--run-alignment \
--run-mark-duplicates --parallelize-markdup \
--run-workflow
