#!/usr/bin/env Rscript

library(maftools)
library(ggplot2)
library(data.table)

args=commandArgs(trailingOnly=TRUE)

## Set working directory and create analysis directory
data_dir <- args[1]
print(data_dir)

analysis_dir<- paste0(data_dir, "/analysis/")
print(analysis_dir)
if(!dir.exists(analysis_dir)){dir.create(analysis_dir)}

## list all maf files
maf.files<- list.files(data_dir, pattern="funcotated.maf")
print(maf.files)

## read in files, convert to maftools object
maf_list<- lapply(maf.files, function(x){
  print(x)
  tmp_maf<- read.maf(maf=paste0(data_dir, "/", x))
  tmp<- tmp_maf@data
  tmp$Tumor_Sample_Barcode<- gsub(".funcotated.maf", "", x)
  tmp$Tumor_Sample_Barcode<- as.character(tmp$Tumor_Sample_Barcode)
  tmp$Tumor_Sample_Barcode<-  gsub("_L12", "", gsub("_L2", "", tmp$Tumor_Sample_Barcode))
  tmp_maf@data<- tmp
  return(tmp_maf)
    })
names(maf_list)<- gsub(".funcotated.maf", "",gsub("_L12", "", gsub("_L2", "", maf.files)))


## Merge into single maf file
maf_all<- merge_mafs(maf=maf_list)

## add clinical data
clinical<- data.frame(Tumor_Sample_Barcode= unique(maf_all@data$Tumor_Sample_Barcode))
clinical$type<- ifelse(grepl("n", clinical$Tumor_Sample_Barcode), "Normal", "Tumor")
clinical<- setDT(clinical)
maf_all@clinical.data<- clinical

## Edit to remove sample "__UNKNOWN__". No variants associated with it, just messes up plotting
## In the raw mafs, there is no sample ID associated, so all are listed as __UNKNOWN__
## We add in the sample IDs manually above, but __UNKNOWN__ still stays in sample list. remove it here.
maf_all<- filterMaf(maf_all, tsb="__UNKNOWN__")

saveRDS(maf_all, file=paste0(analysis_dir, "maf_merged.Rds"))
