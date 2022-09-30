#!/bin/bash
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SRR      # Job name
#SBATCH -p ngs1gpu           # Partition Name
#SBATCH -c 6               # core preserved
#SBATCH --mem=90G           # memory used
#SBATCH --gres=gpu:1        # 使用的GPU數 請參考Queue資源設定
#SBATCH -o %j.out          # Path to the standard output file
#SBATCH -e %j.log          # Path to the standard error ouput file
#SBATCH --mail-user=cycheng1978@g.ntu.edu.tw
#SBATCH --mail-type=FAIL

i=0
alinger=bwa
module load libs/singularity/3.7.1
singularity run --nv -B /staging/biology/yoda670612/deepvariant_test:/staging/biology/yoda670612/deepvariant_test \
/opt/ohpc/Taiwania3/pkg/biology/DeepVariant/deepvariant_1.4.0-gpu.sif \
/opt/deepvariant/bin/run_deepvariant \
--model_type=WES \
--ref=/staging/biology/yoda670612/deepvariant_test/ucsc.hg19.fasta \
--reads=/staging/biology/yoda670612/deepvariant_test/SRR1307639${i}.${alinger}.hg19.realigned.bam \
--output_vcf=/staging/biology/yoda670612/deepvariant_test/SRR1307639${i}.${alinger}.hg19.deepvariant.vcf.gz \
--output_gvcf=/staging/biology/yoda670612/deepvariant_test/SRR1307639${i}.${alinger}.hg19.deepvariant.vcf.g.vcf.gz \
