#!/bin/bash
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J SRR      # Job name
#SBATCH -p ngs7G            # Partiotion name
#SBATCH -n 1                # Number of MPI tasks (i.e. processes)
#SBATCH -c 2                # Number of cores per MPI task
#SBATCH -N 1                # Maximum number of nodes to be allocated
#SBATCH --mem=7G
#SBATCH -o %j.out           # Path to the standard output file
#SBATCH -e %j.err           # Path to the standard error ouput file
echo "/opt/ohpc/Taiwania3/pkg/biology/BWA/BWA_v0.7.17/bwa  mem genome.fa  /staging/biology/yoda670612/SRR1307639$1.fastq > /staging/biology/yoda670612/$1.sam"
/opt/ohpc/Taiwania3/pkg/biology/BWA/BWA_v0.7.17/bwa  mem genome.fa  /staging/biology/yoda670612/SRR1307639$1.fastq > /staging/biology/yoda670612/$1.sam
