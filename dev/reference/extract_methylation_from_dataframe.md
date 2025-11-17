# Extract methylation information from dataframe for visualisation

This function takes a dataframe that contains methylation information in
the form of locations (indices along the read signifying bases at which
modification probability was assessed) and probabilities (the
probability of modification at each assessed location, as an integer
from 0 to 255).  
  
Each observation/row in the dataframe represents one sequence (e.g. a
Nanopore read). In the locations and probabilities column, each sequence
(row) has many numbers associated. These are stored as one string per
observation e.g. `"3,6,9,12"`, with the column representing a character
vector of such strings (e.g. `c("3,6,9,12", "1,2,3,4")`).  
  
This function calls
[`extract_and_sort_sequences()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_sequences.md)
on the relevant columns and returns a list of vectors stored in
`$locations`, `$probabilities`, `$sequences`, and `$lengths`. These can
then be used as input for
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md).  
  
Default arguments are set up to work with the included
[`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
data.

## Usage

``` r
extract_methylation_from_dataframe(
  modification_data,
  locations_colname = "methylation_locations",
  probabilities_colname = "methylation_probabilities",
  sequences_colname = "sequence",
  lengths_colname = "sequence_length",
  grouping_levels = c(family = 8, individual = 2),
  sort_by = "sequence_length",
  desc_sort = TRUE
)
```

## Arguments

- modification_data:

  `dataframe`. A dataframe that must contain columns for methylation
  locations, methylation probabilities, and sequence length for each
  read. The former two should be condensed strings as produced by
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md)
  e.g. `"1,2,3,4"`. The latter should be integer.  
    
  See
  [`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
  for an example of a compatible dataframe.

- locations_colname:

  `character`. The name of the column within the input dataframe that
  contains methylation/modification location information. Defaults to
  `"methylation_locations"`.  
    
  Values within this column must be a comma-separated string
  representing a condensed numerical vector (e.g. `"3,6,9,12"`, produced
  via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the indices along the read at which modification was assessed.
  Indexing starts at 1.

- probabilities_colname:

  `character`. The name of the column within the input dataframe that
  contains methylation/modification probability information. Defaults to
  `"methylation_probabilities"`.  
    
  Values within this column must be a comma-separated string
  representing a condensed numerical vector (e.g. `"2,212,128,64"`,
  produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the probability of modification as an 8-bit (0-255) integer for
  each base where modification was assessed.

- sequences_colname:

  `character`. The name of the column within the input dataframe that
  contains the actual sequences. Defaults to `"sequence"`.  
    
  Values within this column must be the actual sequences (e.g.
  `"GGCGGA"`).

- lengths_colname:

  `character`. The name of the column within the input dataframe that
  contains the length of each sequence. Defaults to
  `"sequence_length"`.  
    
  Values within this column must be non-negative integers.

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

`list`, containing `$locations` (`character vector`), `$probabilities`
(`character vector`), `$sequences` (`character vector`), and `$lengths`
(`integer vector`).

## Examples

``` r
## See documentation for extract_and_sort_sequences()
## for more examples of changing sorting/grouping
extract_methylation_from_dataframe(
    example_many_sequences,
    locations_colname = "methylation_locations",
    probabilities_colname = "methylation_probabilities",
    lengths_colname = "sequence_length",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = "sequence_length",
    desc_sort = TRUE
)
#> $locations
#>  [1] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99"               
#>  [2] "3,6,9,12,15,18,27,30,33,42,45,48,57,60,63,72,75,78,87,90"                        
#>  [3] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84"                        
#>  [4] "3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78"                        
#>  [5] "3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60"                                    
#>  [6] ""                                                                                
#>  [7] ""                                                                                
#>  [8] "3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66"                                    
#>  [9] "3,6,9,12,15,18,21,24,27,30,42,45,57,60"                                          
#> [10] ""                                                                                
#> [11] ""                                                                                
#> [12] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84"                        
#> [13] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,78,81"                           
#> [14] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78"                  
#> [15] ""                                                                                
#> [16] ""                                                                                
#> [17] ""                                                                                
#> [18] ""                                                                                
#> [19] ""                                                                                
#> [20] ""                                                                                
#> [21] ""                                                                                
#> [22] ""                                                                                
#> [23] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90"
#> [24] ""                                                                                
#> [25] ""                                                                                
#> [26] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,84,87"   
#> [27] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84"      
#> [28] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,78,81"         
#> [29] ""                                                                                
#> [30] ""                                                                                
#> [31] ""                                                                                
#> [32] ""                                                                                
#> [33] ""                                                                                
#> [34] ""                                                                                
#> [35] ""                                                                                
#> [36] ""                                                                                
#> [37] "3,6,9,18,21,30,33,42,45,54,57,66,69,78,81,90,93"                                 
#> [38] "3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93"                           
#> [39] ""                                                                                
#> [40] ""                                                                                
#> [41] "3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90"                              
#> [42] "3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87"                                 
#> [43] "3,6,9,12,15,18,21,24,27,30,39,42,51,54,63,66,75,78,81,84"                        
#> [44] ""                                                                                
#> [45] ""                                                                                
#> [46] "3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93"                           
#> [47] ""                                                                                
#> [48] ""                                                                                
#> [49] "3,6,9,12,15,18,21,24,27,30,33,42,45,54,57,66,69,78,81,90,93"                     
#> [50] "3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87"                           
#> [51] "3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78"                        
#> 
#> $probabilities
#>  [1] "29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41"                           
#>  [2] "170,236,120,36,139,50,229,99,79,41,229,42,230,34,34,27,130,77,7,79"                                       
#>  [3] "206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45"                                 
#>  [4] "216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82"                                        
#>  [5] "10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253"                                                  
#>  [6] ""                                                                                                         
#>  [7] ""                                                                                                         
#>  [8] "31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127"                                                
#>  [9] "189,9,144,71,52,34,83,40,33,111,10,182,26,242"                                                            
#> [10] ""                                                                                                         
#> [11] ""                                                                                                         
#> [12] "81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250"                              
#> [13] "149,181,109,88,194,108,143,30,77,122,88,153,19,244,6,215,161,79,189"                                      
#> [14] "147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193"                          
#> [15] ""                                                                                                         
#> [16] ""                                                                                                         
#> [17] ""                                                                                                         
#> [18] ""                                                                                                         
#> [19] ""                                                                                                         
#> [20] ""                                                                                                         
#> [21] ""                                                                                                         
#> [22] ""                                                                                                         
#> [23] "163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179"
#> [24] ""                                                                                                         
#> [25] ""                                                                                                         
#> [26] "191,91,194,96,204,7,129,209,139,68,88,94,109,234,200,188,72,116,73,178,209,167,105,243,62,155,193"        
#> [27] "176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13"                
#> [28] "122,217,108,8,66,85,34,127,205,86,130,126,203,145,27,206,145,54,191,78,125,252,108,62,55"                 
#> [29] ""                                                                                                         
#> [30] ""                                                                                                         
#> [31] ""                                                                                                         
#> [32] ""                                                                                                         
#> [33] ""                                                                                                         
#> [34] ""                                                                                                         
#> [35] ""                                                                                                         
#> [36] ""                                                                                                         
#> [37] "177,29,162,79,90,250,137,113,242,115,49,253,140,196,233,174,104"                                          
#> [38] "104,37,50,49,104,89,213,51,220,101,39,87,94,109,48,168,235,187,225"                                       
#> [39] ""                                                                                                         
#> [40] ""                                                                                                         
#> [41] "243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11"                                             
#> [42] "51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168"                                           
#> [43] "60,209,185,249,68,224,124,78,101,194,26,107,168,75,53,1,27,55,29,175"                                     
#> [44] ""                                                                                                         
#> [45] ""                                                                                                         
#> [46] "49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48"                                    
#> [47] ""                                                                                                         
#> [48] ""                                                                                                         
#> [49] "193,24,159,106,198,206,247,55,221,106,131,198,34,105,169,231,88,27,238,51,14"                             
#> [50] "161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49"                                      
#> [51] "109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224"                              
#> 
#> $sequences
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
#> 
#> $lengths
#>  [1] 102  93  87  81  63   0   0  69  63   0   0  87  84  81   0   0   0   0   0
#> [20]   0   0   0  93   0   0  90  87  84   0   0   0   0   0   0   0   0  96  96
#> [39]   0   0  93  90  87   0   0  96   0   0  96  90  81
#> 

extract_methylation_from_dataframe(
    example_many_sequences,
    locations_colname = "hydroxymethylation_locations",
    probabilities_colname = "hydroxymethylation_probabilities",
    lengths_colname = "sequence_length",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = "sequence_length",
    desc_sort = TRUE
)
#> $locations
#>  [1] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99"               
#>  [2] "3,6,9,12,15,18,27,30,33,42,45,48,57,60,63,72,75,78,87,90"                        
#>  [3] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84"                        
#>  [4] "3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78"                        
#>  [5] "3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60"                                    
#>  [6] ""                                                                                
#>  [7] ""                                                                                
#>  [8] "3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66"                                    
#>  [9] "3,6,9,12,15,18,21,24,27,30,42,45,57,60"                                          
#> [10] ""                                                                                
#> [11] ""                                                                                
#> [12] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84"                        
#> [13] "3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,78,81"                           
#> [14] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78"                  
#> [15] ""                                                                                
#> [16] ""                                                                                
#> [17] ""                                                                                
#> [18] ""                                                                                
#> [19] ""                                                                                
#> [20] ""                                                                                
#> [21] ""                                                                                
#> [22] ""                                                                                
#> [23] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90"
#> [24] ""                                                                                
#> [25] ""                                                                                
#> [26] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,84,87"   
#> [27] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84"      
#> [28] "3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,78,81"         
#> [29] ""                                                                                
#> [30] ""                                                                                
#> [31] ""                                                                                
#> [32] ""                                                                                
#> [33] ""                                                                                
#> [34] ""                                                                                
#> [35] ""                                                                                
#> [36] ""                                                                                
#> [37] "3,6,9,18,21,30,33,42,45,54,57,66,69,78,81,90,93"                                 
#> [38] "3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93"                           
#> [39] ""                                                                                
#> [40] ""                                                                                
#> [41] "3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90"                              
#> [42] "3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87"                                 
#> [43] "3,6,9,12,15,18,21,24,27,30,39,42,51,54,63,66,75,78,81,84"                        
#> [44] ""                                                                                
#> [45] ""                                                                                
#> [46] "3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93"                           
#> [47] ""                                                                                
#> [48] ""                                                                                
#> [49] "3,6,9,12,15,18,21,24,27,30,33,42,45,54,57,66,69,78,81,90,93"                     
#> [50] "3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87"                           
#> [51] "3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78"                        
#> 
#> $probabilities
#>  [1] "26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34"                
#>  [2] "57,18,64,31,63,40,23,61,55,34,23,35,23,30,29,24,64,53,7,54"                         
#>  [3] "40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37"                        
#>  [4] "33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55"                          
#>  [5] "10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2"                                     
#>  [6] ""                                                                                   
#>  [7] ""                                                                                   
#>  [8] "27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64"                                     
#>  [9] "49,9,63,52,41,30,56,33,29,63,9,52,23,12"                                            
#> [10] ""                                                                                   
#> [11] ""                                                                                   
#> [12] "55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5"                          
#> [13] "80,43,103,71,21,112,47,126,21,40,80,35,142,1,238,1,79,111,20"                       
#> [14] "62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20"                   
#> [15] ""                                                                                   
#> [16] ""                                                                                   
#> [17] ""                                                                                   
#> [18] ""                                                                                   
#> [19] ""                                                                                   
#> [20] ""                                                                                   
#> [21] ""                                                                                   
#> [22] ""                                                                                   
#> [23] "68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49"
#> [24] ""                                                                                   
#> [25] ""                                                                                   
#> [26] "3,123,22,121,19,198,3,23,95,102,45,55,54,9,51,53,135,39,83,22,32,72,98,5,184,24,38" 
#> [27] "17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4"       
#> [28] "93,18,125,104,6,44,74,17,25,136,42,66,26,88,129,5,89,114,14,133,40,1,145,82,49"     
#> [29] ""                                                                                   
#> [30] ""                                                                                   
#> [31] ""                                                                                   
#> [32] ""                                                                                   
#> [33] ""                                                                                   
#> [34] ""                                                                                   
#> [35] ""                                                                                   
#> [36] ""                                                                                   
#> [37] "59,157,11,112,51,2,116,77,6,133,93,0,114,32,17,74,103"                              
#> [38] "61,89,30,41,29,68,15,170,7,133,86,26,55,54,88,16,13,63,22"                          
#> [39] ""                                                                                   
#> [40] ""                                                                                   
#> [41] "11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225"                             
#> [42] "9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73"                                  
#> [43] "191,30,16,5,136,30,35,156,75,19,90,112,9,76,133,75,47,0,24,17"                      
#> [44] ""                                                                                   
#> [45] ""                                                                                   
#> [46] "24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161"                          
#> [47] ""                                                                                   
#> [48] ""                                                                                   
#> [49] "36,44,73,14,35,20,6,162,33,32,108,24,113,116,11,10,111,207,6,21,225"                
#> [50] "52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81"                           
#> [51] "29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31"                         
#> 
#> $sequences
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
#> 
#> $lengths
#>  [1] 102  93  87  81  63   0   0  69  63   0   0  87  84  81   0   0   0   0   0
#> [20]   0   0   0  93   0   0  90  87  84   0   0   0   0   0   0   0   0  96  96
#> [39]   0   0  93  90  87   0   0  96   0   0  96  90  81
#> 
```
