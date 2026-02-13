#!/bin/bash -e

## Assumes samtools is installed (I had version 1.23)
## Assumes modkit is installed (I had version 0.6.1)

participant_id=${1}
target_start=${2}
target_end=${3}
target_clip=${4}

## Step 1: filter to only FMR1 repeat
echo; echo "$(date +"(%Y-%m-%d %T)") Step 1: filtering to FMR1 repeat"
samtools view -L "${target_start}" "output/${participant_id}/${participant_id}_03_sorted.bam" -u |
samtools view -L "${target_end}" -o "output/${participant_id}/${participant_id}_04_filtered.bam" -


## Step 2: Create lists of forward and reverse reads
echo; echo "$(date +"(%Y-%m-%d %T)") Step 2: identifying forward and reverse reads"
samtools view -F 16 "output/${participant_id}/${participant_id}_04_filtered.bam" | awk '{print $1}' > "output/${participant_id}/${participant_id}_05_forward_reads.txt"
samtools view -f 16 "output/${participant_id}/${participant_id}_04_filtered.bam" | awk '{print $1}' > "output/${participant_id}/${participant_id}_05_reverse_reads.txt"


## Step 3: clip reads to narrow region around repeat
echo; echo "$(date +"(%Y-%m-%d %T)") Step 3: clipping to FMR1 repeat region"
samtools ampliconclip --both-ends --hard-clip -b "${target_clip}" "output/${participant_id}/${participant_id}_04_filtered.bam" > "output/${participant_id}/${participant_id}_06_clipped.bam"


## Step 4: repair broken modification tags
echo; echo "$(date +"(%Y-%m-%d %T)") Step 4: repairing modification tags"
samtools sort -N -o "output/${participant_id}/${participant_id}_07_name_sorted.bam" "output/${participant_id}/${participant_id}_04_filtered.bam"
samtools sort -N -o "output/${participant_id}/${participant_id}_07_name_sorted_clipped.bam" "output/${participant_id}/${participant_id}_06_clipped.bam"

modkit repair -d "output/${participant_id}/${participant_id}_07_name_sorted.bam" -a "output/${participant_id}/${participant_id}_07_name_sorted_clipped.bam" -o "output/${participant_id}/${participant_id}_08_repaired.bam" --log-filepath "modkit_log.txt"


## Step 5: Create final FASTQ to read
echo; echo "$(date +"(%Y-%m-%d %T)") Step 5: creating final fastq"
samtools fastq -T MM,ML "output/${participant_id}/${participant_id}_08_repaired.bam" > "output/${participant_id}/${participant_id}_09_final.fastq"
