#!/bin/bash

## Assumes blue-crab is installed (I had version v0.5.0)
## Assumes input/GBXM123343/NA04026_FMR1_readfish/20210527_0307_X3_FAQ22858_a248fea1/slow5/FAQ22858_9e0f66cb.blow5 exists
## This file can be downloaded and extracted via input/download_fmr1.sh
## Be warned that this is hundreds of GB

mkdir -p output
input_file="input/GBXM123343/NA04026_FMR1_readfish/20210527_0307_X3_FAQ22858_a248fea1/slow5/FAQ22858_9e0f66cb.blow5"
blue-crab s2p "${input_file}" -o "output/01_reads.pod5"
