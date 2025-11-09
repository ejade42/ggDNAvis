# Rasterise a matrix to an x/y/layer dataframe (generic `ggDNAvis` helper)

This function takes a matrix and rasterises it to a dataframe of x and y
coordinates, such that the matrix occupies the space from (0, 0) to
(1, 1) and each element of the matrix represents a rectangle with width
1/ncol(matrix) and height 1/nrow(matrix). The "layer" column of the
dataframe is simply the value of each element of the matrix.

## Usage

``` r
rasterise_matrix(image_matrix)
```

## Arguments

- image_matrix:

  `matrix`. A matrix (or anything that can be coerced to a matrix via
  [`base::as.matrix()`](https://rdrr.io/r/base/matrix.html)).

## Value

`dataframe`. A dataframe containing x and y coordinates for the centre
of a rectangle per element of the matrix, such that the whole matrix
occupies the space from (0, 0) to (1, 1). Additionally contains a layer
column storing the value of each element of the matrix.

## Examples

``` r
## Create numerical matrix
example_matrix <- matrix(1:16, ncol = 4, nrow = 4, byrow = TRUE)

## View
example_matrix
#>      [,1] [,2] [,3] [,4]
#> [1,]    1    2    3    4
#> [2,]    5    6    7    8
#> [3,]    9   10   11   12
#> [4,]   13   14   15   16

## Rasterise
rasterise_matrix(example_matrix)
#>        x     y layer
#> 1  0.125 0.875     1
#> 2  0.375 0.875     2
#> 3  0.625 0.875     3
#> 4  0.875 0.875     4
#> 5  0.125 0.625     5
#> 6  0.375 0.625     6
#> 7  0.625 0.625     7
#> 8  0.875 0.625     8
#> 9  0.125 0.375     9
#> 10 0.375 0.375    10
#> 11 0.625 0.375    11
#> 12 0.875 0.375    12
#> 13 0.125 0.125    13
#> 14 0.375 0.125    14
#> 15 0.625 0.125    15
#> 16 0.875 0.125    16



## Create character matrix
example_matrix <- matrix(
    c("A", "B", "C", "D", "E",
      "F", "G", "H", "I", "J"),
    nrow = 2, ncol = 5, byrow = TRUE
)

## View
example_matrix
#>      [,1] [,2] [,3] [,4] [,5]
#> [1,] "A"  "B"  "C"  "D"  "E" 
#> [2,] "F"  "G"  "H"  "I"  "J" 

## Rasterise
rasterise_matrix(example_matrix)
#>      x    y layer
#> 1  0.1 0.75     A
#> 2  0.3 0.75     B
#> 3  0.5 0.75     C
#> 4  0.7 0.75     D
#> 5  0.9 0.75     E
#> 6  0.1 0.25     F
#> 7  0.3 0.25     G
#> 8  0.5 0.25     H
#> 9  0.7 0.25     I
#> 10 0.9 0.25     J



## Create realistic DNA matrix
dna_matrix <- matrix(
    c(0, 0, 0, 0, 0, 0, 0, 0,
      3, 3, 2, 3, 3, 2, 4, 4,
      0, 0, 0, 0, 0, 0, 0, 0,
      4, 1, 4, 1, 0, 0, 0, 0),
    nrow = 4, ncol = 8, byrow = TRUE
)

## View
dna_matrix
#>      [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#> [1,]    0    0    0    0    0    0    0    0
#> [2,]    3    3    2    3    3    2    4    4
#> [3,]    0    0    0    0    0    0    0    0
#> [4,]    4    1    4    1    0    0    0    0

## Rasterise
rasterise_matrix(dna_matrix)
#>         x     y layer
#> 1  0.0625 0.875     0
#> 2  0.1875 0.875     0
#> 3  0.3125 0.875     0
#> 4  0.4375 0.875     0
#> 5  0.5625 0.875     0
#> 6  0.6875 0.875     0
#> 7  0.8125 0.875     0
#> 8  0.9375 0.875     0
#> 9  0.0625 0.625     3
#> 10 0.1875 0.625     3
#> 11 0.3125 0.625     2
#> 12 0.4375 0.625     3
#> 13 0.5625 0.625     3
#> 14 0.6875 0.625     2
#> 15 0.8125 0.625     4
#> 16 0.9375 0.625     4
#> 17 0.0625 0.375     0
#> 18 0.1875 0.375     0
#> 19 0.3125 0.375     0
#> 20 0.4375 0.375     0
#> 21 0.5625 0.375     0
#> 22 0.6875 0.375     0
#> 23 0.8125 0.375     0
#> 24 0.9375 0.375     0
#> 25 0.0625 0.125     4
#> 26 0.1875 0.125     1
#> 27 0.3125 0.125     4
#> 28 0.4375 0.125     1
#> 29 0.5625 0.125     0
#> 30 0.6875 0.125     0
#> 31 0.8125 0.125     0
#> 32 0.9375 0.125     0
```
