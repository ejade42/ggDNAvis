#!/bin/bash -e

## Assumes blue-crab is installed (I had version v0.5.0)

participant_id="${1}"
input_files="${2}"
threads="${OMP_NUM_THREADS:-4}"
echo "Threads set to ${threads}"
echo "Input files detected:" ${input_files}

mkdir -p output/${participant_id}
rm -f output/${participant_id}/${participant_id}_01_reads.pod5
blue-crab s2p ${input_files} -p "${threads}" -o "output/${participant_id}/${participant_id}_01_reads.pod5"
