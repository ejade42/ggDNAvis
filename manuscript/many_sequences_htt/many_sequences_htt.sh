#!/bin/bash -e

## Assumes minimap2 and samtools are installed and active
## I had minimap2 version 2.30-r1287 and samtools version 1.23

## Assumes "chromosome_4_GRCh38.p14.fasta", "SRR13068459.fastq.gz", and "htt_repeat_*.bed"
## are in input/ directory relative to this script

## Chr 4 reference available from https://www.ncbi.nlm.nih.gov/nuccore/NC_000004.12/
## SRR13068459 data available from https://trace.ncbi.nlm.nih.gov/Traces/?view=run_browser&acc=SRR13068459
## bed files are included in this repository so should already be present


## Initialisation
reference="input/chromosome_4_GRCh38.p14.fasta"
input_file="input/SRR13068459.fastq.gz"
start_location="input/htt_repeat_start.bed"
end_location="input/htt_repeat_end.bed"
clip_location="input/htt_repeat_clip.bed"


## Step 1: Index reference genome
echo "$(date +"(%Y-%m-%d %T)") Step 1: indexing reference"
mkdir -p "output"
minimap2 -x "lr:hq" -d "output/00_hg38_c4.mmi" "${reference}"


## Step 2: Map FASTQ to reference
echo; echo "$(date +"(%Y-%m-%d %T)") Step 2: mapping input FASTQ"
minimap2 -a -x "lr:hq" "output/00_hg38_c4.mmi" "${input_file}" > "output/01_mapped.sam"
samtools sort "output/01_mapped.sam" > "output/02_sorted.bam"
samtools index "output/02_sorted.bam"


## Step 3: Filter reads to overlapping repeat region only
echo; echo "$(date +"(%Y-%m-%d %T)") Step 3: filtering to repeat region"
samtools view -L "${start_location}" "output/02_sorted.bam" -u |
samtools view -L "${end_location}" -o "output/03_filtered.bam" -


## Step 4: Clip reads to narrow region around repeat
echo; echo "$(date +"(%Y-%m-%d %T)") Step 4: clipping to repeat region"
samtools ampliconclip --both-ends --hard-clip -b "${clip_location}" "output/03_filtered.bam" > "output/04_clipped.bam"


## Step 5: Create lists of forward and reverse reads
echo; echo "$(date +"(%Y-%m-%d %T)") Step 5: identifying forward and reverse reads"
samtools view -F 16 "output/04_clipped.bam" | awk '{print $1}' > "output/05_forward_reads.txt"
samtools view -f 16 "output/04_clipped.bam" | awk '{print $1}' > "output/05_reverse_reads.txt"


## Step 6: Create final FASTQ to read
echo; echo "$(date +"(%Y-%m-%d %T)") Step 6: creating final fastq"
samtools fastq "output/04_clipped.bam" > "output/06_final.fastq"
