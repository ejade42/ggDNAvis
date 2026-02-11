#!/bin/bash

## Assumes minimap2 is installed (I had version 2.30-r1287)
## Assumes samtools is installed (I had version 1.23)

participant_id=${1}
target_start=${2}
target_end=${3}
target_clip=${4}


## Step 1: map against reference, sort, and index
echo; echo "$(date +"(%Y-%m-%d %T)") Step 1: mapping and sorting basecalled BAM"
samtools fastq -T MM,ML "output/${participant_id}/${participant_id}_02_basecalled.bam" |
minimap2 -a -y -x "map-ont" "output/hg38.mmi" - |
samtools sort > "output/${participant_id}/${participant_id}_03_sorted.bam"
samtools index "output/${participant_id}/${participant_id}_03_sorted.bam"


## Step 2: filter to only FMR1 repeat
echo; echo "$(date +"(%Y-%m-%d %T)") Step 2: filtering to FMR1 repeat"
samtools view -L "${target_start}" "output/${participant_id}/${participant_id}_03_sorted.bam" -u |
samtools view -L "${target_end}" -o "output/${participant_id}/${participant_id}_04_filtered.bam" -


## Step 3: clip reads to narrow region around repeat
echo; echo "$(date +"(%Y-%m-%d %T)") Step 3: clipping to FMR1 repeat region"
samtools ampliconclip --both-ends --hard-clip -b "${target_clip}" "output/${participant_id}/${participant_id}_04_filtered.bam" > "output/${participant_id}/${participant_id}_05_clipped.bam"


## Step 4: Create lists of forward and reverse reads
echo; echo "$(date +"(%Y-%m-%d %T)") Step 4: identifying forward and reverse reads"
samtools view -F 16 "output/${participant_id}/${participant_id}_04_filtered.bam" | awk '{print $1}' > "output/${participant_id}/${participant_id}_05_forward_reads.txt"
samtools view -f 16 "output/${participant_id}/${participant_id}_04_filtered.bam" | awk '{print $1}' > "output/${participant_id}/${participant_id}_05_reverse_reads.txt"


## Step 5: Create final FASTQ to read
echo; echo "$(date +"(%Y-%m-%d %T)") Step 5: creating final fastq"
samtools fastq "output/${participant_id}/${participant_id}_05_clipped.bam" > "output/${participant_id}/${participant_id}_06_final.fastq"
