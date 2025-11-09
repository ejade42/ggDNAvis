# Visualise a single DNA/RNA sequence

This function takes a DNA/RNA sequence and returns a ggplot visualising
it, with the option to directly export a png image with appropriate
dimensions. Colours, line wrapping, index annotation interval, and
pixels per square when exported are configurable.

## Usage

``` r
visualise_single_sequence(
  sequence,
  sequence_colours = sequence_colour_palettes$ggplot_style,
  background_colour = "white",
  line_wrapping = 75,
  spacing = 1,
  margin = 0.5,
  sequence_text_colour = "black",
  sequence_text_size = 16,
  index_annotation_colour = "darkred",
  index_annotation_size = 12.5,
  index_annotation_interval = 15,
  index_annotations_above = TRUE,
  index_annotation_vertical_position = 1/3,
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

- sequence:

  `character`. A DNA or RNA sequence to visualise e.g. `"AAATGCTGC"`.

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

- line_wrapping:

  `integer`. The number of bases that should be on each line before
  wrapping. Defaults to `75`. Recommended to make this a multiple of the
  repeat unit size (e.g. 3*n* for a trinucleotide repeat) if visualising
  a repeat sequence.

- spacing:

  `integer`. The number of blank lines between each line of sequence.
  Defaults to `1`.  
    
  Be careful when setting to `0` as this means annotations have no space
  so might render strangely. Recommended to set
  `index_annotation_interval = 0` if doing so to disable annotations
  entirely.

- margin:

  `numeric`. The size of the margin relative to the size of each base
  square. Defaults to `0.5` (half the side length of each base
  square).  
    
  Note that if index annotations are on (i.e.
  `index_annotation_interval` is not `0`), the top/bottom margin
  (depending on `index_annotations_above`) will always be at least 1 to
  leave space for them.  
    
  Likewise, very small margins (\\\le\\0.25) may cause thick outlines to
  be cut off at the edges of the plot. Recommended to either use a wider
  margin or a smaller `outline_linewidth`.

- sequence_text_colour:

  `character`. The colour of the text within the bases (e.g. colour of
  "A" letter within boxes representing adenosine bases). Defaults to
  black.

- sequence_text_size:

  `numeric`. The size of the text within the bases (e.g. size of "A"
  letter within boxes representing adenosine bases). Defaults to `16`.
  Set to `0` to hide sequence text (show box colours only).

- index_annotation_colour:

  `character`. The colour of the little numbers underneath indicating
  base index (e.g. colour "15" label under the 15th base). Defaults to
  dark red.

- index_annotation_size:

  `numeric`. The size of the little number underneath indicating base
  index (e.g. size of "15" label under the 15th base). Defaults to
  `12.5`.  
    
  Setting to `0` disables index annotations.

- index_annotation_interval:

  `integer`. The frequency at which numbers should be placed underneath
  indicating base index, starting counting from the leftmost base in
  each row. Defaults to `15` (every 15 bases along each row).  
    
  Recommended to make this a factor/divisor of the line wrapping length
  (meaning the final base in each line is annotated), otherwise the
  numbering interval resetting at the beginning of each row will result
  in uneven intervals at each line break.  
    
  Setting to `0` disables index annotations.

- index_annotations_above:

  `logical`. Whether index annotations should go above (`TRUE`, default)
  or below (`FALSE`) each line of sequence.

- index_annotation_vertical_position:

  `numeric`. How far annotation numbers should be rendered above (if
  `index_annotations_above = TRUE`) or below (if
  `index_annotations_above = FALSE`) each base. Defaults to `1/3`.  
    
  Not recommended to change at all. Strongly discouraged to set below 0
  or above 1.

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
  image. Large values recommended because text needs to be legible when
  rendered significantly smaller than a box. Defaults to `100`.

## Value

A ggplot object containing the full visualisation, or `invisible(NULL)`
if `return = FALSE`. It is often more useful to use
`filename = "myfilename.png"`, because then the visualisation is
exported at the correct aspect ratio.

## Examples

``` r
# \donttest{
## Create sequence to visualise
sequence <- paste(c(rep("GGC", 72), rep("GGAGGAGGCGGC", 15)), collapse = "")

## Visualise with all defaults
## This looks ugly because it isn't at the right scale/aspect ratio
visualise_single_sequence(sequence)


## Export with all defaults rather than returning
visualise_single_sequence(
    sequence,
    filename = "example_vss_01.png",
    return = FALSE
)
## View exported image
image <- png::readPNG("example_vss_01.png")
unlink("example_vss_01.png")
grid::grid.newpage()
grid::grid.raster(image)


## Export while customising appearance
visualise_single_sequence(
    sequence,
    filename = "example_vss_02.png",
    return = FALSE,
    sequence_colours = sequence_colour_palettes$bright_pale,
    sequence_text_colour = "white",
    background_colour = "lightgrey",
    line_wrapping = 60,
    spacing = 2,
    outline_linewidth = 0,
    index_annotations_above = FALSE,
    margin = 0
)
## View exported image
image <- png::readPNG("example_vss_02.png")
unlink("example_vss_02.png")
grid::grid.newpage()
grid::grid.raster(image)

# }
```
