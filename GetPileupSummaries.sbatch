#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 6-00:00                         # Runtime in D-HH:MM format
#SBATCH -p long                           # Partition to run in
#SBATCH --mem=150G                          # Memory total in MB (for all cores)

module load gatk/4.0.0.0
## module load gatk/4.1.9.0

## input: bam germline-vcf sample-name output-dir

gatk --java-options "-Xmx50G" GetPileupSummaries \
-I ${1} \
-V ${2} \
-L ${2} \
-O ${4}/${3}_pileups.table

