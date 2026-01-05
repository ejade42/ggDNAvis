# Colour palettes for sequence visualisations

`sequence_color_palettes` and `sequence_col_palettes` are aliases for
`sequence_colour_palettes` - see
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).

A collection of colour palettes for use with
[`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md)
and
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md).
Each is a character vector of 4 colours, corresponding to A, C, G, and
T/U in that order.

To use inside the visualisation functions, set
`sequence_colours = sequence_colour_palettes$<palette_name>`

Generation code is available at `data-raw/sequence_colour_palettes.R`

## Usage

``` r
sequence_colour_palettes
```

## Format

### `sequence_colour_palettes`

A list of 5 length-4 character vectors

- ggplot_style:

  The shades of red, green, blue, and purple that
  [`ggplot2::ggplot()`](https://ggplot2.tidyverse.org/reference/ggplot.html)
  uses by default for a 4-way discrete colour scheme.  
    
  Values: `c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")`

- bright_pale:

  Bright yellow, green, blue, and red in lighter pastel-like tones.  
    
  Values: `c("#FFDD00", "#40C000", "#00A0FF", "#FF4E4E")`

- bright_pale2:

  Bright yellow, green, blue, and red in lighter pastel-like tones. The
  green (for C) is slightly lighter than bright_pale.  
    
  Values: `c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E")`

- bright_deep:

  Bright orange, green, blue, and red in darker, richer tones.  
    
  Values: `c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E")`

- sanger:

  Green, blue, black, and red similar to a traditional Sanger sequencing
  readout.  
    
  Values: `c("#00B200", "#0000FF", "#000000", "#FF0000")`

## Examples

``` r
## ggplot_style:
visualise_single_sequence(
    "ACGT",
    sequence_colours = sequence_colour_palettes$ggplot_style,
    index_annotation_interval = 0
)
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_first_base setting.
#> If you want the first base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_last_base setting.
#> If you want the last base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.


## bright_pale:
visualise_single_sequence(
    "ACGT",
    sequence_colours = sequence_colour_palettes$bright_pale,
    index_annotation_interval = 0
)
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_first_base setting.
#> If you want the first base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_last_base setting.
#> If you want the last base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.


## bright_pale2:
visualise_single_sequence(
    "ACGT",
    sequence_colours = sequence_colour_palettes$bright_pale2,
    index_annotation_interval = 0
)
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_first_base setting.
#> If you want the first base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_last_base setting.
#> If you want the last base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.


## bright_deep:
visualise_single_sequence(
    "ACGT",
    sequence_colours = sequence_colour_palettes$bright_deep,
    sequence_text_colour = "white",
    index_annotation_interval = 0
)
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_first_base setting.
#> If you want the first base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_last_base setting.
#> If you want the last base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.


## sanger:
visualise_single_sequence(
    "ACGT",
    sequence_colours = sequence_colour_palettes$sanger,
    sequence_text_colour = "white",
    index_annotation_interval = 0
)
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_first_base setting.
#> If you want the first base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.
#> Warning: Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_last_base setting.
#> If you want the last base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.

```
