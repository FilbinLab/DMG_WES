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

## input: sample-name input-dir preprocessing-dir 

## Mark duplicates

srun -c 8 java -Xmx8G -jar $PICARD/picard-2.8.0.jar MarkDuplicates \
INPUT=${2}/${1}.genome.bam \
OUTPUT=${3}/${1}_MarkDuplicates.bam \
METRICS_FILE=${3}/${1}_MD_metrics.txt \
ASSUME_SORTED=true \
VALIDATION_STRINGENCY=SILENT

## Add read groups
srun -c 8 java -jar $PICARD/picard-2.8.0.jar AddOrReplaceReadGroups \
I=${3}/${1}_MarkDuplicates.bam \
O=${3}/${1}_AddReadGroup.bam \
RGID=${1} \
RGLB=${1} \
RGPL=ILLUMINA \
RGPU=${1} \
RGSM=${1}	

## Index
srun -c 8 samtools index ${3}/${1}_AddReadGroup.bam

