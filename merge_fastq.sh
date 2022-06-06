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

cat SRR13076390_1.fastq SRR13076391_1.fastq SRR13076392_1.fastq SRR13076393_1.fastq SRR13076394_1.fastq SRR13076395_1.fastq SRR13076396_1.fastq SRR13076397_1.fastq > Merged1.fastq
cat SRR13076390_2.fastq SRR13076391_2.fastq SRR13076392_2.fastq SRR13076393_2.fastq SRR13076394_2.fastq SRR13076395_2.fastq SRR13076396_2.fastq SRR13076397_2.fastq > Merged2.fastq
