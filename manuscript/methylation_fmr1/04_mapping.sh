#!/bin/bash -e

## Assumes minimap2 is installed (I had version 2.30-r1287)
## Assumes samtools is installed (I had version 1.23)

participant_id=${1}
threads=${OMP_NUM_THREADS:-4}
echo "Threads set to ${threads}"

## Map against reference, sort, and index
echo; echo "$(date +"(%Y-%m-%d %T)") Mapping and sorting basecalled BAM"
samtools fastq -T MM,ML "output/${participant_id}/${participant_id}_02_basecalled.bam" |
minimap2 -a -y -x "map-ont" -t "${threads}" "output/hg38.mmi" - |
samtools sort -@ "${threads}" > "output/${participant_id}/${participant_id}_03_sorted.bam"
samtools index "output/${participant_id}/${participant_id}_03_sorted.bam"
