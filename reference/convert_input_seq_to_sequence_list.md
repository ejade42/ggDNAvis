# Split a single input sequence into a vector of "lines" for visualisation ([`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md) helper)

Takes a single input sequence and an integer line length, and splits the
input sequence into lines of that length (with the last line potentially
being shorter).  
  
Optionally inserts empty strings `""` after each line to space them out.

## Usage

``` r
convert_input_seq_to_sequence_list(
  input_seq,
  line_length,
  spacing = 1,
  start_spaces = FALSE,
  end_spaces = FALSE
)
```

## Arguments

- input_seq:

  `character`. A DNA/RNA sequence (or for the purposes of this function,
  any string, though only DNA/RNA will work with later functions) to be
  split up.

- line_length:

  `integer`. How long each line (split-up section) should be.

- spacing:

  `integer`. How many blank lines to leave before/after each line of
  sequence. Defaults to `0`.

- start_spaces:

  `logical`. Whether blank lines should also be present before the first
  line of sequence. Defaults to `FALSE`.

- end_spaces:

  `logical`. Whether blank lines should also be present after the last
  line of sequence. Defaults to `FALSE`.

## Value

`character vector`. The input sequence split into multiple lines, with
specified spacing in between.

## Examples

``` r
convert_input_seq_to_sequence_list(
    "GGCGGCGGC",
    line_length = 6,
    spacing = 1,
    start_spaces = TRUE,
    end_spaces = TRUE
)
#> [1] ""       "GGCGGC" ""       "GGC"    ""      

convert_input_seq_to_sequence_list(
    "GGCGGCGGC",
    line_length = 3,
    spacing = 2
)
#> [1] "GGC" ""    ""    "GGC" ""    ""    "GGC"

convert_input_seq_to_sequence_list(
    "GGCGGCGGC",
    line_length = 3,
    spacing = 2,
    end_spaces = TRUE
)
#> [1] "GGC" ""    ""    "GGC" ""    ""    "GGC" ""    ""   

convert_input_seq_to_sequence_list(
    "GGCGGCGGC",
    line_length = 6,
    spacing = 0,
    start_spaces = TRUE,
    end_spaces = FALSE
)
#> [1] "GGCGGC" "GGC"   
```
