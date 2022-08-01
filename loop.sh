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

workdir=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel

for i in {0..8};
do
    sbatch -J "bwa_${i}" ~/bwa_hg19.sh SRR1307639${i}
done

for lab in {1..3};
do
  for lib in {1..4};
  do
      echo "PanelX_LAB${lab}_LIB${lib}"
      sbatch -J "PanelX_LAB${lab}_LIB${lib}" ~/fda_align.sh PanelX_LAB${lab}_LIB${lib}

  done
done

for i in {5..6};
do
  i=5
  sbatch -J "SRR1307639${i}" ~/fda_align.sh SRR1307639${i}
done

for lab in {1..3};
do
  for lib in {1..3};
  do

       gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
       input_vcf=/staging/biology/yoda670612/fda_x/PanelX_LAB${lab}_LIB${lib}.dragmap.hg19.Mutect2.selected.vcfnormed.vcf
       output_vcf=/staging/biology/yoda670612/fda_x/PanelX_LAB${lab}_LIB${lib}.dragmap.hg19.Mutect2.selected.vcfnormed.lined.vcf
       python ~/fix_mutect2_vcf3.py $input_vcf $output_vcf
       $gatk IndexFeatureFile -I $output_vcf
  done
done

for i in {6..8};
do
  gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
  input_vcf=/staging/biology/yoda670612/seq2/SRR1307639${i}.dragmap.hg19.Mutect2.selected.vcfnormed.vcf
  output_vcf=/staging/biology/yoda670612/seq2/SRR1307639${i}.dragmap.hg19.Mutect2.selected.vcfnormed.lined.vcf
  python ~/fix_mutect2_vcf3.py $input_vcf $output_vcf
  $gatk IndexFeatureFile -I $output_vcf
done


p=ngs12G
c=3
mem=12G
gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk

for lab in {1..3};
do
  for lib in {1..4};
  do
    job_name="sel_LAB${lab}_LIB${lib}"

    input_vcf=/staging/biology/yoda670612/PanelA_LAB${lab}_LIB${lib}.dragmap.b37.Mutect2.vcf
    output_vcf=/staging/biology/yoda670612/PanelA_LAB${lab}_LIB${lib}.dragmap.b37.Mutect2.selected.vcf
    fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
    interval=/staging/biology/yoda670612/truth/PanelA.b37.interval_list
    sbatch -A MST109178 -J $job_name  -p $p -c $c --mem=$mem -o %j.out -e %j.log \
    --mail-user=cycheng1978@g.ntu.edu.tw --mail-type=FAIL,END \
    --wrap="$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval"

  done
done

$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval
$gatk IndexFeatureFile -I $input_vcf
