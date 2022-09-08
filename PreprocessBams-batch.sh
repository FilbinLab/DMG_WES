#!/bin/bash
## input: sample-name input-dir preprocessing-dir 
if [[ ${#} -ne 2 ]]
then 
        echo "usage: source PreprocessBams-batch.sh BWA_DIR PREPROCESSING_DIR"
        exit 1
fi 

BWA_DIR=${1}
PREPROCESSING_DIR=${2}

BWA=/home/jjl78/scripts/bwa

mkdir ${PREPROCESSING_DIR}

for FILE in ${BWA_DIR}/*.genome.bam
do
    SAMPLE=$(basename $FILE .genome.bam)
    echo $SAMPLE
    sbatch -o ${PREPROCESSING_DIR}/${SAMPLE}_Preprocessing.out -e ${PREPROCESSING_DIR}/${SAMPLE}_Preprocessing.err ${BWA}/PreprocessBams.sbatch \
    ${SAMPLE} ${BWA_DIR} ${PREPROCESSING_DIR}
done
