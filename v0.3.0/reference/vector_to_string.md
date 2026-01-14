# Join a vector into a comma-separated string (generic `ggDNAvis` helper)

Takes a vector and condenses it into a single string by joining items
with `","`. Reversed by
[`string_to_vector()`](https://ejade42.github.io/ggDNAvis/reference/string_to_vector.md).

## Usage

``` r
vector_to_string(vector, sep = ",")
```

## Arguments

- vector:

  `vector`. A vector (e.g. `c(1,2,3)`) to convert to a string.

- sep:

  `character`. The character used to separate values in the string.
  Defaults to `","`. *Do not set to anything that might occur within one
  of the values*.

## Value

`character`. The same vector but as a comma-separated string (e.g.
`"1,2,3"`).

## Examples

``` r
vector_to_string(c(1, 2, 3, 4))
#> [1] "1,2,3,4"
vector_to_string(c("These", "are", "some", "words"))
#> [1] "These,are,some,words"
vector_to_string(3:5, sep = ";")
#> [1] "3;4;5"
```
