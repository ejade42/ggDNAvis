# Convert vector of sequences to character matrix (generic `ggDNAvis` helper)

This function takes a vector of sequences (e.g. input to
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
or
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md),
or vector split from input to
[`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md)).
It converts it into a matrix e.g. `c("GGCGGC", "", "ACGT", "")` would
become:

    G  G  C  G  G  C
    NA NA NA NA NA NA
    A  C  G  T  NA NA
    NA NA NA NA NA NA

The resulting matrix can then be rasterised into a coordinate-value
dataframe via
[`rasterise_matrix()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_matrix.md).

## Usage

``` r
convert_sequences_to_matrix(sequences, line_length = NA, blank_value = NA)
```

## Arguments

- sequences:

  `character vector`. The sequences to transform into a matrix

- line_length:

  `integer`. The width of the matrix. Set to `NA` (default) to
  automatically use the length of the longest sequence in `sequences`.

- blank_value:

  `value`. The value that should be used to fill in blank/missing points
  of the matrix.

## Value

`matrix`. A matrix of the sequences with one line per sequence, ready
for rasterisation via
[`rasterise_matrix()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_matrix.md).

## Examples

``` r
convert_sequences_to_matrix(
    sequences = c("GGCGGC", "", "ACGT", "")
)
#>      [,1] [,2] [,3] [,4] [,5] [,6]
#> [1,] "G"  "G"  "C"  "G"  "G"  "C" 
#> [2,] NA   NA   NA   NA   NA   NA  
#> [3,] "A"  "C"  "G"  "T"  NA   NA  
#> [4,] NA   NA   NA   NA   NA   NA  

convert_sequences_to_matrix(
    sequences = c("GGCGGC", "", "ACGT", ""),
    line_length = 10,
    blank_value = "X"
)
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#> [1,] "G"  "G"  "C"  "G"  "G"  "C"  "X"  "X"  "X"  "X"  
#> [2,] "X"  "X"  "X"  "X"  "X"  "X"  "X"  "X"  "X"  "X"  
#> [3,] "A"  "C"  "G"  "T"  "X"  "X"  "X"  "X"  "X"  "X"  
#> [4,] "X"  "X"  "X"  "X"  "X"  "X"  "X"  "X"  "X"  "X"  
```
