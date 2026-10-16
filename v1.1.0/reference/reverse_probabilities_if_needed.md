# Reverse modification probabilities if needed ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md) helper)

This function takes a vector of condensed modification probabilities
(e.g. `c("128,0,63,255", "3,78,1"`) and a vector of directions (which
must all be either `"forward"` or `"reverse"`, *not* case-sensitive),
and returns a vector of condensed modification probabilities where those
that were originally forward are unchanged, and those that were
originally reverse are flipped to now be forward.  
  
Called by
[`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
to create a forward dataset, alongside
[`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md),
[`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md),
and
[`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md).  
  

## Usage

``` r
reverse_probabilities_if_needed(probabilities_vector, direction_vector)
```

## Arguments

- probabilities_vector:

  `character vector`. The probabilities to be reversed for each
  sequence/read. Each read should have one character value, representing
  a comma-separated list of the modification probabilities for each
  assessed base along the read e.g. `"230,7,64,145"`. In most situations
  these will be 8-bit integers from 0 to 255, but this function will
  work on any comma-separated values.  
    
  These comma-separated characters/strings can be produced from numeric
  vectors via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md)
  and converted back to vectors via
  [`string_to_vector()`](https://ejade42.github.io/ggDNAvis/reference/string_to_vector.md).

- direction_vector:

  `character vector`. Whether each sequence is forward or reverse. Must
  contain only `"forward"` and `"reverse"`, but is not case sensitive.
  Must be the same length as `probabilities_vector`.

## Value

`character vector`. A vector of all forward versions of the input
probabilities vector.

## Examples

``` r
reverse_probabilities_if_needed(
    probabilities_vector = c("100,200,50", "100,200,50"),
    direction_vector = c("forward", "reverse")
)
#> [1] "100,200,50" "50,200,100"
```
