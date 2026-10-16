# Insert blank items at specified indices in a vector ([`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md) helper)

This function takes a vector (e.g. the output of
[`extract_and_sort_sequences()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_sequences.md))
and inserts a specified "blank" value at the specified indices. If
`insert_before` is `TRUE` then the blank value will be inserted before
each specified index, whereas if `insert_before` is `FALSE` then the
blank value will be inserted after each specified index.

## Usage

``` r
insert_at_indices(
  original_vector,
  insertion_indices,
  insert_before = TRUE,
  insert = "",
  vert = NA
)
```

## Arguments

- original_vector:

  `vector`. The vector to insert blanks into at specified locations
  (e.g. vector of sequences from extract_and_sort_sequences, but doesn't
  have to be).

- insertion_indices:

  `integer vector`. The indices (1-indexed) at which blanks should be
  inserted. If length 0, no blanks will be inserted.

- insert_before:

  `logical`. Whether blanks should be inserted before (`TRUE`, default)
  or after (`FALSE`) each specified index. Values must be sorted and
  unique.

- insert:

  `value`. The value that should be inserted before/after each specified
  index. Defaults to `""`. If length 0, nothing will be inserted. If
  length \> 1, multiple items will be inserted at each specified index.

- vert:

  `numerical`. The vertical distance into the box that index annotations
  will be drawn. If set to `NA` (default) does nothing so that this
  function is more generalisable. If set to a number, then the `insert`
  will be repeated `ceiling(vert)` times each time it is inserted.

## Value

`vector`. The original vector but with the `insert` value added
before/after each specified index.

## Examples

``` r
insert_at_indices(c("A", "B", "C", "D", "E"), c(2, 4))
#> [1] "A" ""  "B" "C" ""  "D" "E"

insert_at_indices(
    c("A", "B", "C", "D", "E"),
    c(2, 4),
    insert_before = TRUE,
    insert = 0
)
#> [1] "A" "0" "B" "C" "0" "D" "E"

insert_at_indices(
    c("A", "B", "C", "D", "E"),
    c(2, 4),
    insert_before = FALSE,
    insert = 0
)
#> [1] "A" "B" "0" "C" "D" "0" "E"

insert_at_indices(
    original_vector = c("A", "B", "C", "D", "E"),
    insertion_indices = c(1, 4, 6),
    insert_before = TRUE,
    insert = c("X", "Y")
)
#> Warning: One or more indices are beyond the length of the vector and will be ignored.
#> Length: 5
#> Indices: 1, 4, 6
#> [1] "X" "Y" "A" "B" "C" "X" "Y" "D" "E"

insert_at_indices(
    list("A", "B", "C", "D", "E"),
    c(2, 4),
    insert = TRUE
)
#> [[1]]
#> [1] "A"
#> 
#> [[2]]
#> [1] TRUE
#> 
#> [[3]]
#> [1] "B"
#> 
#> [[4]]
#> [1] "C"
#> 
#> [[5]]
#> [1] TRUE
#> 
#> [[6]]
#> [1] "D"
#> 
#> [[7]]
#> [1] "E"
#> 

insert_at_indices(
    list("A", "B", "C", "D", "E"),
    c(2, 4),
    insert_before = FALSE,
    insert = list(TRUE, 7)
)
#> [[1]]
#> [1] "A"
#> 
#> [[2]]
#> [1] "B"
#> 
#> [[3]]
#> [1] TRUE
#> 
#> [[4]]
#> [1] 7
#> 
#> [[5]]
#> [1] "C"
#> 
#> [[6]]
#> [1] "D"
#> 
#> [[7]]
#> [1] TRUE
#> 
#> [[8]]
#> [1] 7
#> 
#> [[9]]
#> [1] "E"
#> 

insert_at_indices(
    NA,
    c(1, 2),
    FALSE
)
#> Warning: One or more indices are beyond the length of the vector and will be ignored.
#> Length: 1
#> Indices: 1, 2
#> [1] NA ""

insert_at_indices(
    c("A", "B", "C", "D", "E"),
    integer(0)
)
#> [1] "A" "B" "C" "D" "E"
```
