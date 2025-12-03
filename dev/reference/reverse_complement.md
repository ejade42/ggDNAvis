# Reverse complement a DNA/RNA sequence (generic `ggDNAvis` helper)

This function takes a string/character representing a DNA/RNA sequence
and returns the reverse complement. Either DNA (`A/C/G/T`) or RNA
(`A/C/G/U`) input is accepted.

By default, output is DNA (so `A` is reverse-complemented to `T`), but
it can be set to output RNA (so `A` is reverse-complemented to `U`).

Alternatively, if `output_mode` is set to `"reverse_only"` then the
sequence will be reversed as-is without being complemented.

## Usage

``` r
reverse_complement(sequence, output_mode = "DNA")
```

## Arguments

- sequence:

  `character`. A DNA/RNA sequence (`A/C/G/T/U`) to be
  reverse-complemented. No other characters allowed. Only one sequence
  allowed.

- output_mode:

  `character`. `"DNA"` (default) or `"RNA"` to determine whether `A`
  should be reverse-complemented to `T` or `U` respectively, or
  `"reverse_only"` to reverse the order of the characters without
  complementing.

## Value

`character`. The reverse-complement of the input sequence.

## Examples

``` r
reverse_complement("ATGCTAG")
#> [1] "CTAGCAT"
reverse_complement("ATGCTAG", output_mode = "reverse_only")
#> [1] "GATCGTA"
reverse_complement("UUAUUAGC", output_mode = "RNA")
#> [1] "GCUAAUAA"
reverse_complement("AcGtU", output_mode = "DNA")
#> [1] "AACGT"
reverse_complement("aCgTU", output_mode = "RNA")
#> [1] "AACGU"
```
