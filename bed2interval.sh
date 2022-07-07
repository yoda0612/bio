#!/usr/bin/bash
#SBATCH -A MST109178        # Account name/staging number
#SBATCH -J interval         # Job name
#SBATCH -p ngs48G           # Partition Name
#SBATCH -c 14               # core preserved
#SBATCH --mem=46G           # memory used
#SBATCH -o out.log          # Path to the standard output file
#SBATCH -e err.log          # Path to the standard error ouput file
#SBATCH --mail-user=
#SBATCH --mail-type=FAIL


FOLDER=/staging/biology/peimiao0322/A1_Panel
Sample_ID=XXXX
DATE=20210309_GJB2_SLC26A4_MYO15A_OTOF_MT
### Bed file is from
#BED=/staging/reserve/paylong_ntu/AI_SHARE/shared_scripts/A1_Panel/DF_IDT_v2.bed
BED=/staging/biology/yoda670612/truth/CTR_hg19.bed
BED37=/staging/biology/yoda670612/truth/CTR_hg19.b37.bed
BEDPANELA=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/PanelA.b37.bed
BEDPANELB=/staging/reserve/paylong_ntu/AI_SHARE/Pipeline/FDA_oncopanel/PanelB.b37.bed

GATK=/staging/reserve/paylong_ntu/AI_SHARE/software/GATK/GenomeAnalysisTK-3.6/GenomeAnalysisTK.jar
PICARD=/opt/ohpc/Taiwania3/pkg/biology/Picard/picard_v2.26.0/picard.jar
#CHAIN=/staging/reserve/paylong_ntu/AI_SHARE/reference/Liftover/hg19ToHg38.over.chain.gz
CHAIN=/staging/reserve/paylong_ntu/AI_SHARE/reference/Liftover/b37ToHg38.over.chain
########################################################################################################
B37=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.fasta
B37_SD=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/b37/human_g1k_v37_decoy.dict
HG19=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.fasta
HG19_SD=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg19/ucsc.hg19.dict
HG38=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg38/Homo_sapiens_assembly38.fasta
HG38_SD=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg38/Homo_sapiens_assembly38.dict
A1_HG19=/staging/reserve/paylong_ntu/AI_SHARE/reference/hg19.NC_012920/ucsc.hg19.NC_012920.fasta
A1_HG19_SD=/staging/reserve/paylong_ntu/AI_SHARE/reference/hg19.NC_012920/ucsc.hg19.NC_012920.dict

###
#cd ${FOLDER}
### To transform bed file to interval_list
### interval list for b37, g1k_v37_decoy
java -jar ${PICARD} BedToIntervalList I=${BEDPANELB} O=/staging/biology/yoda670612/truth/PanelB.b37.interval_list SD=${B37_SD}

#java -jar ${PICARD} BedToIntervalList I=${BED37} O=/staging/biology/yoda670612/truth/CTR_hg19.b37.interval_list SD=${B37_SD}
### interval list for A1 previous ucsc.hg19.NC_012920.fasta reference
#java -jar ${PICARD} BedToIntervalList I=${BED} O=${FOLDER}/Deafness_bed/${DATE}.A1_hg19.interval_list SD=${A1_HG19_SD}

### To liftover interval_list from hg19 to hg38
#java -jar ${PICARD} LiftOverIntervalList I=${FOLDER}/Deafness_bed/${DATE}.b37.interval_list O=${FOLDER}/Deafness_bed/${DATE}.hg38.interval_list SD=${HG38_SD} CHAIN=${CHAIN}
