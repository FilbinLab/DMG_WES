#!/bin/bash

if [[ ${#} -ne 3 ]]
then 
        echo "usage: source FilterMutect-batch.sh VCF_DIR CC_DIR OUTPUT_DIR"
        exit 1
fi 

## sample-name vcf-dir contamination-dir output-dir

VCF_DIR=${1}
CC_DIR=${2}
OUTPUT_DIR=${3}

BWA=/home/jjl78/scripts/bwa

mkdir ${OUTPUT_DIR}

for FILE in ${VCF_DIR}/*.vcf.gz 
do
    SAMPLE=$(basename $FILE .vcf.gz)
    echo $SAMPLE
    sbatch -o ${OUTPUT_DIR}/${SAMPLE}_FM.out -e ${OUTPUT_DIR}/${SAMPLE}_FM.err ${BWA}/FilterMutect.sbatch \
    ${SAMPLE} ${VCF_DIR} ${CC_DIR} ${OUTPUT_DIR}
done

