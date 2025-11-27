# Process index annotations and rasterise to a x/y/layer dataframe (generic `ggDNAvis` helper)

This function is called by
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md),
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md),
and
[`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md)
to create the x/y position data for placing the index annotations on the
graph. Its arguments are either intermediate variables produced by the
visualisation functions, or arguments of the visualisation functions
directly passed through.  
  
Returns a dataframe with `x_position`, `y_position`, and `value`
columns, where the values are the index annotations.

## Usage

``` r
rasterise_index_annotations(
  new_sequences_vector,
  original_sequences_vector,
  original_indices_to_annotate,
  annotation_interval = 15,
  annotate_full_lines = TRUE,
  annotations_above = TRUE,
  annotation_vertical_position = 1/3,
  sum_indices = FALSE,
  spacing = NA,
  offset_start = 0
)
```

## Arguments

- new_sequences_vector:

  `vector`. The output of
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  when used with identical arguments.

- original_sequences_vector:

  `vector`. The vector of sequences used for plotting, that was
  originally given to
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)/[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  or split from the input sequence to
  [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md).
  Must also have been used as input to
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  to create `new_sequences_vector`.

- original_indices_to_annotate:

  `positive integer vector`. The vector of lines (i.e. indices) of
  `original_vector` to be annotated. Read from `index_annotation_lines`
  argument to
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)/[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  (but after processing, so is assumed to be unique and sorted). Must
  also have been used as input to
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  to create `new_sequences_vector`. Setting to a length-0 value (e.g.
  `numeric(0)`) causes this function to return an empty dataframe.

- annotation_interval:

  `integer`. The frequency at which numbers should be placed underneath
  indicating base index, starting counting from the leftmost base.
  Setting to `0` causes this function to return an empty dataframe.
  Defaults to `15`.

- annotate_full_lines:

  `logical`. Whether annotations should be calculated up to the end of
  the longest line (`TRUE`, default) or to the end of each line being
  annotated (`FALSE`).

- annotations_above:

  `logical`. Whether annotations should be drawn above (`TRUE`, default)
  or below (`FALSE`) each annotated line. Must also have been used as
  input to
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  to create `new_sequences_vector`.

- annotation_vertical_position:

  `numeric`. The vertical position above/below each annotated line that
  annotations should be drawn. Must also have been used as input to
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  to create `new_sequences_vector`.

- sum_indices:

  `logical`. Whether indices should be counted separately along each
  line (`FALSE`, default) or summed along all annotated lines (`TRUE`).
  May behave unexpectedly if `TRUE` when `annotate_full_lines` is also
  `TRUE`.

- spacing:

  `integer`. The number of blank lines inserted for each index
  annotation. Set to `NA` (default) to infer from
  `annotation_vertical_position`.

- offset_start:

  `integer`. The number of blank lines not present at the start, that
  otherwise would be expected based on `spacing` or
  `annotation_vertical_position`. Defaults to `0`.

## Value

`dataframe`. A dataframe with columns `x`, `y`, and `value`, with one
observation per annotation number that needs to be drawn onto the
ggplot.

## Examples
