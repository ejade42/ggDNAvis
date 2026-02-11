#!/bin/bash

## Assumes dorado is installed (I had version 0.9.6+0949eb8)

participant_id=${1}

dorado basecaller sup@v3.3,5mCG_5hmCG@latest "output/${participant_id}/${participant_id}_01_reads.pod5" > "output/${participant_id}/${participant_id}_02_reads.bam"
