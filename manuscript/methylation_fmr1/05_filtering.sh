#!/bin/bash -e

## Assumes minimap2 is installed (I had version 2.30-r1287)
## Assumes samtools is installed (I had version 1.23)

participant_id=${1}
target_start=${2}
target_end=${3}
target_clip=${4}

## Step 1: filter to only FMR1 repeat
echo; echo "$(date +"(%Y-%m-%d %T)") Step 1: filtering to FMR1 repeat"
samtools view -L "${target_start}" "output/${participant_id}/${participant_id}_03_sorted.bam" -u |
samtools view -L "${target_end}" -o "output/${participant_id}/${participant_id}_04_filtered.bam" -


## Step 2: clip reads to narrow region around repeat
echo; echo "$(date +"(%Y-%m-%d %T)") Step 2: clipping to FMR1 repeat region"
samtools ampliconclip --both-ends --hard-clip -b "${target_clip}" "output/${participant_id}/${participant_id}_04_filtered.bam" > "output/${participant_id}/${participant_id}_05_clipped.bam"


## Step 3: Create lists of forward and reverse reads
echo; echo "$(date +"(%Y-%m-%d %T)") Step 3: identifying forward and reverse reads"
samtools view -F 16 "output/${participant_id}/${participant_id}_04_filtered.bam" | awk '{print $1}' > "output/${participant_id}/${participant_id}_05_forward_reads.txt"
samtools view -f 16 "output/${participant_id}/${participant_id}_04_filtered.bam" | awk '{print $1}' > "output/${participant_id}/${participant_id}_05_reverse_reads.txt"


## Step 4: Create final FASTQ to read
echo; echo "$(date +"(%Y-%m-%d %T)") Step 4: creating final fastq"
samtools fastq -T MM,ML "output/${participant_id}/${participant_id}_05_clipped.bam" > "output/${participant_id}/${participant_id}_06_final.fastq"
