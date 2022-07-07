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


for lab in {1..3};
do
  for lib in {1..4};
  do
      echo "PanelA_LAB${lab}_LIB${lib}"
      sbatch -J "PanelA_LAB${lab}_LIB${lib}" ~/fda_align.sh PanelA_LAB${lab}_LIB${lib}
      # sample="PanelB_LAB${lab}_LIB${lib}"
      # python b37tohg19.py $workdir/$sample.b37.TNscope.vcf $workdir/$sample.hg19.TNscope.vcf
  done
done

for lab in {1..3};
do
  for lib in {1..4};
  do
       python ../PycharmProjects/pythonProject/fix_mutect2_vcf3.py PanelB_LAB${lab}_LIB${lib}.dragmap.b37.Mutect2.dl.vcf PanelB_LAB${lab}_LIB${lib}.dragmap.b37.Mutect2.vcf
  done
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

    input_vcf=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/PanelB_LAB${lab}_LIB${lib}.dragmap.b37.Mutect2.vcf
    output_vcf=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/PanelB_LAB${lab}_LIB${lib}.dragmap.b37.Mutect2.selected.vcf
    fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
    interval=/staging/biology/yoda670612/truth/PanelB.b37.interval_list
    sbatch -A MST109178 -J $job_name  -p $p -c $c --mem=$mem -o %j.out -e %j.log \
    --mail-user=cycheng1978@g.ntu.edu.tw --mail-type=FAIL,END \
    --wrap="$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval "

  done
done


$gatk IndexFeatureFile -I $input_vcf
