# Extract, sort, and add spacers between sequences in a dataframe

`extract_sequences_from_dataframe()` is an alias for
`extract_and_sort_sequences()` - see
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).

This function takes a dataframe that contains sequences and metadata,
recursively splits it into multiple levels of groups defined by
`grouping_levels`, and adds breaks between each level of group as
defined by `grouping_levels`. Within each lowest-level group, reads are
sorted by `sort_by`, with order determined by `desc_sort`.

Default values are set up to work with the included dataset
[`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md).

The returned sequences vector is ideal input for
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md).

Also called by
[`extract_methylation_from_dataframe()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_methylation.md)
to produce input for
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md).

## Usage

``` r
extract_and_sort_sequences(
  sequence_dataframe,
  sequence_variable = "sequence",
  grouping_levels = c(family = 8, individual = 2),
  sort_by = "sequence_length",
  desc_sort = TRUE
)
```

## Arguments

- sequence_dataframe:

  `dataframe`. A dataframe containing the sequence information and all
  required meta-data. See
  [`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
  for an example of a compatible dataframe.

- sequence_variable:

  `character`. The name of the column within the dataframe containing
  the sequence information to be output. Defaults to `"sequence"`.

- grouping_levels:

  `named character vector`. What variables should be used to define the
  groups/chunks, and how large a gap should be left between groups at
  that level. Set to `NA` to turn off grouping.  
    
  Defaults to `c("family" = 8, "individual" = 2)`, meaning the
  highest-level groups are defined by the `family` column, and there is
  a gap of 8 between each family. Likewise the second-level groups
  (within each family) are defined by the `individual` column, and there
  is a gap of 2 between each individual.  
    
  Any number of grouping variables and gaps can be given, as long as
  each grouping variable is a column within the dataframe. It is
  recommended that lower-level groups are more granular and subdivide
  higher-level groups (e.g. first divide into families, then into
  individuals within families).  
    
  To change the order of groups within a level, make that column a
  factor with the order specified e.g.
  `example_many_sequences$family <- factor(example_many_sequences$family, levels = c("Family 2", "Family 3", "Family 1"))`
  to change the order to Family 2, Family 3, Family 1.

- sort_by:

  `character`. The name of the column within the dataframe that should
  be used to sort/order the rows within each lowest-level group. Set to
  `NA` to turn off sorting within groups.  
    
  Recommended to be the length of the sequence information, as is the
  case for the default `"sequence_length"` which was generated via
  `example_many_sequences$sequence_length <- nchar(example_many_sequences$sequence)`.

- desc_sort:

  `logical`. Boolean specifying whether rows within groups should be
  sorted by the `sort_by` variable descending (`TRUE`, default) or
  ascending (`FALSE`).

## Value

`character vector`. The sequences ordered and grouped as specified, with
blank sequences (`""`) inserted as spacers as specified.

## Examples

``` r
extract_and_sort_sequences(
    example_many_sequences,
    sequence_variable = "sequence",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = "sequence_length",
    desc_sort = TRUE
)
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

extract_and_sort_sequences(
    example_many_sequences,
    sequence_variable = "sequence",
    grouping_levels = c("family" = 3),
    sort_by = "sequence_length",
    desc_sort = FALSE
)
#>  [1] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       
#>  [3] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#>  [4] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#>  [5] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#>  [6] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
#>  [7] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#>  [8] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#>  [9] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [10] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#> [11] ""                                                                                                      
#> [12] ""                                                                                                      
#> [13] ""                                                                                                      
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [15] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [16] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
#> [17] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [18] ""                                                                                                      
#> [19] ""                                                                                                      
#> [20] ""                                                                                                      
#> [21] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     
#> [22] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"               
#> [23] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"            
#> [24] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            
#> [25] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"         
#> [26] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [27] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [28] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [29] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      

extract_and_sort_sequences(
    example_many_sequences,
    sequence_variable = "sequence",
    grouping_levels = NA,
    sort_by = "sequence_length",
    desc_sort = TRUE
)
#>  [1] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#>  [2] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#>  [3] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#>  [4] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#>  [5] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#>  [6] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#>  [7] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"         
#>  [8] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"         
#>  [9] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
#> [10] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"            
#> [11] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            
#> [12] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [13] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [15] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"               
#> [16] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
#> [17] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [18] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#> [19] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#> [20] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     
#> [21] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#> [22] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#> [23] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       

extract_and_sort_sequences(
    example_many_sequences,
    sequence_variable = "sequence",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = NA
)
#>  [1] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#>  [3] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#>  [4] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#>  [5] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#>  [6] ""                                                                                                      
#>  [7] ""                                                                                                      
#>  [8] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       
#>  [9] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#> [10] ""                                                                                                      
#> [11] ""                                                                                                      
#> [12] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [13] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
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
#> [26] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [27] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [28] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
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
#> [50] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     
#> [51] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            

extract_and_sort_sequences(
    example_many_sequences,
    sequence_variable = "sequence",
    grouping_levels = NA,
    sort_by = NA
)
#>  [1] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#>  [3] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#>  [4] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#>  [5] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#>  [6] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       
#>  [7] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#>  [8] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#>  [9] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#> [10] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
#> [11] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [12] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [13] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
#> [15] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [16] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [17] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"         
#> [18] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"            
#> [19] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"               
#> [20] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [21] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [22] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     
#> [23] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            

extract_and_sort_sequences(
    example_many_sequences,
    sequence_variable = "quality",
    grouping_levels = c("individual" = 3),
    sort_by = "quality",
    desc_sort = FALSE
)
#>  [1] ")8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90"
#>  [2] "60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12\">/2C;4:9F8:816E,6C3*,1-2139"                                      
#>  [3] ":<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0"                     
#>  [4] ";4*2E3-48?@6A-!00!;-3%:H,4H>H530C(85I/&75-62.:2#!/D=A?8&7E!-@:=::5,)51,97D*04'2.!20@/;6)947<6"         
#>  [5] ";F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@"               
#>  [6] ""                                                                                                      
#>  [7] ""                                                                                                      
#>  [8] ""                                                                                                      
#>  [9] "E6(<)\"-./EE<(5:47,(C818I9CC1=.&)4G6-7<(*\"(,2C>8/5:0@@).A$97I!-<"                                     
#> [10] "F='I#*5I:<F?)<4G3&:95*-5?1,!:9BD4B5.-27577<2E9)2:189B.5/*#7;;'**.7;-!"                                 
#> [11] ""                                                                                                      
#> [12] ""                                                                                                      
#> [13] ""                                                                                                      
#> [14] "*46.5//3:37?24:(:0*#.))E)?:,/172=2!4\">.*/;\"8+5<;D6.I2=>:C3)108,<)GC161)!55E!.>86/"                   
#> [15] "736/A@B121C269<2I,'5G66>46A6-9*&4*;4-E4C429?I+3@83(234E0%:43;!/3;2+956A0)(+'5G4=*3;1"                  
#> [16] "?;.*26<C-8B,3#8/,-9!1++:94:/!A317=9>502=-+8;$=53@D*?/6:6&0D7-.@8,5;F,1?0D?$9'&665B8.604"               
#> [17] ""                                                                                                      
#> [18] ""                                                                                                      
#> [19] ""                                                                                                      
#> [20] "=</-I354/,*>+<CA40*537/;<@I7/4%6192'5'>#4:&C,072+90:0+4;74\"D5,38&<7A?00+1>G>#=?;,@<<1=64D=!1&"        
#> [21] ""                                                                                                      
#> [22] ""                                                                                                      
#> [23] ""                                                                                                      
#> [24] "7?38,EC#3::=1)8&;<\">3.9BE)1661!2)5-4.11B<3)?')-+,B4.<7)/:IE=5$.3:66G9216-C20,>(0848(1$-"              
#> [25] ";1>:5417*<1.2H#260197.;7<(-3?0+=:)ID'I$6*128*!4.7-=5;+384F!=5>4!93+.6I7+H1-).H><68;7"                  
#> [26] "@86,/+6=8/;9=1)48E494IB3456/6.*=</B32+5469>8?@!1;*+81$>-99D7<@1$6B'?462?CE+=1+95=G?.6CA%>2"            
#> [27] ""                                                                                                      
#> [28] ""                                                                                                      
#> [29] ""                                                                                                      
#> [30] "/*2<C643?*8?@9)-.'5A!=3-=;6,.%H3-!10'I>&@?;96;+/+36;:C;B@/=:6,;61>?>!,>.97@.48B38(;7;1F464=-7;)7"      
#> [31] "/C<$>7/1(9%4:6>6I,D%*,&D?C/6@@;7)83.E.7:@9I906<!4536!850!164/8,<=?=15A;8B/5B364A66.1%9=(9876E8C:"      
#> [32] ""                                                                                                      
#> [33] ""                                                                                                      
#> [34] ""                                                                                                      
#> [35] "0/2>@/6+-/(!=9-?G!AA70*,/!/?-E46:,-1G94*491,,38?(-!6<8A;/C9;,3)4C06=%',86A)1!E@/24G59<<"               
#> [36] "9>124!752+@06I/.72097*';-+A60=B?+/8'15477>4-435D;G@G'./21:(0/1/A=7'I>A\"3=9;;12,@\"2=3D=,458"          
#> [37] ":0I4099<,4E01;/@96%2I2<,%<C&=81F+4<*@4A5.('4!%I3CE657<=!5;37>4D:%3;7'\"4<.9;?;7%0>:,84B512,B7/"        
#> [38] ""                                                                                                      
#> [39] ""                                                                                                      
#> [40] ""                                                                                                      
#> [41] "$<,5\"7+!$';8<0794*@FI>34224!57+#1!F<+53$,?)-.A3;=1*71C02<.5:1)82!86$03/;%+1C3+D3;@9B-E#+/70;9<D'"     
#> [42] ""                                                                                                      
#> [43] ""                                                                                                      
#> [44] ""                                                                                                      
#> [45] ".85$#;!1F$8E:B+;7CI6@11/'65<3,4G:8@GF1413:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4"                     
#> [46] "5@<733';9+3BB)=69,3!.2B*86'8E>@3?!(36:<002/4>:1.43A!+;<.3G*G8?0*991,B(C/\"I9*1-86)8.;;5-0+="           
#> [47] "?2-#-2\"1:(5(4>!I)>I,.?-+EG3IH4-.C:;570@2I;?D5#/;A7=>?<3?080::459*?8:3\"<2;I)C1400)6:3%19./);.I?35"    
```
