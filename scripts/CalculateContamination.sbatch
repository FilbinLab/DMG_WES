#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-2:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=16G                          # Memory total in MB (for all cores)

module load gcc/6.2.0
module load samtools/1.3.1
module load gatk/4.0.0.0

## sample-name pileups-dir output.dir

gatk CalculateContamination -I ${2}/${1}_pileups.table -O ${3}/${1}_contamination.table

