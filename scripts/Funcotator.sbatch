#!/bin/bash
#SBATCH -c 8                               # Request one core
#SBATCH -N 1                               # Request one node (if you request more than one core with -c, also using
                                           # -N 1 means all cores will be on the same node)
#SBATCH -t 0-10:00                         # Runtime in D-HH:MM format
#SBATCH -p short                           # Partition to run in
#SBATCH --mem=5G                          # Memory total in MB (for all cores)

module load gcc/6.2.0
module load samtools/1.3.1
module load gatk/4.1.9.0
#module load gatk/4.0.0.0

## sample-name vcf-dir ref-fa output-dir data-source-dir 

## NOTE: as of 08/10/22, ".vcf" changed to ".vcf.gz"
gatk Funcotator --variant ${2}/${1}.vcf.gz  \
--reference ${3} \
--ref-version hg19 \
--data-sources-path ${5} \
--output ${4}/${1}.funcotated.maf \
--output-file-format MAF \
--remove-filtered-variants \
--disable-sequence-dictionary-validation  
# --force-b37-to-hg19-reference-contig-conversion ## added on 08/10/22
