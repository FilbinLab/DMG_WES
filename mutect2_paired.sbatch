#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-8:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=16G                          # Memory total in MB (for all cores)

## input: tumor-bam tumor-name normal-bam normal-name germline-vcf PoN Ref-fa af-of-alleles-not-in-resource output-dir

## module load gatk/4.0.0.0
module load gatk/4.1.9.0

gatk Mutect2 --reference ${7} \
--input ${1} \
-tumor ${2} \
--input ${3} \
-normal ${4} \
--germline-resource ${5} \
--panel-of-normals ${6} \
-O ${8}/${2}_${4}.vcf.gz	
## --af-of-alleles-not-in-resource ${8}
