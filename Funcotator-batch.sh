#!/bin/bash

if [[ ${#} -ne 4 ]]
then 
        echo "usage: source Funcotator-batch.sh VCF_DIR OUTPUT_DIR REF-FA DATA-DIR"
        exit 1
fi 

## sample-name vcf-dir ref-fa output-dir data-source-dir

VCF_DIR=${1}
OUTPUT_DIR=${2}
REF_FA=${3}
DATA_DIR=${4}

BWA=/home/jjl78/scripts/bwa

mkdir ${OUTPUT_DIR}

## NOTE: as of 08/10/22, ".vcf" changed to ".vcf.gz"
for FILE in ${VCF_DIR}/*.vcf.gz
do
    SAMPLE=$(basename $FILE .vcf.gz)
    echo $SAMPLE
    sbatch -o ${OUTPUT_DIR}/${SAMPLE}_Func.out -e ${OUTPUT_DIR}/${SAMPLE}_Func.err ${BWA}/Funcotator.sbatch \
    ${SAMPLE} ${VCF_DIR} ${REF_FA} ${OUTPUT_DIR} ${DATA_DIR}
done

