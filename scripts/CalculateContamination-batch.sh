#!/bin/bash

if [[ ${#} -ne 2 ]]
then 
        echo "usage: source CalculateContamination-batch.sh PILEUP_DIR OUTPUT_DIR"
        exit 1
fi 

## sample-name pileups-dir output.dir

PILEUP_DIR=${1}
OUTPUT_DIR=${2}

BWA=/home/jjl78/scripts/bwa


for FILE in ${PILEUP_DIR}/*_pileups.table 
do
    SAMPLE=$(basename $FILE _pileups.table)
    echo $SAMPLE
    sbatch -o ${OUTPUT_DIR}/${SAMPLE}_CC.out -e ${OUTPUT_DIR}/${SAMPLE}_CC.err ${BWA}/CalculateContamination.sbatch \
    ${SAMPLE} ${PILEUP_DIR} ${OUTPUT_DIR}
done

