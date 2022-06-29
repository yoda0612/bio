/opt/deepvariant/bin/run_deepvariant \
  --model_type=WES \
  --ref=/volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --reads=/volume/cyvolume/somaticseq/SRR13076390.realigned.bam \
  --output_vcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.deepvariant.vcf.gz \
  --output_gvcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.deepvariant.g.vcf.gz \
  --num_shards=4


  /opt/deepvariant/bin/run_deepvariant \
    --model_type=WES \
    --ref=/volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
    --reads=/volume/cyvolume/SRR13076390.dragmap.realigned.bam \
    --output_vcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.dragmap.deepvariant.vcf.gz \
    --output_gvcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.dragmap.deepvariant.g.vcf.gz \
    --num_shards=40
