# Visualise methylation probabilities for many DNA sequences

`visualize_methylation()` is an alias for `visualise_methylation()` -
see
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).

This function takes vectors of modifications locations, modification
probabilities, and sequence lengths (e.g. created by
[`extract_methylation_from_dataframe()`](https://ejade42.github.io/ggDNAvis/reference/extract_methylation_from_dataframe.md))
and visualises the probability of methylation (or other modification)
across each read.

Assumes that the three main input vectors are of equal length \\n\\ and
represent \\n\\ sequences (e.g. Nanopore reads), where `locations` are
the indices along each read at which modification was assessed,
`probabilities` are the probability of modification at each assessed
site, and `lengths` are the lengths of each sequence.

For each sequence, renders non-assessed (e.g. non-CpG) bases as
`other_bases_colour`, renders background (including after the end of the
sequence) as `background_colour`, and renders assessed bases on a linear
scale from `low_colour` to `high_colour`.

Clamping means that the endpoints of the colour gradient can be set some
distance into the probability space e.g. with Nanopore \> SAM
probability values from 0-255, the default is to render 0 as fully blue
(`#0000FF`), 255 as fully red (`#FF0000`), and values in between
linearly interpolated. However, clamping with `low_clamp = 100` and
`high_clamp = 200` would set *all probabilities up to 100* as fully
blue, *all probabilities 200 and above* as fully red, and linearly
interpolate only over the `100-200` range.

A separate scalebar plot showing the colours corresponding to each
probability, with any/no clamping values, can be produced via
[`visualise_methylation_colour_scale()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation_colour_scale.md).

## Usage

``` r
visualise_methylation(
  modification_locations,
  modification_probabilities,
  sequences,
  low_colour = "blue",
  high_colour = "red",
  low_clamp = 0,
  high_clamp = 255,
  background_colour = "white",
  other_bases_colour = "grey",
  sequence_text_type = "none",
  sequence_text_scaling = c(-0.5, 256),
  sequence_text_rounding = 2,
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
  modified_bases_outline_colour = NA,
  modified_bases_outline_linewidth = NA,
  modified_bases_outline_join = NA,
  other_bases_outline_colour = NA,
  other_bases_outline_linewidth = NA,
  other_bases_outline_join = NA,
  margin = 0.5,
  return = TRUE,
  filename = NA,
  render_device = ragg::agg_png,
  pixels_per_base = 100,
  ...
)
```

## Arguments

- modification_locations:

  `character vector`. One character value for each sequence, storing a
  condensed string (e.g. `"3,6,9,12"`, produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the indices along the read at which modification was assessed.
  Indexing starts at 1.

- modification_probabilities:

  `character vector`. One character value for each sequence, storing a
  condensed string (e.g. `"0,128,255,15"`, produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the probability of methylation/modification at each assessed
  base.  
    
  Assumed to be Nanopore \> SAM style modification stored as an 8-bit
  integer from 0 to 255, but changing other arguments could make this
  work on other scales.

- sequences:

  `character vector`. One character value for each sequence, storing the
  actual DNA sequence.

- low_colour:

  `character`. The colour that should be used to represent minimum
  probability of methylation/modification (defaults to blue).

- high_colour:

  `character`. The colour that should be used to represent maximum
  probability of methylation/modification (defaults to red).

- low_clamp:

  `numeric`. The minimum probability below which all values are coloured
  `low_colour`. Defaults to `0` (i.e. no clamping). To specify a
  proportion probability in 8-bit form, multiply by 255 e.g. to
  low-clamp at 30% probability, set this to `0.3*255`.

- high_clamp:

  `numeric`. The maximum probability above which all values are coloured
  `high_colour`. Defaults to `255` (i.e. no clamping, assuming Nanopore
  \> SAM style modification calling where probabilities are 8-bit
  integers from 0 to 255).

- background_colour:

  `character`. The colour the background should be drawn (defaults to
  white).

- other_bases_colour:

  `character`. The colour non-assessed (e.g. non-CpG) bases should be
  drawn (defaults to grey).

- sequence_text_type:

  `character`. What type of text should be drawn in the boxes. One of
  `"sequence"` (to draw the base sequence in the boxes, similar to
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)),
  `"probability"` (to draw the numerical probability of methylation in
  each assessed box, optionally scaled via `sequence_text_scaling`), or
  `"none"` (default, to draw the boxes only with no text).

- sequence_text_scaling:

  `numeric vector, length 2`. The min and max possible probability
  values, used to facilitate scaling of the text in each to 0-1. Scaling
  is implemented as \\\frac{p - min}{max}\\, so custom scalings (e.g.
  scaled to 0-9 space) can be implemented by setting this values as
  required.  
    
  Set to `c(0, 1)` to not scale at all i.e. print the raw integer
  probability values. It is recommended to also set
  `sequence_text_rounding = 0` to print integers as the default value of
  `2` will result in e.g. `"128.00"`.  
    
  Set to `c(-0.5, 256)` (default, results in \\\frac{p+0.5}{256}\\) to
  scale to the centre of the probability spaces defined by the SAMtools
  spec, where integer \\p\\ represents the probability space from
  \\\frac{p}{256}\\ to \\\frac{p+1}{256}\\. This is slightly better at
  representing the uncertainty compared to `c(0, 255)` as strictly
  speaking `0` represents the probability space from 0.000 to 0.004 and
  `255` represents the probability space from 0.996 to 1.000, so scaling
  them to 0.002 and 0.998 respectively is a more accurate representation
  of the probability space they each represent. Setting `c(0, 255)`
  would scale such that 0 is exactly 0.000 and 255 is exactly 1.000,
  which is not as accurate so it discouraged.

- sequence_text_rounding:

  `integer`. How many decimal places the text drawn in the boxes should
  be rounded to (defaults to `2`). Ignored if `sequence_text_type` is
  `"sequence"` or `"none"`.

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

- modified_bases_outline_colour:

  `character`. If `NA` (default), inherits from `outline_colour`. If not
  `NA`, overrides `outline_colour` for modification-assessed bases only.

- modified_bases_outline_linewidth:

  `numeric`. If `NA` (default), inherits from `outline_linewidth`. If
  not `NA`, overrides `outline_linewidth` for modification-assessed
  bases only.

- modified_bases_outline_join:

  `character`. If `NA` (default), inherits from `outline_join`. If not
  `NA`, overrides `outline_join` for modification-assessed bases only.

- other_bases_outline_colour:

  `character`. If `NA` (default), inherits from `outline_colour`. If not
  `NA`, overrides `outline_colour` for non-modification-assessed bases
  only.

- other_bases_outline_linewidth:

  `numeric`. If `NA` (default), inherits from `outline_linewidth`. If
  not `NA`, overrides `outline_linewidth` for non-modification-assessed
  bases only.

- other_bases_outline_join:

  `character`. If `NA` (default), inherits from `outline_join`. If not
  `NA`, overrides `outline_join` for non-modification-assessed bases
  only.

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
  image. Defaults to `100`.  
    
  Large values (e.g. 100) are required to render small text properly.
  Small values (e.g. 20) will work when sequence/annotation text is off,
  and very small values (e.g. 10) will work when sequence/annotation
  text and outlines are all off.

- ...:

  Used to recognise aliases e.g. American spellings or common
  misspellings - see
  [aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).
  If any American spellings do not work, please make a bug report at
  <https://github.com/ejade42/ggDNAvis/issues>.

## Value

A ggplot object containing the full visualisation, or `invisible(NULL)`
if `return = FALSE`. It is often more useful to use
`filename = "myfilename.png"`, because then the visualisation is
exported at the correct aspect ratio.

## Examples

``` r
# \donttest{
## Extract info from dataframe
methylation_info <- extract_methylation_from_dataframe(example_many_sequences)
#> Error in extract_methylation_from_dataframe(example_many_sequences): '...' used in an incorrect context

## Visualise example_many_sequences with all defaults
## This looks ugly because it isn't at the right scale/aspect ratio
visualise_methylation(
    methylation_info$locations,
    methylation_info$probabilities,
    methylation_info$sequences
)
#> Error: object 'methylation_info' not found

## Export with all defaults rather than returning
visualise_methylation(
    methylation_info$locations,
    methylation_info$probabilities,
    methylation_info$sequences,
    filename = "example_vm_01.png",
    return = FALSE
)
#> Error: object 'methylation_info' not found
## View exported image
image <- png::readPNG("example_vm_01.png")
#> Error in png::readPNG("example_vm_01.png"): unable to open example_vm_01.png
unlink("example_vm_01.png")
grid::grid.newpage()
grid::grid.raster(image)
#> Error in UseMethod("as.raster"): no applicable method for 'as.raster' applied to an object of class "function"

## Export with customisation
visualise_methylation(
    methylation_info$locations,
    methylation_info$probabilities,
    methylation_info$sequences,
    filename = "example_vm_02.png",
    return = FALSE,
    low_colour = "white",
    high_colour = "black",
    low_clamp = 0.3*255,
    high_clamp = 0.7*255,
    index_annotation_lines = c(1, 23, 37),
    index_annotation_interval = 3,
    index_annotation_full_line = FALSE,
    other_bases_colour = "lightblue1",
    other_bases_outline_linewidth = 1,
    other_bases_outline_colour = "grey",
    modified_bases_outline_linewidth = 3,
    modified_bases_outline_colour = "black",
    margin = 0.3
)
#> Error: object 'methylation_info' not found
## View exported image
image <- png::readPNG("example_vm_02.png")
#> Error in png::readPNG("example_vm_02.png"): unable to open example_vm_02.png
unlink("example_vm_02.png")
grid::grid.newpage()
grid::grid.raster(image)
#> Error in UseMethod("as.raster"): no applicable method for 'as.raster' applied to an object of class "function"


## Export with customisation, viewing sequences
visualise_methylation(
    methylation_info$locations,
    methylation_info$probabilities,
    methylation_info$sequences,
    filename = "example_vm_03.png",
    return = FALSE,
    low_colour = "white",
    high_colour = "black",
    low_clamp = 0.3*255,
    high_clamp = 0.7*255,
    sequence_text_type = "sequence",
    sequence_text_colour = "red",
    index_annotation_lines = c(1, 23, 37),
    index_annotation_interval = 3,
    index_annotation_full_line = FALSE,
    other_bases_colour = "lightblue1",
    other_bases_outline_linewidth = 1,
    other_bases_outline_colour = "grey",
    modified_bases_outline_linewidth = 3,
    modified_bases_outline_colour = "black",
    margin = 0.3
)
#> Error: object 'methylation_info' not found
## View exported image
image <- png::readPNG("example_vm_03.png")
#> Error in png::readPNG("example_vm_03.png"): unable to open example_vm_03.png
unlink("example_vm_03.png")
grid::grid.newpage()
grid::grid.raster(image)
#> Error in UseMethod("as.raster"): no applicable method for 'as.raster' applied to an object of class "function"


## Export with customisation, viewing probabilities
visualise_methylation(
    methylation_info$locations,
    methylation_info$probabilities,
    methylation_info$sequences,
    filename = "example_vm_04.png",
    return = FALSE,
    low_colour = "cyan",
    high_colour = "yellow",
    low_clamp = 0.3*255,
    high_clamp = 0.7*255,
    sequence_text_type = "probability",
    sequence_text_size = 10,
    sequence_text_colour = "black",
    index_annotation_lines = c(1, 23, 37),
    index_annotation_interval = 3,
    index_annotation_full_line = FALSE,
    other_bases_colour = "lightgreen",
    other_bases_outline_linewidth = 1,
    other_bases_outline_colour = "grey",
    modified_bases_outline_linewidth = 3,
    modified_bases_outline_colour = "black",
    margin = 0.3
)
#> Error: object 'methylation_info' not found
## View exported image
image <- png::readPNG("example_vm_04.png")
#> Error in png::readPNG("example_vm_04.png"): unable to open example_vm_04.png
unlink("example_vm_04.png")
grid::grid.newpage()
grid::grid.raster(image)
#> Error in UseMethod("as.raster"): no applicable method for 'as.raster' applied to an object of class "function"


## Export with customisation, viewing probability integers
visualise_methylation(
    methylation_info$locations,
    methylation_info$probabilities,
    methylation_info$sequences,
    filename = "example_vm_05.png",
    return = FALSE,
    low_colour = "blue",
    high_colour = "red",
    low_clamp = 0.3*255,
    high_clamp = 0.7*255,
    sequence_text_type = "probability",
    sequence_text_scaling = c(0, 1),
    sequence_text_rounding = 0,
    sequence_text_size = 10,
    sequence_text_colour = "white",
    index_annotation_lines = c(1, 23, 37),
    index_annotation_interval = 3,
    index_annotation_full_line = FALSE,
    other_bases_outline_linewidth = 1,
    other_bases_outline_colour = "grey",
    modified_bases_outline_linewidth = 3,
    modified_bases_outline_colour = "black",
    margin = 0.3
)
#> Error: object 'methylation_info' not found
## View exported image
image <- png::readPNG("example_vm_05.png")
#> Error in png::readPNG("example_vm_05.png"): unable to open example_vm_05.png
unlink("example_vm_05.png")
grid::grid.newpage()
grid::grid.raster(image)
#> Error in UseMethod("as.raster"): no applicable method for 'as.raster' applied to an object of class "function"
# }
```
