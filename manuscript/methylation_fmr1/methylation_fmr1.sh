#!/bin/bash -e
#SBATCH -A uoa04084
#SBATCH --time=24:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=2
#SBATCH --mail-user=user@domain.com
#SBATCH --mail-type=END,FAIL
#SBATCH --output=logs/slurm-%j-FMR1.out


## Reused SLURM arguments
args="--parsable -A uoa04084 --mail-user=user@domain.com --mail-type=END,FAIL"
subjob_dir="logs/subjobs"

## Control which steps run
do_reference_indexing=false
do_input_conversion=true
do_basecalling=false
do_mapping=false
do_filtering=false

## Set up inputs 
## Input files assumed to have been downloaded and extracted to input/ directory by input/download_fmr1.sh
## Be warned that the sequencing data is hundreds of GB
participant_ids=("NA04026" "NA05131" "NA06905" "NA12878")
input_files=("input/GBXM123343/NA04026_FMR1_readfish/*/slow5/*.blow5"
             "input/MBXM107326/NA05131/*/slow5/*.blow5"
             "input/MBXM032249/NA06905/*/slow5/*.blow5"
             "input/MBXM044264/NA12878/*/slow5/*.blow5")
reference_fasta="input/Homo_sapiens.GRCh38.dna.primary_assembly_250707.fa.gz"
target_start="input/fmr1_repeat_start.bed"
target_end="input/fmr1_repeat_end.bed"
target_clip="input/fmr1_repeat_clip.bed"

## Step 1 - index reference (only needs to be done once)
if ${do_reference_indexing}; then
    indexing_job_id=$(sbatch \
        ${args} \
        --cpus-per-task "4" \
        --time "10:00" \
        --mem "16G" \
        --output "${subjob_dir}/slurm-%j-Indexing.out" \
        "01_reference_indexing.sh" \
        "${reference_fasta}")
    echo "Step 1 (reference indexing) submitted with ID: ${indexing_job_id}"
fi


## Per-participant processing
for i in "${!participant_ids[@]}"; do
    participant_id=${participant_ids[$i]}
    input_file=${input_files[$i]}

    ## Step 2 - input conversion
    if ${do_input_conversion}; then
        conversion_id=$(sbatch \
            ${args} \
            --cpus-per-task "6" \
            --time "1:00:00" \
            --mem "16G" \
            --output "${subjob_dir}/slurm-%j-${participant_id}-InputConversion.out" \
            "02_input_conversion.sh" \
            "${participant_id}" "${input_file}")
        echo "Step 2 (input conversion) for participant ${participant_id} submitted with ID: ${conversion_id}"
    fi

    ## Step 3 - basecalling
    if ${do_basecalling}; then
        if [[ -n ${conversion_id} ]]; then
            active_args="${args} -d afterok:${conversion_id}"
        else
            active_args="${args}"
        fi
        
        basecalling_id=$(sbatch \
            ${active_args} \
            --cpus-per-task "6" \
            --gpus-per-node "A100:1" \
            --time "4:00:00" \
            --mem "32G" \
            --output "${subjob_dir}/slurm-%j-${participant_id}-Basecalling.out" \
            "03_basecalling.sh" \
            "${participant_id}")
        echo "Step 3 (basecalling) for participant ${participant_id} submitted with ID: ${basecalling_id}"
    fi

    ## Step 4 - mapping
    if ${do_mapping}; then
        if [[ -n ${basecalling_id} ]]; then
            active_args="${args} -d afterok:${basecalling_id}"
        elif [[ -n ${conversion_id} ]]; then
            active_args="${args} -d afterok:${conversion_id}"
        else
            active_args="${args}"
        fi

        mapping_id=$(sbatch \
            ${active_args} \
            --cpus-per-task "16" \
            --time "12:00:00" \
            --mem "16G" \
            --output "${subjob_dir}/slurm-%j-${participant_id}-Mapping.out" \
            "04_mapping.sh" \
            "${participant_id}")
        echo "Step 4 (mapping) for participant ${participant_id} submitted with ID: ${mapping_id}"
    fi


    ## Step 5 - filtering
    if ${do_filtering}; then
        if [[ -n ${mapping_id} ]]; then
            active_args="${args} -d afterok:${mapping_id}"
        elif [[ -n ${basecalling_id} ]]; then
            active_args="${args} -d afterok:${basecalling_id}"
        elif [[ -n ${conversion_id} ]]; then
            active_args="${args} -d afterok:${conversion_id}"
        else
            active_args="${args}"
        fi

        filtering_id=$(sbatch \
            ${active_args} \
            --cpus-per-task "4" \
            --time "0:30:00" \
            --mem "16G" \
            --output "${subjob_dir}/slurm-%j-${participant_id}-Filtering.out" \
            "05_filtering.sh" \
            "${participant_id}" "${target_start}" "${target_end}" "${target_clip}")
        echo "Step 5 (filtering) for participant ${participant_id} submitted with ID: ${filtering_id}"
    fi
done
