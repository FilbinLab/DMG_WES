#!/bin/bash

## input: sample-name preprocessing-dir bqsr-dir reference-fa germline-mutations

if [[ ${#} -ne 4 ]]
then 
        echo "usage: source BQSR-batch.sh PREPROCESSING_DIR BQSR_DIR Ref germline_vcf"
        exit 1
fi 

PREPROCESSING_DIR=${1}
BQSR_DIR=${2}
Ref=${3}
germline_vcf=${4}

BWA=/home/jjl78/scripts/bwa

mkdir ${BQSR_DIR}

for FILE in ${PREPROCESSING_DIR}/*_AddReadGroup.bam
do
    SAMPLE=$(basename $FILE _AddReadGroup.bam)
    echo $SAMPLE
    sbatch -o ${BQSR_DIR}/${SAMPLE}_BQSR.out -e ${BQSR_DIR}/${SAMPLE}_BQSR.err ${BWA}/BQSR.sbatch \
    ${SAMPLE} ${PREPROCESSING_DIR} ${BQSR_DIR} ${Ref} ${germline_vcf}
done
