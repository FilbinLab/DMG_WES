#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-10:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=16G                          # Memory total in MB (for all cores)

## module load gatk/4.0.0.0
module load gatk/4.1.9.0

gatk Mutect2 -R ${4} \
-I ${2}/${1}_BQSR.bam \
-tumor ${1} \
--germline-resource ${5} \
-O ${3}/${1}.vcf.gz \

