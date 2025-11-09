# Rasterise a vector of sequences into a numerical dataframe for ggplotting (generic `ggDNAvis` helper)

Takes a character vector of sequences (which are allowed to be empty
`""` to act as a spacing line) and rasterises it into a dataframe that
ggplot can read.

## Usage

``` r
create_image_data(sequences)
```

## Arguments

- sequences:

  `character vector`. A vector of sequences for plotting, e.g.
  `c("ATCG", "", "GGCGGC", "")`. Each sequence will be plotted
  left-aligned on a new line.

## Value

`dataframe`. Rasterised dataframe representation of the sequences,
readable by
[`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html).

## Examples

``` r
create_image_data(c("ATCG", "", "GGCGGC", ""))
#>             x     y layer
#> 1  0.08333333 0.875     1
#> 2  0.25000000 0.875     4
#> 3  0.41666667 0.875     2
#> 4  0.58333333 0.875     3
#> 5  0.75000000 0.875     0
#> 6  0.91666667 0.875     0
#> 7  0.08333333 0.625     0
#> 8  0.25000000 0.625     0
#> 9  0.41666667 0.625     0
#> 10 0.58333333 0.625     0
#> 11 0.75000000 0.625     0
#> 12 0.91666667 0.625     0
#> 13 0.08333333 0.375     3
#> 14 0.25000000 0.375     3
#> 15 0.41666667 0.375     2
#> 16 0.58333333 0.375     3
#> 17 0.75000000 0.375     3
#> 18 0.91666667 0.375     2
#> 19 0.08333333 0.125     0
#> 20 0.25000000 0.125     0
#> 21 0.41666667 0.125     0
#> 22 0.58333333 0.125     0
#> 23 0.75000000 0.125     0
#> 24 0.91666667 0.125     0
```
