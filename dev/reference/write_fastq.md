# Write sequence and quality information to FASTQ

This function simply writes a FASTQ file from a dataframe containing
columns for read ID, sequence, and quality scores.  
  
See
[`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md)
for an explanation of quality.  
  
Said dataframe can be produced from FASTQ via
[`read_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_fastq.md).
To read/write a modified FASTQ containing modification information
(SAM/BAM MM and ML tags) in the header lines, use
[`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md)
and
[`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md).

## Usage

``` r
write_fastq(
  dataframe,
  filename = NA,
  read_id_colname = "read",
  sequence_colname = "sequence",
  quality_colname = "quality",
  return = FALSE
)
```

## Arguments

- dataframe:

  Dataframe containing sequence information to write back to FASTQ. Must
  have columns for unique read ID and DNA sequence. Should also have a
  column for quality, unless wanting to fill in qualities with `"B"`.

- filename:

  `character`. File to write the FASTQ to. Recommended to end with
  `.fastq` (warns but works if not). If set to `NA` (default), no file
  will be output, which may be useful for testing/debugging.

- read_id_colname:

  `character`. The name of the column within the dataframe that contains
  the unique ID for each read. Defaults to `"read"`.

- sequence_colname:

  `character`. The name of the column within the dataframe that contains
  the DNA sequence for each read. Defaults to `"sequence"`.  
    
  The values within this column must be DNA sequences e.g. `"GGCGGC"`.

- quality_colname:

  `character`. The name of the column within the dataframe that contains
  the FASTQ quality scores for each read. Defaults to `"quality"`. If
  scores are not known, can be set to `NA` to fill in quality with
  `"B"`.  
    
  If not `NA`, must correspond to a column where the values are the
  FASTQ quality scores e.g. `"$12\">/2C;4:9F8:816E,6C3*,"` - see
  [`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md).

- return:

  `logical`. Boolean specifying whether this function should return the
  FASTQ (as a character vector of each line in the FASTQ), otherwise it
  will return `invisible(NULL)`. Defaults to `FALSE`.

## Value

`character vector`. The resulting FASTQ file as a character vector of
its constituent lines (or `invisible(NULL)` if `return` is `FALSE`).
This is probably mostly useful for debugging, as setting `filename`
within this function directly writes to FASTQ via
[`writeLines()`](https://rdrr.io/r/base/writeLines.html). Therefore,
defaults to returning `invisible(NULL)`.

## Examples

``` r
## Write to FASTQ (using filename = NA, return = FALSE
## to view as char vector rather than writing to file)
write_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = "quality",
    return = TRUE
)
#> Error in write_fastq(example_many_sequences, filename = NA, read_id_colname = "read",     sequence_colname = "sequence", quality_colname = "quality",     return = TRUE): '...' used in an incorrect context

## quality_colname = NA fills in quality with "B"
write_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = NA,
    return = TRUE
)
#> Error in write_fastq(example_many_sequences, filename = NA, read_id_colname = "read",     sequence_colname = "sequence", quality_colname = NA, return = TRUE): '...' used in an incorrect context
```
