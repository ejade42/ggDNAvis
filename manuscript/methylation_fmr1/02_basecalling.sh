#!/bin/bash

## Assumes dorado is installed (I had version 0.9.6+0949eb8)
dorado basecaller sup@v3.3,5mCG_5hmCG@latest "output/01_reads.pod5" > "output/02_reads.bam"