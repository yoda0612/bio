
for lab in {1..3};
do
  for lib in {1..3};
  do
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
input_vcf=/staging/biology/yoda670612/fda_x/PanelX_LAB${lab}_LIB${lib}.dragmap.hg19.Mutect2.selected.vcf
output_vcf=/staging/biology/yoda670612/fda_x/PanelX_LAB${lab}_LIB${lib}.dragmap.hg19.Mutect2.selected.vcfnormed.vcf

$gatk LeftAlignAndTrimVariants \
-R $fasta \
  -V $input_vcf \
  -O $output_vcf
done
done

for i in {6..8};
do
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
input_vcf=/staging/biology/yoda670612/seq2/SRR1307639${i}.dragmap.hg19.Mutect2.selected.vcf
output_vcf=/staging/biology/yoda670612/seq2/SRR1307639${i}.dragmap.hg19.Mutect2.selected.vcfnormed.vcf
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
$gatk LeftAlignAndTrimVariants \
-R $fasta \
  -V $input_vcf \
  -O $output_vcf
done


gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
input_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.vcf
output_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.vcfnormed.vcf
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
$gatk LeftAlignAndTrimVariants \
-R $fasta \
  -V $input_vcf \
  -O $output_vcf
