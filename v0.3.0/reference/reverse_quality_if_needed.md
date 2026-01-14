# Reverse qualities if needed ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md) helper)

This function takes a vector of FASTQ qualities and a vector of
directions (which must all be either `"forward"` or `"reverse"`, *not*
case-sensitive) and returns a vector of forward qualities.  
  
Qualities of reads that were forward to begin with are unchanged, while
qualities of reads that were reverse are now flipped to give the
corresponding forward quality scores.  
  
Called by
[`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
to create a forward dataset, alongside
[`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md),
[`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md),
and
[`reverse_probabilities_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_probabilities_if_needed.md).

## Usage

``` r
reverse_quality_if_needed(quality_vector, direction_vector)
```

## Arguments

- quality_vector:

  `character vector`. The qualities to be reversed. See
  [`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md)
  for an explanation of quality scores.

- direction_vector:

  `character vector`. Whether each sequence is forward or reverse. Must
  contain only `"forward"` and `"reverse"`, but is not case sensitive.
  Must be the same length as `sequence_vector`.

## Value

`character vector`. A vector of all forward versions of the input
quality vector.

## Examples

``` r
reverse_quality_if_needed(
    quality_vector = c("#^$&$*", "#^$&$*"),
    direction_vector = c("reverse", "forward")
)
#> [1] "*$&$^#" "#^$&$*"
```
