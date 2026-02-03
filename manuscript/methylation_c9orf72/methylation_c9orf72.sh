#!/bin/bash -e

## Assumes pod5, dorado, minimap2 and samtools are installed and active
## I had pod5 version 0.3.35, dorado version 0.9.6+0949eb8,
## minimap2 version 2.30-r1287, and samtools version 1.23


## Assumes 20190510_PAD43259_FLO-PRO002_SQK-LSK109_c9orf72_24-5-2_Cas9.fast5 is in input/



## Initialisation
#reference="input/chromosome_4_GRCh38.p14.fasta"
input_file="input/20190510_PAD43259_FLO-PRO002_SQK-LSK109_c9orf72_24-5-2_Cas9.fast5"
#start_location="input/htt_repeat_start.bed"
#end_location="input/htt_repeat_end.bed"
#clip_location="input/htt_repeat_clip.bed"
base_model="dna_r9.4.1_e8_sup@v3.3"
modified_model="${base_model}_5mCG_5hmCG@v0"

## Step 1: Convert to POD5
#echo "$(date +"(%Y-%m-%d %T)") Step 1: converting FAST5 to POD5"
#pod5 convert fast5 --force-overwrite "${input_file}" -o "output/01_initial.pod5"

## Step 2: Download modified basecalling model for v9.4.1 flowcell
## (chosen because FAST5 doesn't have flowcell information but used the
## SQK-LSK109 kit which was for R9.4.1 flowcells)
echo; echo "$(date +"(%Y-%m-%d %T)") Step 2: downloading models"
dorado download --model "${base_model}" --models-directory "models"
dorado download --model "${modified_model}" --models-directory "models"

## Step 3: Basecall
echo; echo "$(date +"(%Y-%m-%d %T)") Step 3: basecalling"
dorado basecaller "models/${base_model}" --modified-bases-models "models/${modified_model}" "output/01_initial.pod5" -o "output/02_basecalled.bam"
