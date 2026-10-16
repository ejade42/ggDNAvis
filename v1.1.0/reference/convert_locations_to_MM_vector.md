# Convert absolute index locations to MM tag ([`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md) helper)

This function takes a vector of modified base locations as absolute
indices (i.e. a `1` would mean the first base in the sequence has been
assessed for modification; a `15` would mean the 15th base has), and
converts it to a vector in the format of the SAM/BAM MM tags. The MM tag
defines a particular target base (e.g. `C` for methylation), and then
stores the number of skipped instances of that base between sites where
modification was assessed. In practice, this often means counting the
number of non-CpG `C`s in between CpG `C`s. In a `GGC` repeat, this
should be a bunch of `0`s as every `C` is in a CpG, but unique sequence
will have many non-CpG `C`s.  
  
This function is reversed by
[`convert_MM_vector_to_locations()`](https://ejade42.github.io/ggDNAvis/reference/convert_MM_vector_to_locations.md).

## Usage

``` r
convert_locations_to_MM_vector(sequence, locations, target_base = "C")
```

## Arguments

- sequence:

  `character`. The DNA sequence about which the methylation information
  is being processed.

- locations:

  `integer vector`. All of the base indices at which
  methylation/modification information was processed. Must all be
  instances of the target base.

- target_base:

  `character`. The base type that has been assessed or skipped (defaults
  to `"C"`).

## Value

`integer vector`. A component of a SAM MM tag, representing the number
of skipped target bases in between each assessed base.

## Examples

``` r
convert_locations_to_MM_vector(
    "GGCGGCGGCGGC",
    locations = c(3, 6, 9, 12),
    target_base = "C"
)
#> [1] 0 0 0 0

convert_locations_to_MM_vector(
    "GGCGGCGGCGGC",
    locations = c(1, 4, 7, 10),
    target_base = "G"
)
#> [1] 0 1 1 1

convert_locations_to_MM_vector(
    "GGCGGCGGCGGC",
    locations = c(1, 2, 4, 5, 7, 8, 10, 11),
    target_base = "G"
)
#> [1] 0 0 0 0 0 0 0 0
```
