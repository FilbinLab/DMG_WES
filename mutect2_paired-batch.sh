#!/bin/bash

## sample_pairs_file should consist of 1 line for each pair, following the format: normalSampleName=tumorSampleName

if [[ ${#} -ne 6 ]]
then 
        echo "usage: source mutect2_paired-batch.sh BQSR_DIR MUTECT2_DIR GERMLINE_VCF PoN_VCF sample_pairs_file REF_FA"
        exit 1
fi 

BQSR_DIR=${1}
MUTECT2_DIR=${2}
GERMLINE_VCF=${3}
PoN_VCF=${4}
sample_pairs_file=${5}
REF_FA=${6}

BWA=/home/jjl78/scripts/bwa

mkdir -p ${MUTECT2_DIR}

OLDIFS=$IFS
IFS=$'\n'

for PAIR in $(cat ${sample_pairs_file}); do
        echo ${PAIR}
        normal=$(echo ${PAIR} | cut -f1 -d=)
        tumor=$(echo ${PAIR} | cut -f2 -d=)
        SAMPLE=${normal}_${tumor}
	echo Normal:${normal}
        echo Tumor:${tumor}

	normal_bam=${BQSR_DIR}/${normal}_BQSR.bam
	tumor_bam=${BQSR_DIR}/${tumor}_BQSR.bam
	
	sbatch -o ${MUTECT2_DIR}/${SAMPLE}_mutect.out -e ${MUTECT2_DIR}/${SAMPLE}_mutect.err ${BWA}/mutect2_paired.sbatch \
        ${tumor_bam} ${tumor} ${normal_bam} ${normal} ${GERMLINE_VCF} ${PoN_VCF} ${REF_FA} ${MUTECT2_DIR}

	echo "----------------"

done
IFS=$OLDIFS
