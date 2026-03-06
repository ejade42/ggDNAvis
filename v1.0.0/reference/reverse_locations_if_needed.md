# Reverse modification locations if needed ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md) helper)

This function takes a vector of condensed modification locations/indices
(e.g. `c("3,6,9,12", "1,4,7,10")`), a vector of directions (which must
all be either `"forward"` or `"reverse"`, *not* case-sensitive), and a
vector of sequence lengths (integers).  
  
Returns a vector of condensed locations where reads that were originally
forward are unchanged, and reads that were originally reverse are
flipped to now be forward.  
  
Optionally, a numerical offset can be set. If this is left at `0` (the
default value), then a CpG assessed for methylation would be
reverse-complemented to a CG with the modification information ascribed
to the G (as the G is at the location where the actual modified C was on
the other strand). However, setting the offset to `1` would shift all of
the modification indices by 1 such that the modification is now ascribed
to the C of the reverse-strand CG. This is beneficial for visualising
the modifications as it ensures consistency between originally-forward
and originally-reverse strands by making the modification score
associated with each CpG site always be located at the C, but may be
misleading for quantitative analysis. Setting the offset to anything
other than `0` or `1` should work but may be biologically misleading, so
produces a warning.  
  
Called by
[`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
to create a forward dataset, alongside
[`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md),
[`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md),
and
[`reverse_probabilities_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_probabilities_if_needed.md).  
  
**Example:**  
  
Forward sequence, with indices of Cs in CpGs numbered:  

    C C C A G G C G G C G G C G A C C G A
                7     10    13      17

(length = 19, locations = `"7,10,13,17"`, CpGs = 7-8, 10-11, 13-14,
17-18)  
  
Reverse sequence, with indices of C in CpGs numbered:  

    T C G G T C G C C G C C G C C T G G G
      2       6     9     12

(length = 19, locations = `"2,6,9,12"`, CpGs = 2-3, 6-7, 9-10, 12-13)  
  
As CG reverse-complements to itself, each CpG site has a 1:1
correspondence with a CpG site in the reverse strand. Many methylation
calling models assess C-methylation at the C of each CpG. To map the
locations from C to C, we take `19 - <index>` such that `"7,10,13,17"`
becomes `"12,9,6,2"` and `"2,6,9,12"` becomes `"17,13,10,7"`. The
symmetry of CpGs means mapping from C to C is also symmetric. *This is
achieved by setting **`offset = 1`**, as mapping C to C involves
shifting position by 1.*  
  
Conversely, to map the locations from C to G (i.e. preserving the actual
location of each modification, which is required if assessed locations
are non-symmetric/don't reverse-complement to themselves like CpGs do),
we take `20 - <index>` such that `"7,10,13,17"` becomes `"13,10,7,3"`
i.e. the indices of the Gs in CpGs in the reverse sequence. Likewise
`"2,6,9,12"` becomes `"18,14,11,8"` i.e. the indices of the Gs in CpGs
in the forward sequence. *This is achieved by setting **`offset = 0`**,
as mapping C to G preserves the actual original position at which each
modification was assessed, but changes the base to its complement.*  
  
In general, new locations are calculated as
`(<length> + 1 - <offset>) - <index>`. Of course, output locations are
reversed before returning so that they all return in ascending order, as
is standard for all location vectors/strings.  
  
If wanting to write reversed sequences to FASTQ via
[`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md),
locations must be symmetric (e.g. CpG) and offset must be set to 1.
Asymmetric locations are impossible to write to modified FASTQ once
reversed because then e.g. cytosine methylation will be assessed at
guanines, which SAMtools can't account for. Symmetrically reversing CpGs
via `offset = 1` is the only way to fix this.

## Usage

``` r
reverse_locations_if_needed(
  locations_vector,
  direction_vector,
  length_vector,
  offset = 0
)
```

## Arguments

- locations_vector:

  `character vector`. The locations to be reversed for each
  sequence/read. Each read should have one character value, representing
  a comma-separated list of indices at which modification was assessed
  along the read e.g. `"3,6,9,12"` for all the `Cs` in `GGCGGCGGCGGC`.  
    
  These comma-separated characters/strings can be produced from numeric
  vectors via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md)
  and converted back to vectors via
  [`string_to_vector()`](https://ejade42.github.io/ggDNAvis/reference/string_to_vector.md).

- direction_vector:

  `character vector`. Whether each sequence is forward or reverse. Must
  contain only `"forward"` and `"reverse"`, but is not case sensitive.
  Must be the same length as `locations_vector` and `length_vector`.

- length_vector:

  `integer vector`. The length of each sequence. Needed for reversing
  locations as locations are stored relative to the start of the read
  i.e. relative to the end of the reverse read. Must be the same length
  as `locations_vector` and `direction_vector`.

- offset:

  `integer`. How much locations should be shifted by. Defaults to `0`.
  This is important because if a CpG is assessed for methylation at the
  C, then reverse complementing it will give a methylation score at the
  G on the reverse-complemented strand. This is the most biologically
  accurate, but for visualising methylation it may be desired to shift
  the locations by `1` i.e. to correspond with the C in the
  reverse-complemented CpG rather than the G, which allows for
  consistent visualisation between forward and reverse strands. Setting
  (integer) values other than `0` or `1` will work, but may be
  biologically misleading so it is not recommended.

## Value

`character vector`. A vector of all forward versions of the input
locations vector.

## Examples

``` r
reverse_locations_if_needed(
    locations_vector = c("7,10,13,17", "2,6,9,12"),
    direction_vector = c("forward", "reverse"),
    length_vector = c(19, 19),
    offset = 0
)
#> [1] "7,10,13,17" "8,11,14,18"

reverse_locations_if_needed(
    locations_vector = c("7,10,13,17", "2,6,9,12"),
    direction_vector = c("forward", "reverse"),
    length_vector = c(19, 19),
    offset = 1
)
#> [1] "7,10,13,17" "7,10,13,17"
```
