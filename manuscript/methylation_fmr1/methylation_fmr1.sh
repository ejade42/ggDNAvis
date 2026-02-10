#!/bin/bash -e
#SBATCH -A uoa04084
#SBATCH --time=24:00:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=2
#SBATCH --mail-user=user@domain.com
#SBATCH --mail-type=END,FAIL
#SBATCH --output=logs/slurm-%j-FMR1.out


## Reused arguments
args="--parsable -A uoa04084 --mail-user=user@domain.com --mail-type=END,FAIL"
subjob_dir="logs/subjobs"

## Step 1 - convert input file to POD5
#step_1=$(sbatch \
#    ${args} \
#    --cpus-per-task "6" \
#    --time "1:00:00" \
#    --mem "16G" \
#    --output "${subjob_dir}/slurm-%j-InputConversion.out" \
#    "01_input_conversion.sh")
#echo "Step 1 submitted with ID: ${step_1}"



## Step 2 - basecall
if [[ -n ${step_1} ]]; then
    active_args="${args} -d afterok:${step_1}"
else
    active_args=${args}
fi

step_2=$(sbatch \
    ${args} \
    --cpus-per-task "6" \
    --gpus-per-node "A100:1" \
    --time "6:00:00" \
    --mem "32G" \
    --output "${subjob_dir}/slurm-%j-Basecalling.out" \
    "02_basecalling.sh")
echo "Step 2 submitted with ID: ${step_2}"



## Step 3 - mapping, filtering etc