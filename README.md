# DMG_WES
Analysis of whole exome sequencing variant calling for diffuse midline glioma

## Commands for running somatic variant calling using mutect2
Commands executed on O2 HMS, SLURM job scheduler

## 3 variations possible: 
1. Paired tumor/normal (PoN built from all normals in cohort)
2. Tumor only (PoN from GATK)
3. Tumor only (PoN built from all normals in cohort)

## Downloading references
*GATK pre-built PoN*:  
      `wget https://console.cloud.google.com/storage/browser/gatk-best-practices/somatic-b37;tab=objects?prefix=&forceOnObjectsSortingFiltering=false`

*gnomad vcf*:  
      `wget https://console.cloud.google.com/storage/browser/_details/gatk-best-practices/somatic-b37/af-only-gnomad.raw.sites.vcf;tab=live_object`

*Funcotator references for annotation*:  
      `wget https://console.cloud.google.com/storage/browser/broad-public-datasets/funcotator/funcotator_dataSources.v1.7.20200521s;tab=objects?prefix=&forceOnObjectsSortingFiltering=false`


## ALIGNMENT 
Alignment performed using BWA
BWA reference directory built from: ~/genome/human/hg19_fasta_gtf/genome_hg19.fa 
Bam file sorting also performed in this script

    source ~/scripts/bwa/bwa-batch.sh \
    FASTQ_DIR \
    BWA_DIR \
    ~/genome/human/bwa_new/hg19 \
    fastq


## PREPROCESSING BAM FILE 

### 1. Mark duplicates, add read group, index bam
    source ~/scripts/bwa/PreprocessBams-batch.sh \
    BWA_DIR \ ## output from BWA alignment
    PREPROCESSING_DIR ## output directory


### 2. Base recalibration

    source ~/scripts/bwa/BQSR-batch.sh \
    PREPROCESSING_DIR \
    BQSR_DIR \
    ~/genome/human/hg19_fasta_gtf/genome_hg19.fa \
    ~/genome/human/mutect2_resources/germline_resource/somatic-b37_af-only-gnomad.raw.sites.vcf



## VARIANT CALLING


### 1. Construct PoN from set of normal bams
Run Mutect2 in tumor-only mode for each normal sample
Before running, create "Normals" dir in BQSR_DIR (processed bams) and move all normal bams to that dir

***Alternatively, can use GATK pre-built PoN*** *(Not used for the DMG analysis)*  
 
	  source ~/scripts/bwa/mutect2_normals-batch.sh \
	  BQSR_DIR/Normals \
	  mutect2_normals \ ## output dir
	  ~/genome/human/hg19_fasta_gtf/genome_hg19.fa \
	  ~/genome/human/mutect2_resources/germline_resource/somatic-b37_af-only-gnomad.raw.sites.vcf	

#### Create file with names of all normal vcfs
	
	  cd mutect2_normals
	  ls | grep "vcf.gz" > normals_for_pon_vcf.args

#### Combine the normal calls
Execute within mutect2_normals
	
	  sbatch ~/scripts/bwa/CreateSomaticPanelOfNormals.sbatch normals_for_pon_vcf.args
	
Move this panel of normals into:  ~/genome/human/mutect2_resources/PoN/



### 2. Run variant calling with one of the following options:
Note: if you moved the normal bams to a separate directory in the PoN step, move them back before executing
for af-alleles-in-reference, can set to -1 to skip this filter

#### Option 1: Paired tumor/normal (PoN can be from GATK or built from all normals in cohort)
*This option used for the DMG analysis*  
Create dir within AddReadGroup with just the samples with paired normal/tumor
Create sample_pairs_file, consisting of 1 line for each pair, following the format: normalSampleName=tumorSampleName

    source ~/scripts/bwa/mutect2_paired-batch.sh \ 
    BQSR_DIR \
    MUTECT2_DIR \
    ~/genome/human/mutect2_resources/germline_resource/somatic-b37_af-only-gnomad.raw.sites.vcf \
    ~/genome/human/mutect2_resources/PoN/**yourPoN \
    sample_pairs_file \
    ~/genome/human/hg19_fasta_gtf/genome_hg19.fa

#### Option 2: Tumor only (PoN can be from GATK or built from all normals in cohort)
*Not used for the DMG analysis*

    source ~/scripts/bwa/mutect2-batch.sh \
    BQSR_DIR \
    mutect2_tumor_only \
    ~/genome/human/mutect2_resources/germline_resource/somatic-b37_af-only-gnomad.raw.sites.vcf \
    ~/genome/human/mutect2_resources/PoN/**yourPoN


## FILTERING AND ANNOTATING VARIANTS 


### 1. Calculate contamination
    source ~/scripts/bwa/GetPileupSummaries-batch.sh \
    BQSR_DIR \ ## this is the final, processed BAM directory
    PILEUP_DIR \ ## output directory
    ~/genome/human/mutect2_resources/germline_resource/somatic-b37_af-only-gnomad.raw.sites.vcf

    source  ~/scripts/bwa/CalculateContamination-batch.sh \
    PILEUP_DIR \
    CC_DIR ## output directory

### 2. Filter variants
    source  ~/scripts/bwa/FilterMutect-batch.sh \
    VCF_DIR \ ## mutect2 result directory
    CC_DIR \ ## CalculateContamination files from previous step
    FILTERED_DIR ## output directory

### 3. Annotate variants
    source ~/scripts/bwa/Funcotator-batch.sh \
    VCF_DIR \ ## mutect2 result directory
    FUNC_DIR \ ## output directory
    ~/genome/human/hg19_fasta_gtf/genome_hg19.fa \
    ~/genome/human/mutect2_resources/funcotator_dataSources.v1.7.20200521s ## funcotator resources downloaded from GATK
    
### 5. Merge annotated files (maf) into single file
	Rscript maftools_preprocess.R FUNC_DIR
	
## PLOT FINAL VARIANTS
See maftools.Rmd for plotting information (oncoplot)
