#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-12:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=16G                          # Memory total in MB (for all cores)

module load gcc/6.2.0
module load bwa/0.7.15
module load samtools/1.3.1

bwa mem -t 8 \
${3} \
${1} ${2} \
> ${5}.sam

samtools sort -@ 4 -O bam -o ${5}.bam ${5}.sam

rm "${5}.sam"

