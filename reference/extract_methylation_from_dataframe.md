# Extract methylation information from dataframe for visualisation

This function takes a dataframe that contains methylation information in
the form of locations (indices along the read signifying bases at which
modification probability was assessed) and probabilities (the
probability of modification at each assessed location, as an integer
from 0 to 255).  
  
Each observation/row in the dataframe represents one sequence (e.g. a
Nanopore read). In the locations and probabilities column, each sequence
(row) has many numbers associated. These are stored as one string per
observation e.g. `"3,6,9,12"`, with the column representing a character
vector of such strings (e.g. `c("3,6,9,12", "1,2,3,4")`).  
  
This function calls
[`extract_and_sort_sequences()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_sequences.md)
on each of these three columns and returns a list of vectors stored in
`$locations`, `$probabilities`, and `$lengths`. These can then be used
as input for
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md).  
  
Default arguments are set up to work with the included
[`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
data.

## Usage

``` r
extract_methylation_from_dataframe(
  modification_data,
  locations_colname = "methylation_locations",
  probabilities_colname = "methylation_probabilities",
  lengths_colname = "sequence_length",
  grouping_levels = c(family = 8, individual = 2),
  sort_by = "sequence_length",
  desc_sort = TRUE
)
```

## Arguments

- modification_data:

  `dataframe`. A dataframe that must contain columns for methylation
  locations, methylation probabilities, and sequence length for each
  read. The former two should be condensed strings as produced by
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md)
  e.g. `"1,2,3,4"`. The latter should be integer.  
    
  See
  [`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
  for an example of a compatible dataframe.

- locations_colname:

  `character`. The name of the column within the input dataframe that
  contains methylation/modification location information. Defaults to
  `"methylation_locations"`.  
    
  Values within this column must be a comma-separated string
  representing a condensed numerical vector (e.g. `"3,6,9,12"`, produced
  via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the indices along the read at which modification was assessed.
  Indexing starts at 1.

- probabilities_colname:

  `character`. The name of the column within the input dataframe that
  contains methylation/modification probability information. Defaults to
  `"methylation_probabilities"`.  
    
  Values within this column must be a comma-separated string
  representing a condensed numerical vector (e.g. `"2,212,128,64"`,
  produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the probability of modification as an 8-bit (0-255) integer for
  each base where modification was assessed.

- lengths_colname:

  `character`. The name of the column within the input dataframe that
  contains the length of each sequence. Defaults to
  `"sequence_length"`.  
    
  Values within this column must be non-negative integers.

- grouping_levels:

  `named character vector`. What variables should be used to define the
  groups/chunks, and how large a gap should be left between groups at
  that level. Set to `NA` to turn off grouping.  
    
  Defaults to `c("family" = 8, "individual" = 2)`, meaning the
  highest-level groups are defined by the `family` column, and there is
  a gap of 8 between each family. Likewise the second-level groups
  (within each family) are defined by the `individual` column, and there
  is a gap of 2 between each individual.  
    
  Any number of grouping variables and gaps can be given, as long as
  each grouping variable is a column within the dataframe. It is
  recommended that lower-level groups are more granular and subdivide
  higher-level groups (e.g. first divide into families, then into
  individuals within families).  
    
  To change the order of groups within a level, make that column a
  factor with the order specified e.g.
  `example_many_sequences$family <- factor(example_many_sequences$family, levels = c("Family 2", "Family 3", "Family 1"))`
  to change the order to Family 2, Family 3, Family 1.

- sort_by:

  `character`. The name of the column within the dataframe that should
  be used to sort/order the rows within each lowest-level group. Set to
  `NA` to turn off sorting within groups.  
    
  Recommended to be the length of the sequence information, as is the
  case for the default `"sequence_length"` which was generated via
  `example_many_sequences$sequence_legnth <- nchar(example_many_sequences$sequence)`.

- desc_sort:

  `logical`. Boolean specifying whether rows within groups should be
  sorted by the `sort_by` variable descending (`TRUE`, default) or
  ascending (`FALSE`).

## Value

`list`, containing `$locations` (`character vector`), `$probabilities`
(`character vector`), and `$lengths` (`numeric vector`).

## Examples

``` r
## See documentation for extract_and_sort_sequences()
## for more examples of changing sorting/grouping
extract_methylation_from_dataframe(
    example_many_sequences,
    locations_colname = "methylation_locations",
    probabilities_colname = "methylation_probabilities",
    lengths_colname = "sequence_length",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = "sequence_length",
    desc_sort = TRUE
)
#> Error in extract_methylation_from_dataframe(example_many_sequences, locations_colname = "methylation_locations",     probabilities_colname = "methylation_probabilities", lengths_colname = "sequence_length",     grouping_levels = c(family = 8, individual = 2), sort_by = "sequence_length",     desc_sort = TRUE): '...' used in an incorrect context

extract_methylation_from_dataframe(
    example_many_sequences,
    locations_colname = "hydroxymethylation_locations",
    probabilities_colname = "hydroxymethylation_probabilities",
    lengths_colname = "sequence_length",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = "sequence_length",
    desc_sort = TRUE
)
#> Error in extract_methylation_from_dataframe(example_many_sequences, locations_colname = "hydroxymethylation_locations",     probabilities_colname = "hydroxymethylation_probabilities",     lengths_colname = "sequence_length", grouping_levels = c(family = 8,         individual = 2), sort_by = "sequence_length", desc_sort = TRUE): '...' used in an incorrect context
```
