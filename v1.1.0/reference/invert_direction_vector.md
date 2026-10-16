# Invert direction vector ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md) helper)

This function takes a vector of read directions (e.g.
`c("reverse", "forward", "reverse", "reverse")`) and changes each value
to be the opposite (i.e.
`c("forward", "reverse", "forward", "forward"`).  
  

## Usage

``` r
invert_direction_vector(direction_vector)
```

## Arguments

- direction_vector:

  `character vector`. A vector of read directions. Must contain only
  `"forward"` and `"reverse"`, but is not case sensitive.

## Value

`character vector`. The same vector but with each value switched for its
opposite.

## Details

Not case-sensitive, but output is always lowercase.

## Examples

``` r
invert_direction_vector(c("forward", "REveRse", "forWard"))
#> [1] "reverse" "forward" "reverse"
```
