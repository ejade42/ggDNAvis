For methylation visualisation, a modified FASTQ file containing the 
sequences and modification information to visualise and a 
metadata CSV file containing extra information about each read must be uploaded.

##### Required formats:

- **FASTQ:** A FASTQ file with 4-line entries consisting of: 
header line, sequence line, spacer line, quality line.
For methylation, this *must* be a modified FASTQ containing the 
MM and ML SAMtools tags in the header rows, from which methylation/modification
information can be read. 
Such modified FASTQs can be created from SAM/BAM files that contain modification
information (e.g. the output of Dorado basecalling with a 5mc model) via
`samtools fastq -T MM,ML ${input_bam_file} > "modified_fastq_file.fastq"`

- **CSV:** A CSV spreadsheet containing additional information about each row.
***Must*** have a `"read"` column that exactly matches the read IDs in the FASTQ to allow merging, 
and a `"direction"` column indicating whether each read is `"forward"` or `"reverse"`. 
Can contain any other columns e.g. which participant from which family each read 
came from - any such columns can then be used to sort and group the sequences, 
which can greatly enhance visualisation effectiveness. 
See 'Loading from FASTQ and metadata file' section of
[documentation](https://ejade42.github.io/ggDNAvis/)
for instructions on how to generate a starter metadata file.
