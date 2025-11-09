# Convert MM tag to absolute index locations ([`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md) helper)

This function takes a sequence, a SAM-style vector of number of
potential target bases to skip in between each target base that was
actually assessed, and a target base type (defaults to `"C"` as
5-methylcytosine is most common).  
  
It identifies the indices/locations of all instances of the target base
within the sequence, and then goes along the vector of these indices,
skipping them if requested by `skips`.  
  
For example, the sequence `"GGCGGCGGCGGC"` with target `"C"` and skips
`c(0, 0, 1)` would identify that the indices where `"C"` occurs are
`c(3, 6, 9, 12)`. It would then take the first index, the second index,
skip one, and take the fourth index i.e. return `c(3, 6, 12)`. If
instead the skips were given as `c(0, 2)` it would take the first index,
skip two, and take the fourth index i.e. return `c(3, 12)`. If the skips
were given as `c(1, 1)` it would skip one, take the second index, skip
one, and take the fourth index i.e. return `c(6, 12)`.  
  
The length of `skips` corresponds to the number of indices/locations
that will be returned (i.e. the length of the returned locations
vector).  
  
Ideally the length of `skips` plus the sum of `skips` (i.e. the number
returned plus the total number skipped) is the same or less than the
number of possible locations. If it is the same, then the last possible
location will be taken; if it is less then some number of possible
locations at the end will be skipped.  
  
**Important:** if the length of `skips` plus the sum of `skips` is
greater than the number of possible locations (instances of the target
base within the sequence), then the total number of taken or skipped
locations will be greater than the number of available locations. In
this case, the returned vector will contain NA after the available
locations have run out. In the example above, `skips = c(0, 0, 0, 0, 0)`
would return `c(3, 6, 9, 12, NA)`, and `skips = c(0, 2, 0)` would return
`c(3, 12, NA)`.  
  
Therefore, if the target base is totally absent from the sequence (e.g.
target `"A"` in `"GGCGGCGGCGGC"`), then any non-zero length of `skips`
will return the same length of `NA`s e.g. `skips = c(0)` would return
`NA`, and `skips = c(0, 1, 0)` would return `c(NA, NA, NA)`.  
  
If `skips` has length zero, it will return `numeric(0)`.  
  
This function is reversed by
[`convert_locations_to_MM_vector()`](https://ejade42.github.io/ggDNAvis/reference/convert_locations_to_MM_vector.md).

## Usage

``` r
convert_MM_vector_to_locations(sequence, skips, target_base = "C")
```

## Arguments

- sequence:

  `character`. The DNA sequence about which the methylation information
  is being processed.

- skips:

  `integer vector`. A component of a SAM MM tag, representing the number
  of skipped target bases in between each assessed base.

- target_base:

  `character`. The base type that has been assessed or skipped (defaults
  to `"C"`).

## Value

`integer vector`. All of the base indices at which
methylation/modification information was processed. Will all be
instances of the target base.

## Examples

``` r
convert_MM_vector_to_locations(
    "GGCGGCGGCGGC",
    skips = c(0, 0, 0, 0),
    target_base = "C"
)
#> [1]  3  6  9 12

convert_MM_vector_to_locations(
    "GGCGGCGGCGGC",
    skips = c(1, 1, 1, 1),
    target_base = "G"
)
#> [1]  2  5  8 11

convert_MM_vector_to_locations(
    "GGCGGCGGCGGC",
    skips = c(0, 0, 2, 1, 0),
    target_base = "G"
)
#> [1]  1  2  7 10 11
```
