# Changelog

## ggDNAvis (development version)

New features:

- [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
  and
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  now have index annotations!

  - Arguments controlling size, colour, position, and frequency are the
    same as for
    [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md).
  - `index_annotation_lines` controls which lines (counting down from
    the top) have annotations.
  - `index_annotation_full_line` controls whether annotations go to the
    end of each annotated sequence, or all the way to the end of the
    image.
  - Unlike
    [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md),
    index annotations in
    [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
    and
    [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
    reset each line as each line is a different sequence.

- [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  now has the ability to draw sequence and probability text!

- All function, argument, and data names now have aliases i.e. accept
  American spellings

  - Every instance of `visualise` should now also work with `visualize`
    e.g. [`visualize_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md).
  - Every instance of `colour` should now also work with `color` and
    `col` e.g. `sequence_text_color` or `background_col`.
  - There is a minor exception in that
    [`visualise_methylation_colour_scale()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation_colour_scale.md)
    accepts
    [`visualize_methylation_color_scale()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation_colour_scale.md)
    but does not accept `col` in the function name (and does not accept
    mixing `visualise` with `color` or `visualize` with `colour`).
  - Some aliases are set up for common typos, especially regarding
    pluralisation. In particular, `index_annotations_above` also accepts
    `index_annotation_above`, and `index_annotation_full_line` accepts
    any combination of `annotation` and `line` being plural or single.
  - If any aliases which ought to work don’t, please raise an issue at
    <https://github.com/ejade42/ggDNAvis/issues> and they can be easily
    added.

- [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md),
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md),
  and
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  can now use
  [`geom_raster()`](https://ggplot2.tidyverse.org/reference/geom_tile.html)
  instead of
  [`geom_tile()`](https://ggplot2.tidyverse.org/reference/geom_tile.html)
  when sequence text, index annotations, and box outlines are off. This
  provides a moderate performance improvement and can be forced via
  `force_raster = TRUE`.

- [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md),
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md),
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md),
  and
  [`visualise_methylation_colour_scale()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation_colour_scale.md)
  all now have a `monitor_performance` argument which prints the time
  taken for each step. This is mostly for internal debugging purposes.

User-facing changes:

- Changed
  [`extract_methylation_from_dataframe()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_methylation.md)
  to now return a list of 4 vectors instead of 3, with `sequences`
  added. `sequence_lengths` is still returned just in case it’s useful
  for anything, but it is no longer used in
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md),
  which now takes the sequences directly rather than their lengths.

- Removed warning for “incorrectly” removing index annotations. Now
  setting any relevant argument to 0/empty
  (e.g. `index_annotation_size = 0`, `index_annotation_interval = 0`,
  `index_annotation_lines = numeric(0)`) will automatically change the
  “main” one to remove annotations.

- Massively improved
  [`rasterise_matrix()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_matrix.md)
  performance by vectorising calculations.

- Changed default `pixels_per_base` from `20` to `100` for
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  because there is now the option for index and sequence text, which
  requires a higher resolution to be legible.

New helper functions:

- [`bad_arg()`](https://ejade42.github.io/ggDNAvis/reference/bad_arg.md) -
  throws an error with information (e.g. name, class, value) about a
  problematic argument.

- [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md) -
  inserts blank lines for index annotations in
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
  and
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md).

- `create_many_sequence_index_annotations()` - calculates coordinates
  and labels for index annotations in
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
  and
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md).

Background changes:

- Starting changing all argument validation to use
  [`bad_arg()`](https://ejade42.github.io/ggDNAvis/reference/bad_arg.md).

- Enforced version requirement for ggplot2 (\>= 4.0.0).

## ggDNAvis 0.3.2

CRAN release: 2025-10-31

- Added files related to pkgdown website building to .Rbuildignore so
  they are not part of the R package anymore (this caused a CRAN
  rejection).

## ggDNAvis 0.3.1

Bug fixes:

- Fixed 1-pixel-wide border appearing between the panel and the margin
  when using non-white background colours

## ggDNAvis 0.3.0

CRAN release: 2025-10-01

Changes:

- Removed `raster::raster()` dependency

- Added new
  [`rasterise_matrix()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_matrix.md)
  function to do rasterisation

- Changed `convert_input_seq_to_sequence_list()` behaviour:

  - Instead of additional spacing lines always being added before or
    after first line of sequence, there are now independent boolean
    settings for whether there should be spacing lines before and
    whether there should be spacing lines after.

Bug fixes:

- Fixed critical error with plot matching lenience on some local linux
  systems that resulted in tests failing

- Inserted additional padding blank lines above/below with
  `index_annotation_vertical_position` \> 1 to avoid plot dimensions
  breaking
  ([`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md))

Known issues remaining:

- Related to ggplot v4.0.0:

  - Pixel rendering changes means rectangles sometimes fail to render in
    visualise_methylation_colour_scale(), resulting in the appearance of
    vertical white lines. This depends on the precision and exact export
    size.

  - There is a faint line around the panel area with non-white
    backgrounds.

## ggDNAvis 0.2.1

CRAN release: 2025-09-21

- Documented that
  [`debug_join_vector_num()`](https://ejade42.github.io/ggDNAvis/reference/debug_join_vector_num.md)
  and
  [`debug_join_vector_str()`](https://ejade42.github.io/ggDNAvis/reference/debug_join_vector_str.md)
  do not return a value

- Changed some reference images to account for ggplot2 updating to
  v4.0.0

## ggDNAvis 0.2.0

- Initial CRAN submission

- Initial functionality:

  - Visualise single DNA sequences, multiple DNA sequences, and DNA
    modification (e.g. methylation):
    [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md),
    [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md),
    [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)

  - Read and write FASTQ, including modified FASTQ produced with -T
    MM,ML that stores modification information in the header rows:
    [`read_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_fastq.md),
    [`write_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_fastq.md),
    [`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md),
    [`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md)

  - Intelligently merge with metadata including read direction, and
    reverse all information for reverse reads only to make all reads
    “forward” versions:
    [`merge_fastq_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_fastq_with_metadata.md),
    [`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
