# Write modification information stored in dataframe back to modified FASTQ

This function takes a dataframe containing DNA modification information
(e.g. produced by
[`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md))
and writes it back to modified FASTQ, equivalent to what would be
produced via `samtools fastq -T MM,ML`.  
  
Arguments give the names of columns within the dataframe from which to
read.  
  
If multiple types of modification have been assessed (e.g. both
methylation and hydroxymethylation), then multiple colnames must be
provided for locations and probabilites, and multiple prefixes (e.g.
`"C+h?"`) must be provided. **IMPORTANT:** These three vectors must all
be the same length, and the modification types must be in a consistent
order (e.g. if writing hydroxymethylation and methylation in that order,
must do H then M in all three vectors and never vice versa).  
  
If quality isn't known (e.g. there was a FASTA step at some point in the
pipeline), the `quality` argument can be set to `NA` to fill in quality
scores with `"B"`. This is the same behaviour as SAMtools v1.21 when
converting FASTA to SAM/BAM then FASTQ. I don't really know why SAMtools
decided the default quality should be "B" but there was probably a
reason so I have stuck with that.  
  
Default arguments are set up to work with the included
[`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
data.

## Usage

``` r
write_modified_fastq(
  dataframe,
  filename = NA,
  read_id_colname = "read",
  sequence_colname = "sequence",
  quality_colname = "quality",
  locations_colnames = c("hydroxymethylation_locations", "methylation_locations"),
  probabilities_colnames = c("hydroxymethylation_probabilities",
    "methylation_probabilities"),
  modification_prefixes = c("C+h?", "C+m?"),
  include_blank_tags = TRUE,
  return = FALSE,
  ...
)
```

## Arguments

- dataframe:

  `dataframe`. Dataframe containing modification information to write
  back to modified FASTQ. Must have columns for unique read ID, DNA
  sequence, and at least one set of locations and probabilities for a
  particular modification type (e.g. 5C methylation).

- filename:

  `character`. File to write the FASTQ to. Recommended to end with
  `.fastq` (warns but works if not). If set to `NA` (default), no file
  will be output, which may be useful for testing/debugging.

- read_id_colname:

  `character`. The name of the column within the dataframe that contains
  the unique ID for each read. Defaults to `"read"`.

- sequence_colname:

  `character`. The name of the column within the dataframe that contains
  the DNA sequence for each read. Defaults to `"sequence"`.  
    
  The values within this column must be DNA sequences e.g. `"GGCGGC"`.

- quality_colname:

  `character`. The name of the column within the dataframe that contains
  the FASTQ quality scores for each read. Defaults to `"quality"`. If
  scores are not known, can be set to `NA` to fill in quality with
  `"B"`.  
    
  If not `NA`, must correspond to a column where the values are the
  FASTQ quality scores e.g. `"$12\">/2C;4:9F8:816E,6C3*,"` - see
  [`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md).

- locations_colnames:

  `character vector`. Vector of the names of all columns within the
  dataframe that contain modification locations. Defaults to
  `c("hydroxymethylation_locations", "methylation_locations")`.  
    
  The values within these columns must be comma-separated strings of
  indices at which modification was assessed, as produced by
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md),
  e.g. `"3,6,9,12"`.  
    
  Will fail if these locations are not instances of the target base
  (e.g. `"C"` for `"C+m?"`), as the SAMtools tag system does not work
  otherwise. One consequence of this is that if sequences have been
  reversed via
  [`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
  or helpers, they cannot be written to FASTQ *unless* modification
  locations are symmetric e.g. CpG *and* offset was set to `1` when
  reversing (see
  [`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md)).

- probabilities_colnames:

  `character vector`. Vector of the names of all columns within the
  dataframe that contain modification probabilities. Defaults to
  `c("hydroxymethylation_probabilities", "methylation_probabilities")`.  
    
  The values within the columns must be comma-separated strings of
  modification probabilities, as produced by
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md),
  e.g. `"0,255,128,78"`.

- modification_prefixes:

  `character vector`. Vector of the prefixes to be used for the MM tags
  specifying modification type. These are usually generated by
  Dorado/Guppy based on the original modified basecalling settings, and
  more details can be found in the SAM optional tag specifications.
  Defaults to `c("C+h?", "C+m?")`.  
    
  `locations_colnames`, `probabilities_colnames`, and
  `modification_prefixes` must all have the same length e.g. 2 if there
  were 2 modification types assessed.

- include_blank_tags:

  `logical`. Boolean specifying what to do if a particular read has no
  assessed locations for a given modification type from
  `modification_prefixes`.  
    
  If `TRUE` (default), blank tags will be written e.g. `"C+h?;"`
  (whereas a normal, non-blank tag looks like `"C+h?,0,0,0,0;"`). If
  `FALSE`, tags with no assessed locations in that read will not be
  written at all.

- return:

  `logical`. Boolean specifying whether this function should return the
  FASTQ (as a character vector of each line in the FASTQ), otherwise it
  will return `invisible(NULL)`. Defaults to `FALSE`.

- ...:

  Used to recognise aliases e.g. American spellings or common
  misspellings - see
  [aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).
  If any American spellings do not work, please make a bug report at
  <https://github.com/ejade42/ggDNAvis/issues>.

## Value

`character vector`. The resulting modified FASTQ file as a character
vector of its constituent lines (or `invisible(NULL)` if `return` is
`FALSE`). This is probably mostly useful for debugging, as setting
`filename` within this function directly writes to FASTQ via
[`writeLines()`](https://rdrr.io/r/base/writeLines.html). Therefore,
defaults to returning `invisible(NULL)`.

## Examples

``` r
## Write to FASTQ (using filename = NA, return = FALSE
## to view as char vector rather than writing to file)
write_modified_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = "quality",
    locations_colnames = c("hydroxymethylation_locations",
                           "methylation_locations"),
    probabilities_colnames = c("hydroxymethylation_probabilities",
                               "methylation_probabilities"),
    modification_prefixes = c("C+h?", "C+m?"),
    return = TRUE
)
#>  [1] "F1-1a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34,29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41"                                                               
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                      
#>  [3] "+"                                                                                                                                                                                                                                                                                                                                           
#>  [4] ")8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90"                                                                                                                                                                                                                                      
#>  [5] "F1-1b\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2,10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253"                                                                                                                                       
#>  [6] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                                             
#>  [7] "+"                                                                                                                                                                                                                                                                                                                                           
#>  [8] "60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12\">/2C;4:9F8:816E,6C3*,1-2139"                                                                                                                                                                                                                                                                            
#>  [9] "F1-1c\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37,206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45"                                                                                         
#> [10] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                     
#> [11] "+"                                                                                                                                                                                                                                                                                                                                           
#> [12] ";F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@"                                                                                                                                                                                                                                                     
#> [13] "F1-1d\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55,216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82"                                                                                                  
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                           
#> [15] "+"                                                                                                                                                                                                                                                                                                                                           
#> [16] ":<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0"                                                                                                                                                                                                                                                           
#> [17] "F1-1e\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,57,18,64,31,63,40,23,61,55,34,23,35,23,30,29,24,64,53,7,54,170,236,120,36,139,50,229,99,79,41,229,42,230,34,34,27,130,77,7,79"                                                                                                
#> [18] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                               
#> [19] "+"                                                                                                                                                                                                                                                                                                                                           
#> [20] ";4*2E3-48?@6A-!00!;-3%:H,4H>H530C(85I/&75-62.:2#!/D=A?8&7E!-@:=::5,)51,97D*04'2.!20@/;6)947<6"                                                                                                                                                                                                                                               
#> [21] "F1-2a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,49,9,63,52,41,30,56,33,29,63,9,52,23,12,189,9,144,71,52,34,83,40,33,111,10,182,26,242"                                                                                                                                                                
#> [22] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                                             
#> [23] "+"                                                                                                                                                                                                                                                                                                                                           
#> [24] "E6(<)\"-./EE<(5:47,(C818I9CC1=.&)4G6-7<(*\"(,2C>8/5:0@@).A$97I!-<"                                                                                                                                                                                                                                                                           
#> [25] "F1-2b\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64,31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127"                                                                                                                                     
#> [26] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                                       
#> [27] "+"                                                                                                                                                                                                                                                                                                                                           
#> [28] "F='I#*5I:<F?)<4G3&:95*-5?1,!:9BD4B5.-27577<2E9)2:189B.5/*#7;;'**.7;-!"                                                                                                                                                                                                                                                                       
#> [29] "F1-3a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5,81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250"                                                                                        
#> [30] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                     
#> [31] "+"                                                                                                                                                                                                                                                                                                                                           
#> [32] "?;.*26<C-8B,3#8/,-9!1++:94:/!A317=9>502=-+8;$=53@D*?/6:6&0D7-.@8,5;F,1?0D?$9'&665B8.604"                                                                                                                                                                                                                                                     
#> [33] "F1-3b\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20,147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193"                                                                     
#> [34] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                                                                                                                                                                                                                                                           
#> [35] "+"                                                                                                                                                                                                                                                                                                                                           
#> [36] "*46.5//3:37?24:(:0*#.))E)?:,/172=2!4\">.*/;\"8+5<;D6.I2=>:C3)108,<)GC161)!55E!.>86/"                                                                                                                                                                                                                                                         
#> [37] "F1-3c\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,80,43,103,71,21,112,47,126,21,40,80,35,142,1,238,1,79,111,20,149,181,109,88,194,108,143,30,77,122,88,153,19,244,6,215,161,79,189"                                                                                                 
#> [38] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                        
#> [39] "+"                                                                                                                                                                                                                                                                                                                                           
#> [40] "736/A@B121C269<2I,'5G66>46A6-9*&4*;4-E4C429?I+3@83(234E0%:43;!/3;2+956A0)(+'5G4=*3;1"                                                                                                                                                                                                                                                        
#> [41] "F2-1a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49,163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179"
#> [42] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                               
#> [43] "+"                                                                                                                                                                                                                                                                                                                                           
#> [44] "=</-I354/,*>+<CA40*537/;<@I7/4%6192'5'>#4:&C,072+90:0+4;74\"D5,38&<7A?00+1>G>#=?;,@<<1=64D=!1&"                                                                                                                                                                                                                                              
#> [45] "F2-2a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,93,18,125,104,6,44,74,17,25,136,42,66,26,88,129,5,89,114,14,133,40,1,145,82,49,122,217,108,8,66,85,34,127,205,86,130,126,203,145,27,206,145,54,191,78,125,252,108,62,55"                                  
#> [46] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                        
#> [47] "+"                                                                                                                                                                                                                                                                                                                                           
#> [48] ";1>:5417*<1.2H#260197.;7<(-3?0+=:)ID'I$6*128*!4.7-=5;+384F!=5>4!93+.6I7+H1-).H><68;7"                                                                                                                                                                                                                                                        
#> [49] "F2-2b\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4,176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13"                               
#> [50] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                     
#> [51] "+"                                                                                                                                                                                                                                                                                                                                           
#> [52] "7?38,EC#3::=1)8&;<\">3.9BE)1661!2)5-4.11B<3)?')-+,B4.<7)/:IE=5$.3:66G9216-C20,>(0848(1$-"                                                                                                                                                                                                                                                    
#> [53] "F2-2c\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,3,123,22,121,19,198,3,23,95,102,45,55,54,9,51,53,135,39,83,22,32,72,98,5,184,24,38,191,91,194,96,204,7,129,209,139,68,88,94,109,234,200,188,72,116,73,178,209,167,105,243,62,155,193"             
#> [54] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                                                                                                                                                  
#> [55] "+"                                                                                                                                                                                                                                                                                                                                           
#> [56] "@86,/+6=8/;9=1)48E494IB3456/6.*=</B32+5469>8?@!1;*+81$>-99D7<@1$6B'?462?CE+=1+95=G?.6CA%>2"                                                                                                                                                                                                                                                  
#> [57] "F3-1a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,59,157,11,112,51,2,116,77,6,133,93,0,114,32,17,74,103,177,29,162,79,90,250,137,113,242,115,49,253,140,196,233,174,104"                                                                                                                    
#> [58] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                                                                                                                                                                            
#> [59] "+"                                                                                                                                                                                                                                                                                                                                           
#> [60] "/*2<C643?*8?@9)-.'5A!=3-=;6,.%H3-!10'I>&@?;96;+/+36;:C;B@/=:6,;61>?>!,>.97@.48B38(;7;1F464=-7;)7"                                                                                                                                                                                                                                            
#> [61] "F3-1b\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,61,89,30,41,29,68,15,170,7,133,86,26,55,54,88,16,13,63,22,104,37,50,49,104,89,213,51,220,101,39,87,94,109,48,168,235,187,225"                                                                                                     
#> [62] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                                                                                                                                                                            
#> [63] "+"                                                                                                                                                                                                                                                                                                                                           
#> [64] "/C<$>7/1(9%4:6>6I,D%*,&D?C/6@@;7)83.E.7:@9I906<!4536!850!164/8,<=?=15A;8B/5B364A66.1%9=(9876E8C:"                                                                                                                                                                                                                                            
#> [65] "F3-2a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225,243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11"                                                                                                                  
#> [66] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                                                                                                                                                                               
#> [67] "+"                                                                                                                                                                                                                                                                                                                                           
#> [68] ":0I4099<,4E01;/@96%2I2<,%<C&=81F+4<*@4A5.('4!%I3CE657<=!5;37>4D:%3;7'\"4<.9;?;7%0>:,84B512,B7/"                                                                                                                                                                                                                                              
#> [69] "F3-2b\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73,51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168"                                                                                                                         
#> [70] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"                                                                                                                                                                                                                                                  
#> [71] "+"                                                                                                                                                                                                                                                                                                                                           
#> [72] "9>124!752+@06I/.72097*';-+A60=B?+/8'15477>4-435D;G@G'./21:(0/1/A=7'I>A\"3=9;;12,@\"2=3D=,458"                                                                                                                                                                                                                                                
#> [73] "F3-2c\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,191,30,16,5,136,30,35,156,75,19,90,112,9,76,133,75,47,0,24,17,60,209,185,249,68,224,124,78,101,194,26,107,168,75,53,1,27,55,29,175"                                                                                           
#> [74] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"                                                                                                                                                                                                                                                     
#> [75] "+"                                                                                                                                                                                                                                                                                                                                           
#> [76] "0/2>@/6+-/(!=9-?G!AA70*,/!/?-E46:,-1G94*491,,38?(-!6<8A;/C9;,3)4C06=%',86A)1!E@/24G59<<"                                                                                                                                                                                                                                                     
#> [77] "F3-3a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161,49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48"                                                                                                  
#> [78] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                                                                                                                                                                            
#> [79] "+"                                                                                                                                                                                                                                                                                                                                           
#> [80] "$<,5\"7+!$';8<0794*@FI>34224!57+#1!F<+53$,?)-.A3;=1*71C02<.5:1)82!86$03/;%+1C3+D3;@9B-E#+/70;9<D'"                                                                                                                                                                                                                                           
#> [81] "F3-4a\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,36,44,73,14,35,20,6,162,33,32,108,24,113,116,11,10,111,207,6,21,225,193,24,159,106,198,206,247,55,221,106,131,198,34,105,169,231,88,27,238,51,14"                                                                         
#> [82] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                                                                                                                                                                            
#> [83] "+"                                                                                                                                                                                                                                                                                                                                           
#> [84] "?2-#-2\"1:(5(4>!I)>I,.?-+EG3IH4-.C:;570@2I;?D5#/;A7=>?<3?080::459*?8:3\"<2;I)C1400)6:3%19./);.I?35"                                                                                                                                                                                                                                          
#> [85] "F3-4b\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31,109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224"                                                                                       
#> [86] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                                                                                                                                                                                                                                                           
#> [87] "+"                                                                                                                                                                                                                                                                                                                                           
#> [88] ".85$#;!1F$8E:B+;7CI6@11/'65<3,4G:8@GF1413:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4"                                                                                                                                                                                                                                                           
#> [89] "F3-4c\tMM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81,161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49"                                                                                                     
#> [90] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"                                                                                                                                                                                                                                                  
#> [91] "+"                                                                                                                                                                                                                                                                                                                                           
#> [92] "5@<733';9+3BB)=69,3!.2B*86'8E>@3?!(36:<002/4>:1.43A!+;<.3G*G8?0*991,B(C/\"I9*1-86)8.;;5-0+="                                                                                                                                                                                                                                                 

## Write methylation only, and fill in qualities with "B"
write_modified_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = NA,
    locations_colnames = c("methylation_locations"),
    probabilities_colnames = c("methylation_probabilities"),
    modification_prefixes = c("C+m?"),
    return = TRUE
)
#>  [1] "F1-1a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41"                                     
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                     
#>  [3] "+"                                                                                                                                                                                          
#>  [4] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                     
#>  [5] "F1-1b\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253"                                                                          
#>  [6] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                                            
#>  [7] "+"                                                                                                                                                                                          
#>  [8] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                                            
#>  [9] "F1-1c\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45"                                                 
#> [10] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                    
#> [11] "+"                                                                                                                                                                                          
#> [12] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                    
#> [13] "F1-1d\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82"                                                        
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                          
#> [15] "+"                                                                                                                                                                                          
#> [16] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                          
#> [17] "F1-1e\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,170,236,120,36,139,50,229,99,79,41,229,42,230,34,34,27,130,77,7,79"                                                       
#> [18] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                              
#> [19] "+"                                                                                                                                                                                          
#> [20] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                              
#> [21] "F1-2a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,189,9,144,71,52,34,83,40,33,111,10,182,26,242"                                                                                        
#> [22] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                                                                                                            
#> [23] "+"                                                                                                                                                                                          
#> [24] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                                            
#> [25] "F1-2b\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127"                                                                        
#> [26] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                                                                                                      
#> [27] "+"                                                                                                                                                                                          
#> [28] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                                      
#> [29] "F1-3a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250"                                              
#> [30] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                    
#> [31] "+"                                                                                                                                                                                          
#> [32] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                    
#> [33] "F1-3b\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193"                                      
#> [34] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                                                                                                          
#> [35] "+"                                                                                                                                                                                          
#> [36] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                          
#> [37] "F1-3c\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,149,181,109,88,194,108,143,30,77,122,88,153,19,244,6,215,161,79,189"                                                        
#> [38] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                                                                                                       
#> [39] "+"                                                                                                                                                                                          
#> [40] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                       
#> [41] "F2-1a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179"
#> [42] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                              
#> [43] "+"                                                                                                                                                                                          
#> [44] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                              
#> [45] "F2-2a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,122,217,108,8,66,85,34,127,205,86,130,126,203,145,27,206,145,54,191,78,125,252,108,62,55"                       
#> [46] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                       
#> [47] "+"                                                                                                                                                                                          
#> [48] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                       
#> [49] "F2-2b\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13"                    
#> [50] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                    
#> [51] "+"                                                                                                                                                                                          
#> [52] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                    
#> [53] "F2-2c\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,191,91,194,96,204,7,129,209,139,68,88,94,109,234,200,188,72,116,73,178,209,167,105,243,62,155,193"          
#> [54] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                                                                                                 
#> [55] "+"                                                                                                                                                                                          
#> [56] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                 
#> [57] "F3-1a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,177,29,162,79,90,250,137,113,242,115,49,253,140,196,233,174,104"                                                                
#> [58] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                           
#> [59] "+"                                                                                                                                                                                          
#> [60] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                           
#> [61] "F3-1b\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,104,37,50,49,104,89,213,51,220,101,39,87,94,109,48,168,235,187,225"                                                         
#> [62] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                           
#> [63] "+"                                                                                                                                                                                          
#> [64] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                           
#> [65] "F3-2a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11"                                                                 
#> [66] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                              
#> [67] "+"                                                                                                                                                                                          
#> [68] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                              
#> [69] "F3-2b\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168"                                                                 
#> [70] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"                                                                                                 
#> [71] "+"                                                                                                                                                                                          
#> [72] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                 
#> [73] "F3-2c\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,60,209,185,249,68,224,124,78,101,194,26,107,168,75,53,1,27,55,29,175"                                                     
#> [74] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"                                                                                                    
#> [75] "+"                                                                                                                                                                                          
#> [76] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                    
#> [77] "F3-3a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48"                                                      
#> [78] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                           
#> [79] "+"                                                                                                                                                                                          
#> [80] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                           
#> [81] "F3-4a\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,193,24,159,106,198,206,247,55,221,106,131,198,34,105,169,231,88,27,238,51,14"                                           
#> [82] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"                                                                                           
#> [83] "+"                                                                                                                                                                                          
#> [84] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                           
#> [85] "F3-4b\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224"                                              
#> [86] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                                                                                                          
#> [87] "+"                                                                                                                                                                                          
#> [88] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                          
#> [89] "F3-4c\tMM:Z:C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;\tML:B:C,161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49"                                                        
#> [90] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"                                                                                                 
#> [91] "+"                                                                                                                                                                                          
#> [92] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                                                                                 
```
