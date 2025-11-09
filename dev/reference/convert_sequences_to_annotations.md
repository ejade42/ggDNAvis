# Convert a vector of sequences to a dataframe for plotting sequence contents and index annotations ([`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md) helper)

Takes the sequence list output from
[`convert_input_seq_to_sequence_list()`](https://ejade42.github.io/ggDNAvis/reference/convert_input_seq_to_sequence_list.md)
and creates a dataframe specifying x and y coordinates and the character
to plot at each coordinate. This applies to both the sequence itself
(e.g. determining where on the plot to place an `"A"`) and the
periodicit annotations of index number (e.g. determining where on the
plot to annotate base number `15`).

## Usage

``` r
convert_sequences_to_annotations(
  sequences,
  line_length,
  interval = 15,
  annotations_above = TRUE,
  annotation_vertical_position = 1/3
)
```

## Arguments

- sequences:

  `character vector`. Sequence to be plotted, split into lines and
  optionally including blank spacer lines. Output of
  [`convert_input_seq_to_sequence_list()`](https://ejade42.github.io/ggDNAvis/reference/convert_input_seq_to_sequence_list.md).

- line_length:

  `integer`. How long each line should be.

- interval:

  `integer`. How frequently bases should be annotated with their index.
  Defaults to `15`.

- annotations_above:

  `logical`. Whether annotations should go above (`TRUE`, default) or
  below (`FALSE`) each line of sequence.

- annotation_vertical_position:

  `numeric`. How far annotation numbers should be rendered above (if
  `index_annotations_above = TRUE`) or below (if
  `index_annotations_above = FALSE`) each base. Defaults to `1/3`. Not
  recommended to change at all. Strongly discouraged to set below 0 or
  above 1.

## Value

`dataframe` Dataframe of coordinates and labels (e.g. `"A"` or `"15`),
readable by geom_text.

## Examples

``` r
convert_sequences_to_annotations(
    c("GGCGGC", "", "ATCG", ""),
    line_length = 6,
    interval = 3,
    annotations_above = TRUE,
    annotation_vertical_position = 1/3
)
#>    x_position y_position annotation     type
#> 1  0.08333333  0.8750000          G Sequence
#> 2  0.25000000  0.8750000          G Sequence
#> 3  0.41666667  0.8750000          C Sequence
#> 4  0.41666667  1.0833333          3   Number
#> 5  0.58333333  0.8750000          G Sequence
#> 6  0.75000000  0.8750000          G Sequence
#> 7  0.91666667  0.8750000          C Sequence
#> 8  0.91666667  1.0833333          6   Number
#> 9  0.08333333  0.3750000          A Sequence
#> 10 0.25000000  0.3750000          T Sequence
#> 11 0.41666667  0.3750000          C Sequence
#> 12 0.41666667  0.5833333          9   Number
#> 13 0.58333333  0.3750000          G Sequence

convert_sequences_to_annotations(
    c("GGCGGC", "", "ATCG", ""),
    line_length = 6,
    interval = 0
)
#>    x_position y_position annotation     type
#> 1  0.08333333      0.875          G Sequence
#> 2  0.25000000      0.875          G Sequence
#> 3  0.41666667      0.875          C Sequence
#> 4  0.58333333      0.875          G Sequence
#> 5  0.75000000      0.875          G Sequence
#> 6  0.91666667      0.875          C Sequence
#> 7  0.08333333      0.375          A Sequence
#> 8  0.25000000      0.375          T Sequence
#> 9  0.41666667      0.375          C Sequence
#> 10 0.58333333      0.375          G Sequence
```
