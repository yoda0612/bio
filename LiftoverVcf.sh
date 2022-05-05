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
PICARD=/opt/ohpc/Taiwania3/pkg/biology/Picard/picard_v2.26.0/picard.jar

fasta=/staging/reserve/paylong_ntu/AI_SHARE/reference/GATK_bundle/2.8/hg38/Homo_sapiens_assembly38.fasta
input_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg19.vcf.gz
output_vcf=/staging/biology/yoda670612/truth/KnownPositives_hg38_Liftover.vcf
REJECT=/staging/biology/yoda670612/truth/KnownPositives_hg38_Liftover.reject.vcf
#CHAIN=/staging/reserve/paylong_ntu/AI_SHARE/reference/Liftover/hg19toHg18.chain
CHAIN=/staging/reserve/paylong_ntu/AI_SHARE/reference/Liftover/hg19ToHg38.over.chain.gz

java -jar ${PICARD} LiftoverVcf I=$input_vcf O=$output_vcf R=$fasta REJECT=$REJECT CHAIN=${CHAIN}
