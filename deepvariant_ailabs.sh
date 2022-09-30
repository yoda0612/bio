/opt/deepvariant/bin/run_deepvariant \
  --model_type=WES \
  --ref=/volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --reads=/volume/cyvolume/somaticseq/SRR13076390.realigned.bam \
  --output_vcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.deepvariant.vcf.gz \
  --output_gvcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.deepvariant.g.vcf.gz \
  --num_shards=4
for i in {3..5};
do
  alinger=hisat2
  folder=seq2_hisat2
  /opt/deepvariant/bin/run_deepvariant \
    --model_type=WES \
    --ref=/volume/cyvolume/ucsc.hg19.fasta \
    --reads=/volume/cyvolume/${folder}/SRR1307639${i}.${alinger}.hg19.realigned.bam \
    --output_vcf=/volume/cyvolume/${folder}/SRR1307639${i}.${alinger}.hg19.deepvariant.vcf.gz \
    --output_gvcf=/volume/cyvolume/${folder}/SRR1307639${i}.${alinger}.hg19.deepvariant.vcf.g.vcf.gz \
    --num_shards=4
done


1=dragen 0~4
2=hisat2 3~5
3=hisat2 0~2
