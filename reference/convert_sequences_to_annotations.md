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
#> Error in convert_sequences_to_annotations(c("GGCGGC", "", "ATCG", ""),     line_length = 6, interval = 3, annotations_above = TRUE,     annotation_vertical_position = 1/3): could not find function "convert_sequences_to_annotations"

convert_sequences_to_annotations(
    c("GGCGGC", "", "ATCG", ""),
    line_length = 6,
    interval = 0
)
#> Error in convert_sequences_to_annotations(c("GGCGGC", "", "ATCG", ""),     line_length = 6, interval = 0): could not find function "convert_sequences_to_annotations"
```
