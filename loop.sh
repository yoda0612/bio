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

for i in {1..8};
do
    sbatch -J "dg_${i}" ~/dragen_hg19.sh SRR1307639${i}
done

for lab in {1..3};
do
  for lib in {1..4};
  do
      echo "PanelX_LAB${lab}_LIB${lib}"
      sbatch -J "PanelX_LAB${lab}_LIB${lib}" ~/fda_align.sh PanelX_LAB${lab}_LIB${lib}

  done
done



#VCF Normalize
for i in {0..8};
do
  gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
  folder=seq2_dragmap
  aligner=dragmap
  caller="deepvariant"
  input_vcf_gz=/staging/biology/yoda670612/${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcf.gz
  input_vcf=/staging/biology/yoda670612/${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcf
  output_vcf=/staging/biology/yoda670612/${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.vcf
  fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta

  zcat $input_vcf_gz > $input_vcf
  #$gatk IndexFeatureFile -I $input_vcf
  $gatk LeftAlignAndTrimVariants \
  -R $fasta \
    -V $input_vcf \
    -O $output_vcf
done

#Mutect2 and deepvariant fix line problem
for i in {0..8};
do
  folder=seq2_dragmap
  aligner=dragmap
  caller=deepvariant
  gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
  input_vcf=/staging/biology/yoda670612/${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.vcf
  output_vcf=/staging/biology/yoda670612/${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.lined.vcf
  python ~/fix_deepvariant_vcf.py $input_vcf $output_vcf
  $gatk IndexFeatureFile -I $output_vcf
done

#SelectVariants
for i in {0..8};
do
  folder=seq2_dragmap
  aligner=dragmap
  caller=deepvariant
  gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
  input_vcf=/staging/biology/yoda670612/${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.lined.vcf
  output_vcf=/staging/biology/yoda670612/${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf
  interval=/staging/biology/yoda670612/truth/CTR_hg19.interval_list
  fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
  $gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval
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


gatk=/opt/ohpc/Taiwania3/pkg/biology/GATK/gatk_v4.2.3.0/gatk
input_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.vcfnormed.vcf
output_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.vcfnormed.selected.vcf
interval=/staging/biology/yoda670612/truth/CTR_hg19.interval_list
fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
$gatk SelectVariants -V $input_vcf -O $output_vcf -R $fasta -L $interval

p=ngs12G
c=3
mem=12G
caller=TNscope
for i in {0..8};
do
  # aligner=bwa
  # folder=seq2_bwa
  # sbatch -J "ann_bw_${i}" -p $p -c $c --mem=$mem ~/run_annotation_hg19.sh SRR1307639${i} ${aligner} ${caller} ${folder}

  aligner=bowtie2
  folder=seq2_bw2
  sbatch -J "ann_bw_${i}" -p $p -c $c --mem=$mem ~/run_annotation_hg19.sh SRR1307639${i} ${aligner} ${caller} ${folder}

  aligner=dragen
  folder=seq2_dragen
  sbatch -J "ann_dr_${i}" -p $p -c $c --mem=$mem ~/run_annotation_hg19.sh SRR1307639${i} ${aligner} ${caller} ${folder}

  aligner=dragmap
  folder=seq2_dragmap
  sbatch -J "ann_dg_${i}" -p $p -c $c --mem=$mem ~/run_annotation_hg19.sh SRR1307639${i} ${aligner} ${caller} ${folder}

  aligner=hisat2
  folder=seq2_hisat2
  sbatch -J "ann_h2_${i}" -p $p -c $c --mem=$mem ~/run_annotation_hg19.sh SRR1307639${i} ${aligner} ${caller} ${folder}

done


caller=TNscope

for i in {0..8};
do
  # aligner=bwa
  # folder=seq2_bwa
  # mv ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf
  # sed '/bnd/d' ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf > ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf

  aligner=bowtie2
  folder=seq2_bw2
  mv ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf
  sed '/bnd/d' ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf > ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf

  aligner=dragen
  folder=seq2_dragen
  mv ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf
  sed '/bnd/d' ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf > ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf

  aligner=dragmap
  folder=seq2_dragmap
  mv ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf
  sed '/bnd/d' ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf > ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf

  aligner=hisat2
  folder=seq2_hisat2
  mv ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf
  sed '/bnd/d' ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected_bnd.vcf > ${folder}/SRR1307639${i}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf

done
