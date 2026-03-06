# Split a `","`-joined string back to a vector (generic `ggDNAvis` helper)

Takes a string (character) produced by
[`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md)
and recreates the vector.  
  
Note that if a vector of multiple strings is input (e.g.
`c("1,2,3", "9,8,7"`)) the output will be a single concatenated vector
(e.g. `c(1, 2, 3, 9, 8, 7)`).  
  
If the desired output is a list of vectors, try
[`lapply()`](https://rdrr.io/r/base/lapply.html) e.g.
`lapply(c("1,2,3", "9,8,7"), string_to_vector)` returns
`list(c(1, 2, 3), c(9, 8, 7))`.

## Usage

``` r
string_to_vector(string, type = "numeric", sep = ",")
```

## Arguments

- string:

  `character`. A comma-separated string (e.g. `"1,2,3"`) to convert back
  to a vector.

- type:

  `character`. The type of the vector to be returned i.e. `"numeric"`
  (default), `"character"`, or `"logical"`.

- sep:

  `character`. The character used to separate values in the string.
  Defaults to `","`. *Do not set to anything that might occur within one
  of the values*.

## Value

`<type> vector`. The resulting vector (e.g. `c(1, 2, 3)`).

## Examples

``` r
## String to numeric vector (default)
string_to_vector("1,2,3,4")
#> [1] 1 2 3 4
string_to_vector("1,2,3,4", type = "numeric")
#> [1] 1 2 3 4
string_to_vector("1;2;3;4", sep = ";")
#> [1] 1 2 3 4

## String to character vector
string_to_vector("A,B,C,D", type = "character")
#> [1] "A" "B" "C" "D"

## String to logical vector
string_to_vector("TRUE FALSE TRUE", type = "logical", sep = " ")
#> [1]  TRUE FALSE  TRUE

## By default, vector inputs are concatenated
string_to_vector(c("1,2,3", "4,5,6"))
#> [1] 1 2 3 4 5 6

## To create a list of vector outputs, use lapply()
lapply(c("1,2,3", "4,5,6"), string_to_vector)
#> [[1]]
#> [1] 1 2 3
#> 
#> [[2]]
#> [1] 4 5 6
#> 
```
