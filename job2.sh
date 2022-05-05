#!/bin/bash
#SBATCH -A MST109178        # Account name/project number
#SBATCH -J testtttt      # Job name
#SBATCH -p ngs7G            # Partiotion name
#SBATCH -n 1                # Number of MPI tasks (i.e. processes)
#SBATCH -c 2                # Number of cores per MPI task
#SBATCH -N 1                # Maximum number of nodes to be allocated
#SBATCH --mem=7G
#SBATCH -o %j.out           # Path to the standard output file
#SBATCH -e %j.err           # Path to the standard error ouput file

echo "This job2"
