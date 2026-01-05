For multiple sequence visualisation, a FASTQ file containing 
the sequences to visualise and a metadata CSV file containing 
extra information about each read must be uploaded.

Required formats:

 * **FASTQ:** A FASTQ file with 4-line entries consisting of: 
header line, sequence line, spacer line, quality line. 
If the FASTQ contains modification information in the header lines, 
it will make the read IDs not match, so special modified FASTQ 
parsing must be enabled by checking the checkbox.

 * **CSV:** A CSV spreadsheet containing additional information about each row.
**Must** have a `read` column that exactly matches the read IDs 
in the FASTQ to allow merging, and a `direction` column indicating whether each 
read is `"forward"` or `"reverse`. 
Can contain any other columns e.g. which participant from which family 
each read came from - any such columns can then be used to sort and group 
the sequences, which can greatly enhance visualisation effectiveness. 
See ['Loading from FASTQ and metadata file' section of documentation][link_fastq_reading]
for instructions on how to generate a starter metadata file.
