/opt/deepvariant/bin/run_deepvariant \
  --model_type=WES \
  --ref=/volume/cyvolume/somaticseq/human_g1k_v37_decoy.fasta \
  --reads=/volume/cyvolume/somaticseq/SRR13076390.realigned.bam \
  --output_vcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.deepvariant.vcf.gz \
  --output_gvcf=/volume/cyvolume/deepvariant/vcf/SRR13076390.deepvariant.g.vcf.gz \
  --num_shards=4
for i in {0..8};
do
  alinger=bwa
  folder=seq2_bwa
  /opt/deepvariant/bin/run_deepvariant \
    --model_type=WES \
    --ref=/volume/cyvolume/ucsc.hg19.fasta \
    --reads=/volume/cyvolume/${folder}/SRR1307639${i}.${alinger}.hg19.realigned.bam \
    --output_vcf=/volume/cyvolume/${folder}/SRR1307639${i}.${alinger}.hg19.deepvariant.vcf.gz \
    --output_gvcf=/volume/cyvolume/${folder}/SRR1307639${i}.${alinger}.hg19.deepvariant.vcf.g.vcf.gz \
    --num_shards=40
done
