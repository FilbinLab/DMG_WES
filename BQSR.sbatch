#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-10:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=16G                          # Memory total in MB (for all cores)

module load gcc/6.2.0
module load samtools/1.3.1
module load picard/2.8.0
#module load gatk/4.0.0.0
module load gatk/4.1.9.0

## input: sample-name preprocessing-dir bqsr-dir reference-fa germline-mutations 

## Generate base recalibration table
srun -c 8 gatk BaseRecalibrator --input ${2}/${1}_AddReadGroup.bam \
--reference ${4} \
--known-sites ${5} \
--output ${3}/${1}_data.table

## Apply BQSR
srun -c 8 gatk ApplyBQSR \
   -R ${4} \
   -I ${2}/${1}_AddReadGroup.bam \
   --bqsr-recal-file ${3}/${1}_data.table \
   -O ${3}/${1}_BQSR.bam

## Index
srun -c 8 samtools index ${3}/${1}_BQSR.bam

## rm "${3}/${1}_MarkDuplicates.bam"
## rm "${3}/${1}_AddReadGroup.bam"

