#!/bin/bash

if [[ ${#} -ne 5 ]]
then 
        echo "usage: source mutect2-batch.sh BQSR_DIR MUTECT2_DIR GERMLINE_VCF PoN_VCF af_of_alleles_not_in_resource"
        exit 1
fi 

## --af-of-alleles-not-in-resource default is 0.001 
## Mutect2 recommends setting to 1/(2^n sample in germline resource)
## for gatk 4.0.0.0 Mutect2

BQSR_DIR=${1}
MUTECT2_DIR=${2}
GERMLINE_VCF=${3}
PoN_VCF=${4}
AF_THRESH=${5} 

BWA=/home/jjl78/scripts/bwa


mkdir -p ${MUTECT2_DIR}

for FILE in ${BQSR_DIR}/*_BQSR.bam
do
    SAMPLE=$(basename $FILE _BQSR.bam)
    echo $SAMPLE
    sbatch -o ${MUTECT2_DIR}/${SAMPLE}_mutect.out -e ${MUTECT2_DIR}/${SAMPLE}_mutect.err ${BWA}/mutect2.sbatch \
         ${SAMPLE} ${BQSR_DIR} ${MUTECT2_DIR} ${GERMLINE_VCF} ${PoN_VCF} ${AF_THRESH}
done
