# Process index annotations and rasterise to a x/y/layer dataframe (generic `ggDNAvis` helper)

`rasterize_index_annotations()` is an alias for
`rasterise_index_annotations()`.

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
  index_annotation_lines,
  index_annotation_interval = 15,
  index_annotation_full_line = TRUE,
  index_annotations_above = TRUE,
  index_annotation_vertical_position = 1/3,
  index_annotation_always_first_base = FALSE,
  sum_indices = FALSE,
  spacing = NA,
  offset_start = 0
)
```

## Arguments

- new_sequences_vector:

  `vector`. The output of
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  when used with identical arguments. Should be
  `original_sequences_vector` with some additional blank lines inserted.

- original_sequences_vector:

  `vector`. The vector of sequences used for plotting, that was
  originally given to
  [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)/[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  or split from the input sequence to
  [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md).
  Must also have been used as input to
  [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  to create `new_sequences_vector`.

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

- index_annotation_interval:

  `integer`. The frequency at which numbers should be placed underneath
  indicating base index, starting counting from the leftmost base.
  Defaults to `15` (every 15 bases along each row).  
    
  Setting to `0` disables index annotations (and prevents adding
  additional blank lines).

- index_annotation_full_line:

  `logical`. Whether index annotations should continue to the end of the
  longest sequence (`TRUE`, default) or should only continue as far as
  each selected line does (`FALSE`).

- index_annotations_above:

  `logical`. Whether index annotations should go above (`TRUE`, default)
  or below (`FALSE`) each line of sequence.

- index_annotation_vertical_position:

  `numeric`. How far annotation numbers should be rendered above (if
  `index_annotations_above = TRUE`) or below (if
  `index_annotations_above = FALSE`) each base. Defaults to `1/3`.  
    
  Not recommended to change at all. Strongly discouraged to set below 0
  or above 1.

- index_annotation_always_first_base:

  `logical`. Whether to force the first base in each line to always be
  annotated regardless of whether it occurs at the
  `index_annotation_interval`. Defaults to `FALSE`.

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
rasterise_index_annotations(
    new_sequences_vector = new_sequences,
    original_sequences_vector = sequences,
    index_annotation_lines = index_annotation_lines,
    index_annotation_interval = 10,
    index_annotation_full_line = index_annotation_full_line,
    index_annotations_above = index_annotations_above,
    index_annotation_vertical_position = index_annotation_vertical_position,
    sum_indices = FALSE,
    spacing = NA, ## infer from vertical position
    offset_start = 0
)
#>             x         y value
#> 1  0.09313725 0.9876543    10
#> 2  0.19117647 0.9876543    20
#> 3  0.28921569 0.9876543    30
#> 4  0.38725490 0.9876543    40
#> 5  0.48529412 0.9876543    50
#> 6  0.58333333 0.9876543    60
#> 7  0.68137255 0.9876543    70
#> 8  0.77941176 0.9876543    80
#> 9  0.87745098 0.9876543    90
#> 10 0.97549020 0.9876543   100
#> 11 0.09313725 0.5617284    10
#> 12 0.19117647 0.5617284    20
#> 13 0.28921569 0.5617284    30
#> 14 0.38725490 0.5617284    40
#> 15 0.48529412 0.5617284    50
#> 16 0.58333333 0.5617284    60
#> 17 0.68137255 0.5617284    70
#> 18 0.77941176 0.5617284    80
#> 19 0.87745098 0.5617284    90
#> 20 0.09313725 0.2839506    10
#> 21 0.19117647 0.2839506    20
#> 22 0.28921569 0.2839506    30
#> 23 0.38725490 0.2839506    40
#> 24 0.48529412 0.2839506    50
#> 25 0.58333333 0.2839506    60
#> 26 0.68137255 0.2839506    70
#> 27 0.77941176 0.2839506    80
#> 28 0.87745098 0.2839506    90

```
