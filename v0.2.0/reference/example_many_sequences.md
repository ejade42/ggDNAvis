# Example multiple sequences data

A collection of made-up sequences in the style of long reads over a
repeat region (e.g. *NOTCH2NLC*), with meta-data describing the
participant each read is from and the family each participant is from.
Can be used in
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md),
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md),
and helper functions to visualise these sequences.  
  
Generation code is available at `data-raw/example_many_sequences.R`

## Usage

``` r
example_many_sequences
```

## Format

### `example_many_sequences`

A dataframe with 23 rows and 10 columns:

- family:

  Participant family

- individual:

  Participant ID

- read:

  Unique read ID

- sequence:

  DNA sequence of the read

- sequence_length:

  Length (nucleotides) of the read

- quality:

  FASTQ quality scores for the read. Each character represents a score
  from 0 to 40 - see
  [`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md).  
    
  These values are made up via
  `pmin(pmax(round(rnorm(n, mean = 20, sd = 10)), 0), 40)` i.e. sampled
  from a normal distribution with mean 20 and standard deviation 10,
  then rounded to integers between 0 and 40 (inclusive) - see
  `example_many_sequences.R`

- methylation_locations:

  Indices along the read (starting at 1) at which methylation
  probability was assessed i.e. CpG sites. Stored as a single character
  value per read, condensed from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).

- methylation_probabilities:

  Probability of methylation (8-bit integer i.e. 0-255) for each
  assessed base. Stored as a single character value per read, condensed
  from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).  
    
  These values are made up via `round(runif(n, min = 0, max = 255))` -
  see `example_many_sequences.R`

- hydroxymethylation_locations:

  Indices along the read (starting at 1) at which hydroxymethylation
  probability was assessed i.e. CpG sites. Stored as a single character
  value per read, condensed from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).

- hydroxymethylation_probabilities:

  Probability of hydroxymethylation (8-bit integer i.e. 0-255) for each
  assessed base. Stored as a single character value per read, condensed
  from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).  
    
  These values are made up via
  `round(runif(n, min = 0, max = 255 - this_base_methylation_probability))`
  such that the summed methylation and hydroxymethylation probability
  never exceeds 255 (100%) - see `example_many_sequences.R`
