#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-8:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=16G                          # Memory total in MB (for all cores)

module load gatk/4.0.0.0

gatk Mutect2 --reference ~/genome/human/hg19_fasta_gtf/genome_hg19.fa \
--input ${2}/${1}_BQSR.bam \
--germline-resource ${4} \
--panel-of-normals ${5} \
--output ${3}/${1}.vcf.gz \
--tumor-sample ${1} \
--af-of-alleles-not-in-resource ${6}
	
