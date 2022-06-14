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
      echo "PanelB_LAB${lab}_LIB${lib}"
      sbatch -J "PanelB_LAB${lab}_LIB${lib}" ~/fda_align.sh PanelB_LAB${lab}_LIB${lib}
      # sample="PanelB_LAB${lab}_LIB${lib}"
      # python b37tohg19.py $workdir/$sample.b37.TNscope.vcf $workdir/$sample.hg19.TNscope.vcf
  done
done

for i in {3..8};
do
job_name="f"${i}
p=ngs12G
c=3
mem=12G
sbatch -A MST109178 -J $job_name  -p $p -c $c --mem=$mem -o %j.out -e %j.log \
--mail-user=cycheng1978@g.ntu.edu.tw --mail-type=FAIL,END \
--wrap="gzip SRR1307639${i}_1.fastq"

done
