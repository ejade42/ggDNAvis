# Write modification information stored in dataframe back to modified FASTQ

This function takes a dataframe containing DNA modification information
(e.g. produced by
[`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md))
and writes it back to modified FASTQ, equivalent to what would be
produced via `samtools fastq -T MM,ML`.  
  
Arguments give the names of columns within the dataframe from which to
read.  
  
If multiple types of modification have been assessed (e.g. both
methylation and hydroxymethylation), then multiple colnames must be
provided for locations and probabilites, and multiple prefixes (e.g.
`"C+h?"`) must be provided. **IMPORTANT:** These three vectors must all
be the same length, and the modification types must be in a consistent
order (e.g. if writing hydroxymethylation and methylation in that order,
must do H then M in all three vectors and never vice versa).  
  
If quality isn't known (e.g. there was a FASTA step at some point in the
pipeline), the `quality` argument can be set to `NA` to fill in quality
scores with `"B"`. This is the same behaviour as SAMtools v1.21 when
converting FASTA to SAM/BAM then FASTQ. I don't really know why SAMtools
decided the default quality should be "B" but there was probably a
reason so I have stuck with that.  
  
Default arguments are set up to work with the included
[`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
data.

## Usage

``` r
write_modified_fastq(
  dataframe,
  filename = NA,
  read_id_colname = "read",
  sequence_colname = "sequence",
  quality_colname = "quality",
  locations_colnames = c("hydroxymethylation_locations", "methylation_locations"),
  probabilities_colnames = c("hydroxymethylation_probabilities",
    "methylation_probabilities"),
  modification_prefixes = c("C+h?", "C+m?"),
  include_blank_tags = TRUE,
  return = FALSE
)
```

## Arguments

- dataframe:

  `dataframe`. Dataframe containing modification information to write
  back to modified FASTQ. Must have columns for unique read ID, DNA
  sequence, and at least one set of locations and probabilities for a
  particular modification type (e.g. 5C methylation).

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

- locations_colnames:

  `character vector`. Vector of the names of all columns within the
  dataframe that contain modification locations. Defaults to
  `c("hydroxymethylation_locations", "methylation_locations")`.  
    
  The values within these columns must be comma-separated strings of
  indices at which modification was assessed, as produced by
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md),
  e.g. `"3,6,9,12"`.  
    
  Will fail if these locations are not instances of the target base
  (e.g. `"C"` for `"C+m?"`), as the SAMtools tag system does not work
  otherwise. One consequence of this is that if sequences have been
  reversed via
  [`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
  or helpers, they cannot be written to FASTQ *unless* modification
  locations are symmetric e.g. CpG *and* offset was set to `1` when
  reversing (see
  [`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md)).

- probabilities_colnames:

  `character vector`. Vector of the names of all columns within the
  dataframe that contain modification probabilities. Defaults to
  `c("hydroxymethylation_probabilities", "methylation_probabilities")`.  
    
  The values within the columns must be comma-separated strings of
  modification probabilities, as produced by
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md),
  e.g. `"0,255,128,78"`.

- modification_prefixes:

  `character vector`. Vector of the prefixes to be used for the MM tags
  specifying modification type. These are usually generated by
  Dorado/Guppy based on the original modified basecalling settings, and
  more details can be found in the SAM optional tag specifications.
  Defaults to `c("C+h?", "C+m?")`.  
    
  `locations_colnames`, `probabilities_colnames`, and
  `modification_prefixes` must all have the same length e.g. 2 if there
  were 2 modification types assessed.

- include_blank_tags:

  `logical`. Boolean specifying what to do if a particular read has no
  assessed locations for a given modification type from
  `modification_prefixes`.  
    
  If `TRUE` (default), blank tags will be written e.g. `"C+h?;"`
  (whereas a normal, non-blank tag looks like `"C+h?,0,0,0,0;"`). If
  `FALSE`, tags with no assessed locations in that read will not be
  written at all.

- return:

  `logical`. Boolean specifying whether this function should return the
  FASTQ (as a character vector of each line in the FASTQ), otherwise it
  will return `invisible(NULL)`. Defaults to `FALSE`.

## Value

`character vector`. The resulting modified FASTQ file as a character
vector of its constituent lines (or `invisible(NULL)` if `return` is
`FALSE`). This is probably mostly useful for debugging, as setting
`filename` within this function directly writes to FASTQ via
[`writeLines()`](https://rdrr.io/r/base/writeLines.html). Therefore,
defaults to returning `invisible(NULL)`.

## Examples

``` r
## Write to FASTQ (using filename = NA, return = FALSE
## to view as char vector rather than writing to file)
write_modified_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = "quality",
    locations_colnames = c("hydroxymethylation_locations",
                           "methylation_locations"),
    probabilities_colnames = c("hydroxymethylation_probabilities",
                               "methylation_probabilities"),
    modification_prefixes = c("C+h?", "C+m?"),
    return = TRUE
)
#> Error in write_modified_fastq(example_many_sequences, filename = NA, read_id_colname = "read",     sequence_colname = "sequence", quality_colname = "quality",     locations_colnames = c("hydroxymethylation_locations", "methylation_locations"),     probabilities_colnames = c("hydroxymethylation_probabilities",         "methylation_probabilities"), modification_prefixes = c("C+h?",         "C+m?"), return = TRUE): '...' used in an incorrect context

## Write methylation only, and fill in qualities with "B"
write_modified_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = NA,
    locations_colnames = c("methylation_locations"),
    probabilities_colnames = c("methylation_probabilities"),
    modification_prefixes = c("C+m?"),
    return = TRUE
)
#> Error in write_modified_fastq(example_many_sequences, filename = NA, read_id_colname = "read",     sequence_colname = "sequence", quality_colname = NA, locations_colnames = c("methylation_locations"),     probabilities_colnames = c("methylation_probabilities"),     modification_prefixes = c("C+m?"), return = TRUE): '...' used in an incorrect context
```
