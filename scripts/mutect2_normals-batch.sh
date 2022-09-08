#!/bin/bash

if [[ ${#} -ne 4 ]]
then 
        echo "usage: source mutect2_normals-batch.sh BQSR_DIR/NORMALS MUTECT2_NORMALS_DIR Ref germline_resource"
        exit 1
fi 

BQSR_DIR=${1}
MUTECT2_DIR=${2}
Ref=${3}
germline_resource=${4}

BWA=/home/jjl78/scripts/bwa


mkdir -p ${MUTECT2_DIR}

for FILE in ${BQSR_DIR}/*_BQSR.bam
do
    SAMPLE=$(basename $FILE _BQSR.bam)
    echo $SAMPLE
    sbatch -o ${MUTECT2_DIR}/${SAMPLE}_mutect.out -e ${MUTECT2_DIR}/${SAMPLE}_mutect.err ${BWA}/mutect2_normals.sbatch \
         ${SAMPLE} ${BQSR_DIR} ${MUTECT2_DIR} ${Ref} ${germline_resource}
done
