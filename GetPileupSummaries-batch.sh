#!/bin/bash

if [[ ${#} -ne 3 ]]
then 
        echo "usage: source GetPileupSummaries-batch.sh BAM_DIR PILEUP_DIR germline_vcf"
        exit 1
fi 

BAM_DIR=${1}
PILEUP_DIR=${2}
germline_vcf=${3}

BWA=/home/jjl78/scripts/bwa

mkdir ${PILEUP_DIR}

for FILE in ${BAM_DIR}/*_BQSR.bam
do
    SAMPLE=$(basename $FILE _BQSR.bam)
    echo $SAMPLE
    BAM=${BAM_DIR}/${SAMPLE}_BQSR.bam
    sbatch -o ${PILEUP_DIR}/${SAMPLE}_GP.out -e ${PILEUP_DIR}/${SAMPLE}_GP.err ${BWA}/GetPileupSummaries_long.sbatch \
    ${BAM} ${germline_vcf} ${SAMPLE} ${PILEUP_DIR}
done

##  input: bam germline-vcf sample-name output-dir
