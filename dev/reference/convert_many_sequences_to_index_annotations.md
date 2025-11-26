# Create index annotations at variable line positions in many sequences data ([`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md) helper)

This function is called by
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
to create the x/y position data for placing the index annotations on the
graph. Its arguments are either intermediate variables produced by
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md),
or arguments of
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
directly passed through.  
  
Returns a dataframe with `x_position`, `y_position`, `annotation`, and
`type` columns. `type` is always `"Number"` (unused, but for consistency
with
[`convert_sequences_to_annotations()`](https://ejade42.github.io/ggDNAvis/reference/convert_sequences_to_annotations.md)).
`annotation` is always the position of the base along the line. In this
function, the count is reset each line (compared to counting consistenly
along in
[`convert_sequences_to_annotations()`](https://ejade42.github.io/ggDNAvis/reference/convert_sequences_to_annotations.md))
because each line is a different sequence.

## Usage

``` r
convert_many_sequences_to_index_annotations(
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
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md).
  Must also have been used as input to
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  to create `new_sequences_vector`.

- original_indices_to_annotate:

  `positive integer vector`. The vector of lines (i.e. indices) of
  `original_vector` to be annotated. Read from `index_annotation_lines`
  argument to
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
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

`dataframe`. A dataframe with columns `x_position`, `y_position`,
`annotation`, and `type`, with one observation per annotation number
that needs to be drawn onto the ggplot.

## Examples

``` r
## Set up arguments (e.g. from visualise_many_sequences() call)
sequences_data <- example_many_sequences
index_annotation_lines <- c(1, 23, 37)
index_annotation_interval <- 10
index_annotations_above <- TRUE
index_annotation_full_line <- FALSE
index_annotation_vertical_position <- 1/3


## Create sequences vector
sequences <- extract_and_sort_sequences(
    example_many_sequences,
    grouping_levels = c("family" = 8, "individual" = 2)
)
sequences
#>  [1] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#>  [2] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#>  [3] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#>  [4] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#>  [5] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#>  [6] ""                                                                                                      
#>  [7] ""                                                                                                      
#>  [8] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#>  [9] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       
#> [10] ""                                                                                                      
#> [11] ""                                                                                                      
#> [12] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [13] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#> [15] ""                                                                                                      
#> [16] ""                                                                                                      
#> [17] ""                                                                                                      
#> [18] ""                                                                                                      
#> [19] ""                                                                                                      
#> [20] ""                                                                                                      
#> [21] ""                                                                                                      
#> [22] ""                                                                                                      
#> [23] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [24] ""                                                                                                      
#> [25] ""                                                                                                      
#> [26] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
#> [27] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [28] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [29] ""                                                                                                      
#> [30] ""                                                                                                      
#> [31] ""                                                                                                      
#> [32] ""                                                                                                      
#> [33] ""                                                                                                      
#> [34] ""                                                                                                      
#> [35] ""                                                                                                      
#> [36] ""                                                                                                      
#> [37] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [38] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [39] ""                                                                                                      
#> [40] ""                                                                                                      
#> [41] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"         
#> [42] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"            
#> [43] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"               
#> [44] ""                                                                                                      
#> [45] ""                                                                                                      
#> [46] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [47] ""                                                                                                      
#> [48] ""                                                                                                      
#> [49] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [50] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            
#> [51] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     

## Insert blank rows as needed
new_sequences <- insert_at_indices(
    sequences,
    insertion_indices = index_annotation_lines,
    insert_before = index_annotations_above,
    insert = "",
    vert = index_annotation_vertical_position
)
new_sequences
#>  [1] ""                                                                                                      
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#>  [3] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#>  [4] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#>  [5] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#>  [6] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#>  [7] ""                                                                                                      
#>  [8] ""                                                                                                      
#>  [9] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#> [10] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       
#> [11] ""                                                                                                      
#> [12] ""                                                                                                      
#> [13] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
#> [15] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#> [16] ""                                                                                                      
#> [17] ""                                                                                                      
#> [18] ""                                                                                                      
#> [19] ""                                                                                                      
#> [20] ""                                                                                                      
#> [21] ""                                                                                                      
#> [22] ""                                                                                                      
#> [23] ""                                                                                                      
#> [24] ""                                                                                                      
#> [25] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [26] ""                                                                                                      
#> [27] ""                                                                                                      
#> [28] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
#> [29] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [30] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [31] ""                                                                                                      
#> [32] ""                                                                                                      
#> [33] ""                                                                                                      
#> [34] ""                                                                                                      
#> [35] ""                                                                                                      
#> [36] ""                                                                                                      
#> [37] ""                                                                                                      
#> [38] ""                                                                                                      
#> [39] ""                                                                                                      
#> [40] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [41] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [42] ""                                                                                                      
#> [43] ""                                                                                                      
#> [44] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"         
#> [45] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"            
#> [46] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"               
#> [47] ""                                                                                                      
#> [48] ""                                                                                                      
#> [49] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [50] ""                                                                                                      
#> [51] ""                                                                                                      
#> [52] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [53] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            
#> [54] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     

## Create annnotation dataframe
convert_many_sequences_to_index_annotations(
    new_sequences_vector = new_sequences,
    original_sequences_vector = sequences,
    original_indices_to_annotate = index_annotation_lines,
    annotation_interval = 10,
    annotate_full_lines = index_annotation_full_line,
    annotations_above = index_annotations_above,
    annotation_vertical_position = index_annotation_vertical_position
)
#>    x_position y_position annotation   type
#> 1  0.09313725  0.9876543         10 Number
#> 2  0.19117647  0.9876543         20 Number
#> 3  0.28921569  0.9876543         30 Number
#> 4  0.38725490  0.9876543         40 Number
#> 5  0.48529412  0.9876543         50 Number
#> 6  0.58333333  0.9876543         60 Number
#> 7  0.68137255  0.9876543         70 Number
#> 8  0.77941176  0.9876543         80 Number
#> 9  0.87745098  0.9876543         90 Number
#> 10 0.97549020  0.9876543        100 Number
#> 11 0.09313725  0.5617284         10 Number
#> 12 0.19117647  0.5617284         20 Number
#> 13 0.28921569  0.5617284         30 Number
#> 14 0.38725490  0.5617284         40 Number
#> 15 0.48529412  0.5617284         50 Number
#> 16 0.58333333  0.5617284         60 Number
#> 17 0.68137255  0.5617284         70 Number
#> 18 0.77941176  0.5617284         80 Number
#> 19 0.87745098  0.5617284         90 Number
#> 20 0.09313725  0.2839506         10 Number
#> 21 0.19117647  0.2839506         20 Number
#> 22 0.28921569  0.2839506         30 Number
#> 23 0.38725490  0.2839506         40 Number
#> 24 0.48529412  0.2839506         50 Number
#> 25 0.58333333  0.2839506         60 Number
#> 26 0.68137255  0.2839506         70 Number
#> 27 0.77941176  0.2839506         80 Number
#> 28 0.87745098  0.2839506         90 Number

```
