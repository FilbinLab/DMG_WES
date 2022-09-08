#!/bin/bash

if [[ ${#} -ne 4 ]]
then 
        echo "usage: source bwa-batch.sh FASTQ_DIR/input BWA_DIR/output REF_DIR suffix"
        exit 1
fi 

FASTQ_DIR=${1}
BWA_DIR=${2}
REF=${3}
SUFFIX=${4}
BWA=/home/jjl78/scripts/bwa


mkdir -p ${BWA_DIR}

for FILE in ${FASTQ_DIR}/*_R1.${SUFFIX}
do
    SAMPLE=$(basename $FILE _R1.${SUFFIX})
    echo $SAMPLE
    FQ1=${SAMPLE}_R1.${SUFFIX}
    FQ2=${SAMPLE}_R2.${SUFFIX}
    OUTPUT=${SAMPLE}.genome
    sbatch -o ${BWA_DIR}/${SAMPLE}_bwa.out -e ${BWA_DIR}/${SAMPLE}_bwa.err ${BWA}/bwa.sbatch \
          ${FASTQ_DIR}/${FQ1} ${FASTQ_DIR}/${FQ2} ${REF} ${SAMPLE} ${BWA_DIR}/${OUTPUT}
done
