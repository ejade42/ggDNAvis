#!/bin/bash -e

## Assumes minimap2 and samtools are installed and active
## I had minimap2 version 2.30-r1287 and samtools version 1.23

## Assumes prior script (methylation_c9orf72_1_basecalling.sh) has been run
## i.e. output/02_basecalled.bam exists
## Assumes "chromosome_9_GRCh38.p14.fasta" and "c9orf72_repeat_*.bed"
## are in input/ directory relative to this script

## Chr 9 reference available from https://www.ncbi.nlm.nih.gov/nuccore/NC_000009.12/
## bed files are included in this repository so should already be present


## Initialisation
reference="input/chromosome_9_GRCh38.p14.fasta"
start_location="input/c9orf72_repeat_start.bed"
end_location="input/c9orf72_repeat_end.bed"
clip_location="input/c9orf72_repeat_clip.bed"


## Step 4: Index reference genome
echo; echo "$(date +"(%Y-%m-%d %T)") Step 4: indexing reference"
mkdir -p "output"
minimap2 -x "lr:hq" -d "output/00_hg38_c9.mmi" "${reference}"


## Step 5: Map FASTQ to reference
echo; echo "$(date +"(%Y-%m-%d %T)") Step 5: mapping input BAM (via FASTQ)"
samtools fastq -T MM,ML "output/02_basecalled.bam" |
minimap2 -a -y -x "lr:hq" "output/00_hg38_c9.mmi" - |
samtools sort > "output/03_sorted.bam"
samtools index "output/03_sorted.bam"
