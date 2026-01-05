For methylation visualisation, `ggDNAvis` is able to 
read modified FASTQ files that have modification information 
from the MM and ML SAMtools tags stored in each header row. 
These modified FASTQs can be created from SAM/BAM via
`samtools fastq -T MM,ML ${input_bam_file} > "modified_fastq_file.fastq"`.

If these tags are in each header row, they need special parsing 
to be interpreted correctly, otherwise they will be interpreted 
as one giant read ID that will not match the metadata read IDs. 
Therefore, if a modified FASTQ is uploaded, modification-capable 
parsing must be enabled via this checkbox.

See [modified FASTQ parsing section of documentation][link_modified_fastq_reading]
for more information on modified FASTQ format and parsing.
