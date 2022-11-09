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

SampleName=$1
aligner=$2
caller=$3
folder=$4
mystaging=/staging/biology/yoda670612
INPUT=${mystaging}/${folder}/${SampleName}.${aligner}.hg19.${caller}.vcfnormed.selected.vcf
Decom_vcf=${mystaging}/${folder}/${SampleName}.${aligner}.hg19.${caller}.vcfnormed.selected.decom.vcf
Decom_norm_vcf=${mystaging}/${folder}/${SampleName}.${aligner}.hg19.${caller}.vcfnormed.selected.decom_norm.vcf

wkdir="/staging/reserve/paylong_ntu/AI_SHARE/GitHub/ANNOTATION/ANNOVAR/"
para=${SampleName}.${aligner}.hg19.${caller}

### DO NOT CHANGE
REF="/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta"
ANNOVAR="/opt/ohpc/Taiwania3/pkg/biology/ANNOVAR/annovar_20210819/table_annovar.pl"
humandb="/staging/reserve/paylong_ntu/AI_SHARE/reference/annovar_2016Feb01/humandb"



/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools norm -m- $INPUT -O z -o $Decom_vcf
/opt/ohpc/Taiwania3/pkg/biology/BCFtools/bcftools_v1.13/bin/bcftools norm -f $REF $Decom_vcf -O z -o $Decom_norm_vcf

$ANNOVAR $Decom_norm_vcf $humandb -buildver hg19 -out ${para} -remove -protocol refGene,cytoBand,knownGene,ensGene -operation gx,r,gx,gx -nastring . -vcfinput -polish
#head -n 1 ${para}.hg19_multianno.txt > ${para}.filtered_annotation.txt
#grep -P "\texonic\t" ${para}.hg19_multianno.txt | grep -P -v "\tsynonymous" >> ${para}.filtered_annotation.txt
#grep -e exonic -e splicing ${para}.hg19_multianno.txt | grep -P -v "\tsynonymous" | grep -P -v "\tncRNA_exonic\t" >> ${para}.filtered_annotation.txt
#done</work2/u1067478/Annotation/CGMH_AML/CGMH_AML_NameList.txt
#rm ${para}.avinput ${para}.decom_hg19.norm.vcf.gz ${para}.decom_hg19.vcf.gz ${para}.hg19_multianno.vcf
