# Map a sequence to a vector of numbers (generic `ggDNAvis` helper)

This function takes a sequence and encodes it as a vector of numbers for
visualisation via
[`rasterise_matrix()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_matrix.md).  
  
Encoding: `A = 1`, `C = 2`, `G = 3`, `T/U = 4`.

## Usage

``` r
convert_sequence_to_numbers(sequence, length = NA)
```

## Arguments

- sequence:

  `character`. A DNA/RNA sequence (`A/C/G/T/U`) to be encoded
  numerically. No other characters allowed. Only one sequence allowed.

- length:

  `integer`. How long the output numerical vector should be. If shorter
  than the sequence, the vector will include the first *n* bases up to
  this length. If longer than the sequence, the vector will be padded
  with 0s at the end. If left blank/set to `NA` (default), will output a
  vector the same length as the input sequence.

## Value

`integer vector`. The numerical encoding of the input sequence,
cut/padded to the desired length.

## Examples

``` r
convert_sequence_to_numbers("ATCGATCG")
#> [1] 1 4 2 3 1 4 2 3
convert_sequence_to_numbers("ATCGATCG", length = NA)
#> [1] 1 4 2 3 1 4 2 3
convert_sequence_to_numbers("ATCGATCG", length = 4)
#> [1] 1 4 2 3
convert_sequence_to_numbers("ATCGATCG", length = 10)
#>  [1] 1 4 2 3 1 4 2 3 0 0
```
