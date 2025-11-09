# Map a single base to the corresponding number (generic `ggDNAvis` helper)

This function takes a single base and numerically encodes it for
visualisation via
[`rasterise_matrix()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_matrix.md).  
  
Encoding: `A = 1`, `C = 2`, `G = 3`, `T/U = 4`.

## Usage

``` r
convert_base_to_number(base)
```

## Arguments

- base:

  `character`. A single DNA/RNA base to encode numerically (e.g. `"A"`).

## Value

`integer`. The corresponding number.

## Examples

``` r
convert_base_to_number("A")
#> [1] 1
convert_base_to_number("c")
#> [1] 2
convert_base_to_number("g")
#> [1] 3
convert_base_to_number("T")
#> [1] 4
convert_base_to_number("u")
#> [1] 4
```
