# Reverse sequences if needed ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md) helper)

This function takes a vector of DNA/RNA sequences and a vector of
directions (which must all be either `"forward"` or `"reverse"`, *not*
case-sensitive) and returns a vector of forward DNA/RNA sequences.  
  
Sequences in the vector that were forward to begin with are unchanged,
while sequences that were reverse are reverse-complemented via
[`reverse_complement()`](https://ejade42.github.io/ggDNAvis/reference/reverse_complement.md)
to produce the forward sequence.  
  
Called by
[`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
to create a forward dataset, alongside
[`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md),
[`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md)
and
[`reverse_probabilities_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_probabilities_if_needed.md).

## Usage

``` r
reverse_sequence_if_needed(
  sequence_vector,
  direction_vector,
  output_mode = "DNA"
)
```

## Arguments

- sequence_vector:

  `character vector`. The DNA or RNA sequences to be reversed, e.g.
  `c("ATCG", "GGCGGC", "AUUAUA")`. Accepts DNA, RNA, or mixed input.

- direction_vector:

  `character vector`. Whether each sequence is forward or reverse. Must
  contain only `"forward"` and `"reverse"`, but is not case sensitive.
  Must be the same length as `sequence_vector`.

- output_mode:

  `character`. Whether reverse-complemented sequences should be
  converted to DNA (i.e. A complements to T), RNA (i.e. A complements to
  U), or not complemented at all. Must be `"DNA"` (default), `"RNA"`, or
  `"reverse_only"` to reverse sequence order without complementing.
  *Only affects reverse-complemented sequences. Sequences that were
  forward to begin with are not altered.*

## Value

`character vector`. A vector of all forward versions of the input
sequence vector.

## Examples

``` r
reverse_sequence_if_needed(
    sequence_vector = c("TAAGGC", "TAAGGC"),
    direction_vector = c("reverse", "forward")
)
#> [1] "GCCTTA" "TAAGGC"

reverse_sequence_if_needed(
    sequence_vector = c("UAAGGC", "UAAGGC"),
    direction_vector = c("reverse", "forward"),
    output_mode = "RNA"
)
#> [1] "GCCUUA" "UAAGGC"

reverse_sequence_if_needed(
    sequence_vector = c("TAAGGC", "TAAGGC"),
    direction_vector = c("reverse", "forward"),
    output_mode = "reverse_only"
)
#> [1] "CGGAAT" "TAAGGC"
```
