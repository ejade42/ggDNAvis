#!/bin/bash

## Assumes blue-crab is installed (I had version v0.5.0)

participant_id=${1}
input_file=${2}

mkdir -p output/${participant_id}
blue-crab s2p "${input_file}" -o "output/${participant_id}/${participant_id}_01_reads.pod5"
