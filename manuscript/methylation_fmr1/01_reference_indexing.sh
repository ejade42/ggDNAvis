#!/bin/bash

## Assumes minimap2 is installed (I had version 2.30-r1287)
## Assumes Homo_sapiens.GRCh38.dna.primary_assembly_240815.fa is in input/

## Reference genome available from ENSEMBL http://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/
## Downloaded by input/download_fmr1.sh

reference_fasta=$1
minimap2 -x "map-ont" -d "output/hg38.mmi" "${reference_fasta}"
