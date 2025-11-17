# Visualise many DNA/RNA sequences

`visualize_many_sequences()` is an alias for this function.  
\\ This function takes a vector of DNA/RNA sequences (each sequence can
be any length and they can be different lengths), and plots each
sequence as base-coloured squares along a single line. Setting
`filename` allows direct export of a png image with the correct
dimensions to make every base a perfect square. Empty strings (`""`)
within the vector can be utilised as blank spacing lines. Colours and
pixels per square when exported are configurable.

## Usage

``` r
visualise_many_sequences(
  sequences_vector,
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
  outline_colour = "black",
  outline_linewidth = 3,
  outline_join = "mitre",
  return = TRUE,
  filename = NA,
  render_device = ragg::agg_png,
  pixels_per_base = 100
)

visualize_many_sequences(
  sequences_vector,
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
  outline_colour = "black",
  outline_linewidth = 3,
  outline_join = "mitre",
  return = TRUE,
  filename = NA,
  render_device = ragg::agg_png,
  pixels_per_base = 100
)
```

## Arguments

- sequences_vector:

  `character vector`. The sequences to visualise, often created from a
  dataframe via
  [`extract_and_sort_sequences()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_sequences.md).
  E.g. `c("GGCGGC", "", "AGCTAGCTA")`.

- sequence_colours:

  `character vector`, length 4. A vector indicating which colours should
  be used for each base. In order:
  `c(A_colour, C_colour, G_colour, T/U_colour)`.  
    
  Defaults to red, green, blue, purple in the default shades produced by
  ggplot with 4 colours, i.e.
  `c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")`, accessed via
  [`sequence_colour_palettes`](https://ejade42.github.io/ggDNAvis/reference/sequence_colour_palettes.md)`$ggplot_style`.

- background_colour:

  `character`. The colour of the background. Defaults to white.

- margin:

  `numeric`. The size of the margin relative to the size of each base
  square. Defaults to `0.5` (half the side length of each base
  square).  
    
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
  image.  
    
  If text is shown (i.e. `sequence_text_size` is not 0), needs to be
  fairly large otherwise text is blurry. Defaults to `100`.

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
