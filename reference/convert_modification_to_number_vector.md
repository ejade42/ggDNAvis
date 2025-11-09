# Convert string-ified modification probabilities and locations to a single vector of probabilities ([`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md) helper)

Takes modification locations (indices along the read signifying bases at
which modification probability was assessed) and modification
probabilities (the probability of modification at each assessed
location, as an integer from 0 to 255), as comma-separated strings (e.g.
`"1,5,25"`) produced from numerical vectors via
[`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).
Outputs a numerical vector of the modification probability for each base
along the read. i.e. -2 for indices outside sequences, -1 for bases
where modification was not assessed, and probability from 0-255 for
bases where modification was assessed.

## Usage

``` r
convert_modification_to_number_vector(
  modification_locations_str,
  modification_probabilities_str,
  max_length,
  sequence_length
)
```

## Arguments

- modification_locations_str:

  `character`. A comma-separated string representing a condensed
  numerical vector (e.g. `"3,6,9,12"`, produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the indices along the read at which modification was assessed.
  Indexing starts at 1.

- modification_probabilities_str:

  `character`. A comma-separated string representing a condensed
  numerical vector (e.g. `"2,212,128,64"`, produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the probability of modification as an 8-bit (0-255) integer for
  each base where modification was assessed.

- max_length:

  `integer`. How long the output vector should be.

- sequence_length:

  `integer`. How long the sequence itself is. If smaller than
  `max_length`, the remaining spaces will be filled with `-2`s i.e. set
  to the background colour in
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md).

## Value

`numeric vector`. A vector of length `max_length` indicating the
probability of methylation at each index along the read - 0 where
methylation was not assessed, and probability from 0-255 where
methylation was assessed.

## Examples

``` r
convert_modification_to_number_vector(
    modification_locations_str = "3,6,9,12",
    modification_probabilities = "100,200,50,150",
    max_length = 15,
    sequence_length = 13
)
#>  [1]  -1  -1 100  -1  -1 200  -1  -1  50  -1  -1 150  -1  -2  -2
```
