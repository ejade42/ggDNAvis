# Visualise many DNA/RNA sequences

`visualize_many_sequences()` is an alias for
`visualise_many_sequences()` - see
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).

This function takes a vector of DNA/RNA sequences (each sequence can be
any length and they can be different lengths), and plots each sequence
as base-coloured squares along a single line. Setting `filename` allows
direct export of a png image with the correct dimensions to make every
base a perfect square. Empty strings (`""`) within the vector can be
utilised as blank spacing lines. Colours and pixels per square when
exported are configurable.

## Usage

``` r
visualise_many_sequences(
  sequences_vector,
  ...,
  sequence_colours = sequence_colour_palettes$ggplot_style,
  background_colour = "white",
  margin = 0.5,
  sequence_text_colour = "black",
  sequence_text_size = 16,
  index_annotation_lines = c(1),
  index_annotation_colour = "darkred",
  index_annotation_size = 12.5,
  index_annotation_interval = 15,
  index_annotations_above = TRUE,
  index_annotation_vertical_position = 1/3,
  index_annotation_full_line = TRUE,
  index_annotation_always_first_base = TRUE,
  index_annotation_always_last_base = TRUE,
  outline_colour = "black",
  outline_linewidth = 3,
  outline_join = "mitre",
  return = TRUE,
  filename = NA,
  force_raster = FALSE,
  render_device = ragg::agg_png,
  pixels_per_base = 100,
  monitor_performance = FALSE
)
```

## Arguments

- sequences_vector:

  `character vector`. The sequences to visualise, often created from a
  dataframe via
  [`extract_and_sort_sequences()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_sequences.md).
  E.g. `c("GGCGGC", "", "AGCTAGCTA")`.

- ...:

  Used to recognise aliases e.g. American spellings or common
  misspellings - see
  [aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).
  If any American spellings do not work, please make a bug report at
  <https://github.com/ejade42/ggDNAvis/issues>.

- sequence_colours:

  `character vector`, length 4. A vector indicating which colours should
  be used for each base. In order:
  `c(A_colour, C_colour, G_colour, T/U_colour)`.  
    
  Defaults to red, green, blue, purple in the default shades produced by
  ggplot with 4 colours, i.e.
  `c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")`, accessed via
  [`sequence_colour_palettes`](https://ejade42.github.io/ggDNAvis/reference/sequence_colour_palettes.md)`$ggplot_style`.

- background_colour:

  `character`. The colour the background should be drawn (defaults to
  white).

- margin:

  `numeric`. The size of the margin relative to the size of each base
  square. Defaults to `0.5` (half the side length of each base
  square).  
    
  Note that index annotations can require a minimum margin size at the
  top or bottom if present above the first/below the last row. This is
  handled automatically but can mean the top/bottom margin is sometimes
  larger than the `margin` setting.  
    
  Very small margins (\\\le\\0.25) may cause thick outlines to be cut
  off at the edges of the plot. Recommended to either use a wider margin
  or a smaller `outline_linewidth`.

- sequence_text_colour:

  `character`. The colour of the text within the bases (e.g. colour of
  "A" letter within boxes representing adenosine bases). Defaults to
  black.

- sequence_text_size:

  `numeric`. The size of the text within the bases (e.g. size of "A"
  letter within boxes representing adenosine bases). Defaults to `16`.
  Set to `0` to hide sequence text (show box colours only).

- index_annotation_lines:

  `integer vector`. The lines (i.e. elements of `sequences_vector`) that
  should have their base incides annotated. 1-indexed e.g. `c(1, 10)`
  would annotate the first and tenth elements of `sequences_vector`.  
    
  Extra lines are inserted above or below (depending on
  `index_annotations_above`) the selected lines - note that the line
  numbers come from `sequences_vector`, so are unaffected by these
  insertions.  
    
  Setting to `NA` disables index annotations (and prevents adding
  additional blank lines). Defaults to `c(1)` i.e. first sequence is
  annotated.  
    
  Note:
  [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  and `visualise_many_sequences()` accept `NA`, `NULL`, `numeric(0)`,
  `0`, and `FALSE` as meaning "annotations off".

- index_annotation_colour:

  `character`. The colour of the little numbers underneath indicating
  base index (e.g. colour of "15" label under the 15th base). Defaults
  to dark red.

- index_annotation_size:

  `numeric`. The size of the little number underneath indicating base
  index (e.g. size of "15" label under the 15th base). Defaults to
  `12.5`.  
    
  Setting to `0` disables index annotations (and prevents adding
  additional blank lines).

- index_annotation_interval:

  `integer`. The frequency at which numbers should be placed underneath
  indicating base index, starting counting from the leftmost base.
  Defaults to `15` (every 15 bases along each row).  
    
  Setting to `0` disables index annotations (and prevents adding
  additional blank lines).

- index_annotations_above:

  `logical`. Whether index annotations should go above (`TRUE`, default)
  or below (`FALSE`) each line of sequence.

- index_annotation_vertical_position:

  `numeric`. How far annotation numbers should be rendered above (if
  `index_annotations_above = TRUE`) or below (if
  `index_annotations_above = FALSE`) each base. Defaults to `1/3`.  
    
  Not recommended to change at all. Strongly discouraged to set below 0
  or above 1.

- index_annotation_full_line:

  `logical`. Whether index annotations should continue to the end of the
  longest sequence (`TRUE`, default) or should only continue as far as
  each selected line does (`FALSE`).

- index_annotation_always_first_base:

  `logical`. Whether to force the first base in each line to always be
  annotated regardless of whether it occurs at the
  `index_annotation_interval`. Defaults to `TRUE`.

- index_annotation_always_last_base:

  `logical`. Whether to force the last base in each line to always be
  annotated regardless of whether it occurs at the
  `index_annotation_interval`. Defaults to `TRUE`.

- outline_colour:

  `character`. The colour of the box outlines. Defaults to black.

- outline_linewidth:

  `numeric`. The linewidth of the box outlines. Defaults to `3`. Set to
  `0` to disable box outlines.

- outline_join:

  `character`. One of `"mitre"`, `"round"`, or `"bevel"` specifying how
  outlines should be joined at the corners of boxes. Defaults to
  `"mitre"`. It would be unusual to need to change this.

- return:

  `logical`. Boolean specifying whether this function should return the
  ggplot object, otherwise it will return `invisible(NULL)`. Defaults to
  `TRUE`.

- filename:

  `character`. Filename to which output should be saved. If set to `NA`
  (default), no file will be saved. Recommended to end with `".png"`,
  but can change if render device is changed.

- force_raster:

  `logical`. Boolean specifying whether
  [`ggplot2::geom_raster()`](https://ggplot2.tidyverse.org/reference/geom_tile.html)
  should be used even if it will remove text and outlines. Defaults to
  `FALSE`.  
    
  To make the detailed plots with box outlines, sequence text, and index
  annotations,
  [`ggplot2::geom_tile()`](https://ggplot2.tidyverse.org/reference/geom_tile.html)
  is used. However, `geom_tile` is slower for huge datasets, so there is
  an option to use `geom_raster` instead. `geom_raster` does not support
  box outlines, sequence text, or index annotations, but is much faster
  if only the colours are wanted.  
    
  `geom_raster` is automatically used if it will not change the plot
  (i.e. if all extraneous elements are already off), but can be forced
  using this argument.

- render_device:

  `function/character`. Device to use when rendering. See
  [`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
  documentation for options. Defaults to
  [`ragg::agg_png`](https://ragg.r-lib.org/reference/agg_png.html). Can
  be set to `NULL` to infer from file extension, but results may vary
  between systems.

- pixels_per_base:

  `integer`. How large each box should be in pixels, if file output is
  turned on via setting `filename`. Corresponds to dpi of the exported
  image. Defaults to `100`.  
    
  Large values (e.g. 100) are required to render small text properly.
  Small values (e.g. 20) will work when sequence/annotation text is off,
  and very small values (e.g. 10) will work when sequence/annotation
  text and outlines are all off.

- monitor_performance:

  `logical`. Boolean specifying whether verbose performance monitoring
  should be messaged to console. Defaults to `FALSE`.

## Value

A ggplot object containing the full visualisation, or `invisible(NULL)`
if `return = FALSE`. It is often more useful to use
`filename = "myfilename.png"`, because then the visualisation is
exported at the correct aspect ratio.

## Examples

``` r
# \donttest{
## Create sequences vector
sequences <- extract_and_sort_sequences(example_many_sequences)

## Visualise example_many_sequences with all defaults
## This looks ugly because it isn't at the right scale/aspect ratio
visualise_many_sequences(sequences)


## Export with all defaults rather than returning
visualise_many_sequences(
    sequences,
    filename = "example_vms_01.png",
    return = FALSE
)
## View exported image
image <- png::readPNG("example_vms_01.png")
unlink("example_vms_01.png")
grid::grid.newpage()
grid::grid.raster(image)


## Export while customising appearance
visualise_many_sequences(
    sequences,
    filename = "example_vms_02.png",
    return = FALSE,
    sequence_colours = sequence_colour_palettes$bright_pale,
    sequence_text_colour = "white",
    index_annotation_interval = 3,
    index_annotation_lines = 1:51,
    index_annotation_full_line = FALSE,
    index_annotation_always_first_base = FALSE,
    index_annotation_always_last_base = FALSE,
    background_colour = "lightgrey",
    outline_linewidth = 0,
    margin = 0
)
## View exported image
image <- png::readPNG("example_vms_02.png")
unlink("example_vms_02.png")
grid::grid.newpage()
grid::grid.raster(image)

# }
```
