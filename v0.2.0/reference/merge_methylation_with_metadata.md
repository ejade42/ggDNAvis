# Merge methylation with metadata

Merge a dataframe of methylation/modification data (as produced by
[`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md))
with a dataframe of metadata, reversing sequence and modification
information if required such that all information is now in the forward
direction.
[`merge_fastq_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_fastq_with_metadata.md)
is the equivalent function for working with unmodified FASTQs (sequence
and quality only).  
  
Methylation/modification dataframe must contain columns of `"read"`
(unique read ID), `"sequence"` (DNA sequence), `"quality"` (FASTQ
quality score), `"sequence_length"` (read length),
`"modification_types"` (a comma-separated string of SAMtools
modification headers produced via
[`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md)
e.g. `"C+h?,C+m?"`), and, for each modification type, a column of
comma-separated strings of modification locations (e.g. `"3,6,9,12"`)
and a column of comma-separated strings of modification probabilities
(e.g. `"255,0,64,128"`). See
[`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md)
for more information on how this dataframe is formatted and produced.
Other columns are allowed but not required, and will be preserved
unaltered in the merged data.  
  
Metadata dataframe must contain `"read"` (unique read ID) and
`"direction"` (read direction, either `"forward"` or `"reverse"` for
each read) columns, and can contain any other columns with arbitrary
information for each read. Columns that might be useful include
participant ID and family designations so that each read can be
associated with its participant and family.  
  
**Important:** A key feature of this function is that it uses the
direction column from the metadata to identify which rows are reverse
reads. These reverse reads will then be reversed-complemented and have
modification information reversed such that all reads are in the forward
direction, ideal for consistent analysis or visualisation. The output
columns are `"forward_sequence"`, `"forward_quality"`,
`"forward_<modification_type>_locations"`, and
`"forward_<modification_type>_probabilities"`.  
  
Calls
[`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md),
[`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md),
[`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md),
and
[`reverse_probabilities_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_probabilities_if_needed.md)
to implement the reversing - see documentation for these functions for
more details. If wanting to write reversed sequences to FASTQ via
[`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md),
locations must be symmetric (e.g. CpG) and offset must be set to 1.
Asymmetric locations are impossible to write to modified FASTQ once
reversed because then e.g. cytosine methylation will be assessed at
guanines, which SAMtools can't account for. Symmetrically reversing CpGs
via `reversed_location_offset = 1` is the only way to fix this.

## Usage

``` r
merge_methylation_with_metadata(
  methylation_data,
  metadata,
  reversed_location_offset = 0,
  reverse_complement_mode = "DNA"
)
```

## Arguments

- methylation_data:

  `dataframe`. A dataframe contaning methylation/modification data, as
  produced by
  [`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md).  
    
  Must contain a read id column (must be called `"read"`), a sequence
  column (`"sequence"`), a quality column (`"quality"`), a sequence
  length column (`"sequence_length"`), a modification types column
  (`"modification_types"`), and, for each modification type listed in
  `modification_types`, a column of locations
  (`"<modification_type>_locations"`) and a column of probabilities
  (`"<modification_type>_probabilities"`). Additional columns are fine
  and will simply be included unaltered in the merged dataframe.  
    
  See
  [`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md)
  documentation for more details about the expected dataframe format.

- metadata:

  `dataframe`. A dataframe containing metadata for each read in
  `methylation_data`.  
    
  Must contain a `"read"` column identical to the column of the same
  name in `methylation_data`, containing unique read IDs (this is used
  to merge the dataframes). Must also contain a `"direction"` column of
  `"forward"` and `"reverse"` (e.g.
  `c("forward", "forward", "reverse")`) indicating the direction of each
  read.  
    
  **Important:** Reverse reads will have their sequence, quality scores,
  modification locations, and modification probabilities reversed such
  that every output read is now forward. These will be stored in columns
  called `"forward_sequence"`, `"forward_quality"`,
  `"forward_<modification_type>_locations"`, and
  `"forward_<modification_type>_probabilities"`. If multiple
  modification types are present, multiple locations and probabilities
  columns will be created.  
    
  See
  [`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md),
  [`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md),
  [`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md),
  and
  [`reverse_probabilities_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_probabilities_if_needed.md)
  documentation for details of how the reversing is implemented.

- reversed_location_offset:

  `integer`. How much modification locations should be shifted by.
  Defaults to `0`. This is important because if a CpG is assessed for
  methylation at the C, then reverse complementing it will give a
  methylation score at the G on the reverse-complemented strand. This is
  the most biologically accurate, but for visualising methylation it may
  be desired to shift the locations by 1 i.e. to correspond with the C
  in the reverse-complemented CpG rather than the G, which allows for
  consistent visualisation between forward and reverse strands. Setting
  (integer) values other than 0 or 1 will work, but may be biologically
  misleading so it is not recommended.  
    
  **Highly recommended:** if considering using this option, read the
  [`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md)
  documentation to fully understand how it works.

- reverse_complement_mode:

  `character`. Whether reverse-complemented sequences should be
  converted to DNA (i.e. A complements to T) or RNA (i.e. A complements
  to U). Must be either `"DNA"` or `"RNA"`. *Only affects
  reverse-complemented sequences. Sequences that were forward to begin
  with are not altered.*  
    
  Uses
  [`reverse_complement()`](https://ejade42.github.io/ggDNAvis/reference/reverse_complement.md)
  via
  [`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md).

## Value

`dataframe`. A merged dataframe containing all columns from the input
dataframes, as well as forward versions of sequences, qualities,
modification locations, and modification probabilities (with separate
locations and probabilities columns created for each modification type
in the modification data).

## Examples

``` r
## Locate files
modified_fastq_file <- system.file("extdata",
                                   "example_many_sequences_raw_modified.fastq",
                                   package = "ggDNAvis")
metadata_file <- system.file("extdata",
                             "example_many_sequences_metadata.csv",
                             package = "ggDNAvis")

## Read files
methylation_data <- read_modified_fastq(modified_fastq_file)
metadata <- read.csv(metadata_file)

## Merge data (including reversing if needed)
merge_methylation_with_metadata(methylation_data, metadata, reversed_location_offset = 0)
#>     read   family individual direction
#> 1  F1-1a Family 1       F1-1   forward
#> 2  F1-1b Family 1       F1-1   forward
#> 3  F1-1c Family 1       F1-1   reverse
#> 4  F1-1d Family 1       F1-1   forward
#> 5  F1-1e Family 1       F1-1   reverse
#> 6  F1-2a Family 1       F1-2   reverse
#> 7  F1-2b Family 1       F1-2   forward
#> 8  F1-3a Family 1       F1-3   forward
#> 9  F1-3b Family 1       F1-3   forward
#> 10 F1-3c Family 1       F1-3   reverse
#> 11 F2-1a Family 2       F2-1   forward
#> 12 F2-2a Family 2       F2-2   reverse
#> 13 F2-2b Family 2       F2-2   forward
#> 14 F2-2c Family 2       F2-2   reverse
#> 15 F3-1a Family 3       F3-1   reverse
#> 16 F3-1b Family 3       F3-1   reverse
#> 17 F3-2a Family 3       F3-2   forward
#> 18 F3-2b Family 3       F3-2   forward
#> 19 F3-2c Family 3       F3-2   reverse
#> 20 F3-3a Family 3       F3-3   forward
#> 21 F3-4a Family 3       F3-4   reverse
#> 22 F3-4b Family 3       F3-4   forward
#> 23 F3-4c Family 3       F3-4   forward
#>                                                                                                  sequence
#> 1  GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 2                                         GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 3                 TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 4                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 5           TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCC
#> 6                                         TCCGCCGCCTCCTCCTCCGCCGCCTCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 7                                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA
#> 8                 GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 9                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA
#> 10                   TCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 11          GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 12                   TCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 13                GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 14             TCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 15       TCCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCGCC
#> 16       TCCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCGCCGCCGCCGCCGCC
#> 17          GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 18             GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA
#> 19                TCCGCCGCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 20       GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 21       TCCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 22                      GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA
#> 23             GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA
#>    sequence_length
#> 1              102
#> 2               63
#> 3               87
#> 4               81
#> 5               93
#> 6               63
#> 7               69
#> 8               87
#> 9               81
#> 10              84
#> 11              93
#> 12              84
#> 13              87
#> 14              90
#> 15              96
#> 16              96
#> 17              93
#> 18              90
#> 19              87
#> 20              96
#> 21              96
#> 22              81
#> 23              90
#>                                                                                                   quality
#> 1  )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90
#> 2                                         60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139
#> 3                 @9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F;
#> 4                       :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0
#> 5           6<749)6;/@02!.2'40*D79,15),5::=:@-!E7&8?A=D/!#2:.26-57&/I58(C035H>H4,H:%3-;!00!-A6@?84-3E2*4;
#> 6                                         <-!I79$A.)@@0:5/8>C2,("*(<7-6G4)&.=1CC9I818C(,74:5(<EE/.-")<(6E
#> 7                                   F='I#*5I:<F?)<4G3&:95*-5?1,!:9BD4B5.-27577<2E9)2:189B.5/*#7;;'**.7;-!
#> 8                 ?;.*26<C-8B,3#8/,-9!1++:94:/!A317=9>502=-+8;$=53@D*?/6:6&0D7-.@8,5;F,1?0D?$9'&665B8.604
#> 9                       *46.5//3:37?24:(:0*#.))E)?:,/172=2!4">.*/;"8+5<;D6.I2=>:C3)108,<)GC161)!55E!.>86/
#> 10                   1;3*=4G5'+()0A659+2;3/!;34:%0E432(38@3+I?924C4E-4;*4&*9-6A64>66G5',I2<962C121B@A/637
#> 11          =</-I354/,*>+<CA40*537/;<@I7/4%6192'5'>#4:&C,072+90:0+4;74"D5,38&<7A?00+1>G>#=?;,@<<1=64D=!1&
#> 12                   7;86<>H.)-1H+7I6.+39!4>5=!F483+;5=-7.4!*821*6$I'DI):=+0?3-(<7;.791062#H2.1<*7145:>1;
#> 13                7?38,EC#3::=1)8&;<">3.9BE)1661!2)5-4.11B<3)?')-+,B4.<7)/:IE=5$.3:66G9216-C20,>(0848(1$-
#> 14             2>%AC6.?G=59+1=+EC?264?'B6$1@<7D99->$18+*;1!@?8>9645+23B/<=*.6/6543BI494E84)1=9;/8=6+/,68@
#> 15       7);7-=464F1;7;(83B84.@79.>,!>?>16;,6:=/@B;C:;63+/+;69;?@&>I'01!-3H%.,6;=-3=!A5'.-)9@?8*?346C<2*/
#> 16       :C8E6789(=9%1.66A463B5/B8;A51=?=<,8/461!058!6354!<609I9@:7.E.38)7;@@6/C?D&,*%D,I6>6:4%9(1/7>$<C/
#> 17          :0I4099<,4E01;/@96%2I2<,%<C&=81F+4<*@4A5.('4!%I3CE657<=!5;37>4D:%3;7'"4<.9;?;7%0>:,84B512,B7/
#> 18             9>124!752+@06I/.72097*';-+A60=B?+/8'15477>4-435D;G@G'./21:(0/1/A=7'I>A"3=9;;12,@"2=3D=,458
#> 19                <<95G42/@E!1)A68,'%=60C4)3,;9C/;A8<6!-(?83,,194*49G1-,:64E-?/!/,*07AA!G?-9=!(/-+6/@>2/0
#> 20       $<,5"7+!$';8<0794*@FI>34224!57+#1!F<+53$,?)-.A3;=1*71C02<.5:1)82!86$03/;%+1C3+D3;@9B-E#+/70;9<D'
#> 21       53?I.;)/.91%3:6)0041C)I;2<"3:8?*954::080?3<?>=7A;/#5D?;I2@075;:C.-4HI3GE+-?.,I>)I!>4(5(:1"2-#-2?
#> 22                      .85$#;!1F$8E:B+;7CI6@11/'65<3,4G:8@GF1413:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4
#> 23             5@<733';9+3BB)=69,3!.2B*86'8E>@3?!(36:<002/4>:1.43A!+;<.3G*G8?0*991,B(C/"I9*1-86)8.;;5-0+=
#>    modification_types
#> 1           C+h?,C+m?
#> 2           C+h?,C+m?
#> 3           C+h?,C+m?
#> 4           C+h?,C+m?
#> 5           C+h?,C+m?
#> 6           C+h?,C+m?
#> 7           C+h?,C+m?
#> 8           C+h?,C+m?
#> 9           C+h?,C+m?
#> 10          C+h?,C+m?
#> 11          C+h?,C+m?
#> 12          C+h?,C+m?
#> 13          C+h?,C+m?
#> 14          C+h?,C+m?
#> 15          C+h?,C+m?
#> 16          C+h?,C+m?
#> 17          C+h?,C+m?
#> 18          C+h?,C+m?
#> 19          C+h?,C+m?
#> 20          C+h?,C+m?
#> 21          C+h?,C+m?
#> 22          C+h?,C+m?
#> 23          C+h?,C+m?
#>                                                                      C+h?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,75,78,81,84,87,90
#> 6                                           3,6,18,21,33,36,39,42,45,48,51,54,57,60
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                           3,6,15,18,27,30,33,42,45,48,57,60,63,66,69,72,75,78,81
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12         3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14   3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81,84,87
#> 15                                 3,6,15,18,27,30,39,42,51,54,63,66,75,78,87,90,93
#> 16                           3,6,15,18,27,30,39,42,51,54,63,66,75,78,81,84,87,90,93
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                         3,6,9,12,21,24,33,36,45,48,57,60,63,66,69,72,75,78,81,84
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                     3,6,15,18,27,30,39,42,51,54,63,66,69,72,75,78,81,84,87,90,93
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                                     C+h?_probabilities
#> 1                  26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34
#> 2                                       10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2
#> 3                          37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40
#> 4                            33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55
#> 5                           54,7,53,64,24,29,30,23,35,23,34,55,61,23,40,63,31,64,18,57
#> 6                                              12,23,52,9,63,29,33,56,30,41,52,63,9,49
#> 7                                       27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64
#> 8                            55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5
#> 9                     62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20
#> 10                        20,111,79,1,238,1,142,35,80,40,21,126,47,112,21,71,103,43,80
#> 11 68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49
#> 12      49,82,145,1,40,133,14,114,89,5,129,88,26,66,42,136,25,17,74,44,6,104,125,18,93
#> 13        17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4
#> 14  38,24,184,5,98,72,32,22,83,39,135,53,51,9,54,55,45,102,95,23,3,198,19,121,22,123,3
#> 15                               103,74,17,32,114,0,93,133,6,77,116,2,51,112,11,157,59
#> 16                           22,63,13,16,88,54,55,26,86,133,7,170,15,68,29,41,30,89,61
#> 17                              11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225
#> 18                                   9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73
#> 19                       17,24,0,47,75,133,76,9,112,90,19,75,156,35,30,136,5,16,30,191
#> 20                           24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161
#> 21                 225,21,6,207,111,10,11,116,113,24,108,32,33,162,6,20,35,14,73,44,36
#> 22                          29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31
#> 23                            52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81
#>                                                                      C+m?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,75,78,81,84,87,90
#> 6                                           3,6,18,21,33,36,39,42,45,48,51,54,57,60
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                           3,6,15,18,27,30,33,42,45,48,57,60,63,66,69,72,75,78,81
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12         3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14   3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81,84,87
#> 15                                 3,6,15,18,27,30,39,42,51,54,63,66,75,78,87,90,93
#> 16                           3,6,15,18,27,30,39,42,51,54,63,66,75,78,81,84,87,90,93
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                         3,6,9,12,21,24,33,36,45,48,57,60,63,66,69,72,75,78,81,84
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                     3,6,15,18,27,30,39,42,51,54,63,66,69,72,75,78,81,84,87,90,93
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                                                           C+m?_probabilities
#> 1                             29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41
#> 2                                                    10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253
#> 3                                   45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206
#> 4                                          216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82
#> 5                                         79,7,77,130,27,34,34,230,42,229,41,79,99,229,50,139,36,120,236,170
#> 6                                                              242,26,182,10,111,33,40,83,34,52,71,144,9,189
#> 7                                                  31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127
#> 8                                81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250
#> 9                            147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193
#> 10                                       189,79,161,215,6,244,19,153,88,122,77,30,143,108,194,88,109,181,149
#> 11 163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179
#> 12                  55,62,108,252,125,78,191,54,145,206,27,145,203,126,130,86,205,127,34,85,66,8,108,217,122
#> 13                 176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13
#> 14         193,155,62,243,105,167,209,178,73,116,72,188,200,234,109,94,88,68,139,209,129,7,204,96,194,91,191
#> 15                                           104,174,233,196,140,253,49,115,242,113,137,250,90,79,162,29,177
#> 16                                        225,187,235,168,48,109,94,87,39,101,220,51,213,89,104,49,50,37,104
#> 17                                              243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11
#> 18                                            51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168
#> 19                                      175,29,55,27,1,53,75,168,107,26,194,101,78,124,224,68,249,185,209,60
#> 20                                     49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48
#> 21                              14,51,238,27,88,231,169,105,34,198,131,106,221,55,247,206,198,106,159,24,193
#> 22                               109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224
#> 23                                       161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49
#>                                                                                          forward_sequence
#> 1  GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 2                                         GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 3                 GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 4                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 5           GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 6                                         GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA
#> 7                                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA
#> 8                 GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 9                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA
#> 10                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA
#> 11          GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 12                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 13                GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 14             GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 15       GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 16       GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 17          GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 18             GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA
#> 19                GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA
#> 20       GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 21       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 22                      GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA
#> 23             GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA
#>                                                                                           forward_quality
#> 1  )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90
#> 2                                         60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139
#> 3                 ;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@
#> 4                       :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0
#> 5           ;4*2E3-48?@6A-!00!;-3%:H,4H>H530C(85I/&75-62.:2#!/D=A?8&7E!-@:=::5,)51,97D*04'2.!20@/;6)947<6
#> 6                                         E6(<)"-./EE<(5:47,(C818I9CC1=.&)4G6-7<(*"(,2C>8/5:0@@).A$97I!-<
#> 7                                   F='I#*5I:<F?)<4G3&:95*-5?1,!:9BD4B5.-27577<2E9)2:189B.5/*#7;;'**.7;-!
#> 8                 ?;.*26<C-8B,3#8/,-9!1++:94:/!A317=9>502=-+8;$=53@D*?/6:6&0D7-.@8,5;F,1?0D?$9'&665B8.604
#> 9                       *46.5//3:37?24:(:0*#.))E)?:,/172=2!4">.*/;"8+5<;D6.I2=>:C3)108,<)GC161)!55E!.>86/
#> 10                   736/A@B121C269<2I,'5G66>46A6-9*&4*;4-E4C429?I+3@83(234E0%:43;!/3;2+956A0)(+'5G4=*3;1
#> 11          =</-I354/,*>+<CA40*537/;<@I7/4%6192'5'>#4:&C,072+90:0+4;74"D5,38&<7A?00+1>G>#=?;,@<<1=64D=!1&
#> 12                   ;1>:5417*<1.2H#260197.;7<(-3?0+=:)ID'I$6*128*!4.7-=5;+384F!=5>4!93+.6I7+H1-).H><68;7
#> 13                7?38,EC#3::=1)8&;<">3.9BE)1661!2)5-4.11B<3)?')-+,B4.<7)/:IE=5$.3:66G9216-C20,>(0848(1$-
#> 14             @86,/+6=8/;9=1)48E494IB3456/6.*=</B32+5469>8?@!1;*+81$>-99D7<@1$6B'?462?CE+=1+95=G?.6CA%>2
#> 15       /*2<C643?*8?@9)-.'5A!=3-=;6,.%H3-!10'I>&@?;96;+/+36;:C;B@/=:6,;61>?>!,>.97@.48B38(;7;1F464=-7;)7
#> 16       /C<$>7/1(9%4:6>6I,D%*,&D?C/6@@;7)83.E.7:@9I906<!4536!850!164/8,<=?=15A;8B/5B364A66.1%9=(9876E8C:
#> 17          :0I4099<,4E01;/@96%2I2<,%<C&=81F+4<*@4A5.('4!%I3CE657<=!5;37>4D:%3;7'"4<.9;?;7%0>:,84B512,B7/
#> 18             9>124!752+@06I/.72097*';-+A60=B?+/8'15477>4-435D;G@G'./21:(0/1/A=7'I>A"3=9;;12,@"2=3D=,458
#> 19                0/2>@/6+-/(!=9-?G!AA70*,/!/?-E46:,-1G94*491,,38?(-!6<8A;/C9;,3)4C06=%',86A)1!E@/24G59<<
#> 20       $<,5"7+!$';8<0794*@FI>34224!57+#1!F<+53$,?)-.A3;=1*71C02<.5:1)82!86$03/;%+1C3+D3;@9B-E#+/70;9<D'
#> 21       ?2-#-2"1:(5(4>!I)>I,.?-+EG3IH4-.C:;570@2I;?D5#/;A7=>?<3?080::459*?8:3"<2;I)C1400)6:3%19./);.I?35
#> 22                      .85$#;!1F$8E:B+;7CI6@11/'65<3,4G:8@GF1413:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4
#> 23             5@<733';9+3BB)=69,3!.2B*86'8E>@3?!(36:<002/4>:1.43A!+;<.3G*G8?0*991,B(C/"I9*1-86)8.;;5-0+=
#>                                                              forward_C+h?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                         4,7,10,13,16,19,22,25,28,37,40,43,52,55,58,67,70,73,82,85
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                         4,7,10,13,16,19,28,31,34,43,46,49,58,61,64,73,76,79,88,91
#> 6                                           4,7,10,13,16,19,22,25,28,31,43,46,58,61
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                           4,7,10,13,16,19,22,25,28,37,40,43,52,55,58,67,70,79,82
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12         4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,79,82
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14   4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,73,76,85,88
#> 15                                 4,7,10,19,22,31,34,43,46,55,58,67,70,79,82,91,94
#> 16                           4,7,10,13,16,19,22,31,34,43,46,55,58,67,70,79,82,91,94
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                        4,7,10,13,16,19,22,25,28,31,40,43,52,55,64,67,76,79,82,85
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                     4,7,10,13,16,19,22,25,28,31,34,43,46,55,58,67,70,79,82,91,94
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                             forward_C+h?_probabilities
#> 1                  26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34
#> 2                                       10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2
#> 3                          40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37
#> 4                            33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55
#> 5                           57,18,64,31,63,40,23,61,55,34,23,35,23,30,29,24,64,53,7,54
#> 6                                              49,9,63,52,41,30,56,33,29,63,9,52,23,12
#> 7                                       27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64
#> 8                            55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5
#> 9                     62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20
#> 10                        80,43,103,71,21,112,47,126,21,40,80,35,142,1,238,1,79,111,20
#> 11 68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49
#> 12      93,18,125,104,6,44,74,17,25,136,42,66,26,88,129,5,89,114,14,133,40,1,145,82,49
#> 13        17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4
#> 14  3,123,22,121,19,198,3,23,95,102,45,55,54,9,51,53,135,39,83,22,32,72,98,5,184,24,38
#> 15                               59,157,11,112,51,2,116,77,6,133,93,0,114,32,17,74,103
#> 16                           61,89,30,41,29,68,15,170,7,133,86,26,55,54,88,16,13,63,22
#> 17                              11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225
#> 18                                   9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73
#> 19                       191,30,16,5,136,30,35,156,75,19,90,112,9,76,133,75,47,0,24,17
#> 20                           24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161
#> 21                 36,44,73,14,35,20,6,162,33,32,108,24,113,116,11,10,111,207,6,21,225
#> 22                          29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31
#> 23                            52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81
#>                                                              forward_C+m?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                         4,7,10,13,16,19,22,25,28,37,40,43,52,55,58,67,70,73,82,85
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                         4,7,10,13,16,19,28,31,34,43,46,49,58,61,64,73,76,79,88,91
#> 6                                           4,7,10,13,16,19,22,25,28,31,43,46,58,61
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                           4,7,10,13,16,19,22,25,28,37,40,43,52,55,58,67,70,79,82
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12         4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,79,82
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14   4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,73,76,85,88
#> 15                                 4,7,10,19,22,31,34,43,46,55,58,67,70,79,82,91,94
#> 16                           4,7,10,13,16,19,22,31,34,43,46,55,58,67,70,79,82,91,94
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                        4,7,10,13,16,19,22,25,28,31,40,43,52,55,64,67,76,79,82,85
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                     4,7,10,13,16,19,22,25,28,31,34,43,46,55,58,67,70,79,82,91,94
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                                                   forward_C+m?_probabilities
#> 1                             29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41
#> 2                                                    10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253
#> 3                                   206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45
#> 4                                          216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82
#> 5                                         170,236,120,36,139,50,229,99,79,41,229,42,230,34,34,27,130,77,7,79
#> 6                                                              189,9,144,71,52,34,83,40,33,111,10,182,26,242
#> 7                                                  31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127
#> 8                                81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250
#> 9                            147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193
#> 10                                       149,181,109,88,194,108,143,30,77,122,88,153,19,244,6,215,161,79,189
#> 11 163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179
#> 12                  122,217,108,8,66,85,34,127,205,86,130,126,203,145,27,206,145,54,191,78,125,252,108,62,55
#> 13                 176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13
#> 14         191,91,194,96,204,7,129,209,139,68,88,94,109,234,200,188,72,116,73,178,209,167,105,243,62,155,193
#> 15                                           177,29,162,79,90,250,137,113,242,115,49,253,140,196,233,174,104
#> 16                                        104,37,50,49,104,89,213,51,220,101,39,87,94,109,48,168,235,187,225
#> 17                                              243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11
#> 18                                            51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168
#> 19                                      60,209,185,249,68,224,124,78,101,194,26,107,168,75,53,1,27,55,29,175
#> 20                                     49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48
#> 21                              193,24,159,106,198,206,247,55,221,106,131,198,34,105,169,231,88,27,238,51,14
#> 22                               109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224
#> 23                                       161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49

## Merge data with offset = 1
merge_methylation_with_metadata(methylation_data, metadata, reversed_location_offset = 1)
#>     read   family individual direction
#> 1  F1-1a Family 1       F1-1   forward
#> 2  F1-1b Family 1       F1-1   forward
#> 3  F1-1c Family 1       F1-1   reverse
#> 4  F1-1d Family 1       F1-1   forward
#> 5  F1-1e Family 1       F1-1   reverse
#> 6  F1-2a Family 1       F1-2   reverse
#> 7  F1-2b Family 1       F1-2   forward
#> 8  F1-3a Family 1       F1-3   forward
#> 9  F1-3b Family 1       F1-3   forward
#> 10 F1-3c Family 1       F1-3   reverse
#> 11 F2-1a Family 2       F2-1   forward
#> 12 F2-2a Family 2       F2-2   reverse
#> 13 F2-2b Family 2       F2-2   forward
#> 14 F2-2c Family 2       F2-2   reverse
#> 15 F3-1a Family 3       F3-1   reverse
#> 16 F3-1b Family 3       F3-1   reverse
#> 17 F3-2a Family 3       F3-2   forward
#> 18 F3-2b Family 3       F3-2   forward
#> 19 F3-2c Family 3       F3-2   reverse
#> 20 F3-3a Family 3       F3-3   forward
#> 21 F3-4a Family 3       F3-4   reverse
#> 22 F3-4b Family 3       F3-4   forward
#> 23 F3-4c Family 3       F3-4   forward
#>                                                                                                  sequence
#> 1  GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 2                                         GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 3                 TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 4                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 5           TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCC
#> 6                                         TCCGCCGCCTCCTCCTCCGCCGCCTCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 7                                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA
#> 8                 GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 9                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA
#> 10                   TCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 11          GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 12                   TCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 13                GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 14             TCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 15       TCCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCGCC
#> 16       TCCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCGCCGCCGCCGCCGCC
#> 17          GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 18             GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA
#> 19                TCCGCCGCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 20       GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 21       TCCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCACCACCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCCGCC
#> 22                      GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA
#> 23             GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA
#>    sequence_length
#> 1              102
#> 2               63
#> 3               87
#> 4               81
#> 5               93
#> 6               63
#> 7               69
#> 8               87
#> 9               81
#> 10              84
#> 11              93
#> 12              84
#> 13              87
#> 14              90
#> 15              96
#> 16              96
#> 17              93
#> 18              90
#> 19              87
#> 20              96
#> 21              96
#> 22              81
#> 23              90
#>                                                                                                   quality
#> 1  )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90
#> 2                                         60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139
#> 3                 @9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F;
#> 4                       :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0
#> 5           6<749)6;/@02!.2'40*D79,15),5::=:@-!E7&8?A=D/!#2:.26-57&/I58(C035H>H4,H:%3-;!00!-A6@?84-3E2*4;
#> 6                                         <-!I79$A.)@@0:5/8>C2,("*(<7-6G4)&.=1CC9I818C(,74:5(<EE/.-")<(6E
#> 7                                   F='I#*5I:<F?)<4G3&:95*-5?1,!:9BD4B5.-27577<2E9)2:189B.5/*#7;;'**.7;-!
#> 8                 ?;.*26<C-8B,3#8/,-9!1++:94:/!A317=9>502=-+8;$=53@D*?/6:6&0D7-.@8,5;F,1?0D?$9'&665B8.604
#> 9                       *46.5//3:37?24:(:0*#.))E)?:,/172=2!4">.*/;"8+5<;D6.I2=>:C3)108,<)GC161)!55E!.>86/
#> 10                   1;3*=4G5'+()0A659+2;3/!;34:%0E432(38@3+I?924C4E-4;*4&*9-6A64>66G5',I2<962C121B@A/637
#> 11          =</-I354/,*>+<CA40*537/;<@I7/4%6192'5'>#4:&C,072+90:0+4;74"D5,38&<7A?00+1>G>#=?;,@<<1=64D=!1&
#> 12                   7;86<>H.)-1H+7I6.+39!4>5=!F483+;5=-7.4!*821*6$I'DI):=+0?3-(<7;.791062#H2.1<*7145:>1;
#> 13                7?38,EC#3::=1)8&;<">3.9BE)1661!2)5-4.11B<3)?')-+,B4.<7)/:IE=5$.3:66G9216-C20,>(0848(1$-
#> 14             2>%AC6.?G=59+1=+EC?264?'B6$1@<7D99->$18+*;1!@?8>9645+23B/<=*.6/6543BI494E84)1=9;/8=6+/,68@
#> 15       7);7-=464F1;7;(83B84.@79.>,!>?>16;,6:=/@B;C:;63+/+;69;?@&>I'01!-3H%.,6;=-3=!A5'.-)9@?8*?346C<2*/
#> 16       :C8E6789(=9%1.66A463B5/B8;A51=?=<,8/461!058!6354!<609I9@:7.E.38)7;@@6/C?D&,*%D,I6>6:4%9(1/7>$<C/
#> 17          :0I4099<,4E01;/@96%2I2<,%<C&=81F+4<*@4A5.('4!%I3CE657<=!5;37>4D:%3;7'"4<.9;?;7%0>:,84B512,B7/
#> 18             9>124!752+@06I/.72097*';-+A60=B?+/8'15477>4-435D;G@G'./21:(0/1/A=7'I>A"3=9;;12,@"2=3D=,458
#> 19                <<95G42/@E!1)A68,'%=60C4)3,;9C/;A8<6!-(?83,,194*49G1-,:64E-?/!/,*07AA!G?-9=!(/-+6/@>2/0
#> 20       $<,5"7+!$';8<0794*@FI>34224!57+#1!F<+53$,?)-.A3;=1*71C02<.5:1)82!86$03/;%+1C3+D3;@9B-E#+/70;9<D'
#> 21       53?I.;)/.91%3:6)0041C)I;2<"3:8?*954::080?3<?>=7A;/#5D?;I2@075;:C.-4HI3GE+-?.,I>)I!>4(5(:1"2-#-2?
#> 22                      .85$#;!1F$8E:B+;7CI6@11/'65<3,4G:8@GF1413:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4
#> 23             5@<733';9+3BB)=69,3!.2B*86'8E>@3?!(36:<002/4>:1.43A!+;<.3G*G8?0*991,B(C/"I9*1-86)8.;;5-0+=
#>    modification_types
#> 1           C+h?,C+m?
#> 2           C+h?,C+m?
#> 3           C+h?,C+m?
#> 4           C+h?,C+m?
#> 5           C+h?,C+m?
#> 6           C+h?,C+m?
#> 7           C+h?,C+m?
#> 8           C+h?,C+m?
#> 9           C+h?,C+m?
#> 10          C+h?,C+m?
#> 11          C+h?,C+m?
#> 12          C+h?,C+m?
#> 13          C+h?,C+m?
#> 14          C+h?,C+m?
#> 15          C+h?,C+m?
#> 16          C+h?,C+m?
#> 17          C+h?,C+m?
#> 18          C+h?,C+m?
#> 19          C+h?,C+m?
#> 20          C+h?,C+m?
#> 21          C+h?,C+m?
#> 22          C+h?,C+m?
#> 23          C+h?,C+m?
#>                                                                      C+h?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,75,78,81,84,87,90
#> 6                                           3,6,18,21,33,36,39,42,45,48,51,54,57,60
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                           3,6,15,18,27,30,33,42,45,48,57,60,63,66,69,72,75,78,81
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12         3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14   3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81,84,87
#> 15                                 3,6,15,18,27,30,39,42,51,54,63,66,75,78,87,90,93
#> 16                           3,6,15,18,27,30,39,42,51,54,63,66,75,78,81,84,87,90,93
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                         3,6,9,12,21,24,33,36,45,48,57,60,63,66,69,72,75,78,81,84
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                     3,6,15,18,27,30,39,42,51,54,63,66,69,72,75,78,81,84,87,90,93
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                                     C+h?_probabilities
#> 1                  26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34
#> 2                                       10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2
#> 3                          37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40
#> 4                            33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55
#> 5                           54,7,53,64,24,29,30,23,35,23,34,55,61,23,40,63,31,64,18,57
#> 6                                              12,23,52,9,63,29,33,56,30,41,52,63,9,49
#> 7                                       27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64
#> 8                            55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5
#> 9                     62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20
#> 10                        20,111,79,1,238,1,142,35,80,40,21,126,47,112,21,71,103,43,80
#> 11 68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49
#> 12      49,82,145,1,40,133,14,114,89,5,129,88,26,66,42,136,25,17,74,44,6,104,125,18,93
#> 13        17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4
#> 14  38,24,184,5,98,72,32,22,83,39,135,53,51,9,54,55,45,102,95,23,3,198,19,121,22,123,3
#> 15                               103,74,17,32,114,0,93,133,6,77,116,2,51,112,11,157,59
#> 16                           22,63,13,16,88,54,55,26,86,133,7,170,15,68,29,41,30,89,61
#> 17                              11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225
#> 18                                   9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73
#> 19                       17,24,0,47,75,133,76,9,112,90,19,75,156,35,30,136,5,16,30,191
#> 20                           24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161
#> 21                 225,21,6,207,111,10,11,116,113,24,108,32,33,162,6,20,35,14,73,44,36
#> 22                          29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31
#> 23                            52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81
#>                                                                      C+m?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                         3,6,15,18,21,30,33,36,45,48,51,60,63,66,75,78,81,84,87,90
#> 6                                           3,6,18,21,33,36,39,42,45,48,51,54,57,60
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                           3,6,15,18,27,30,33,42,45,48,57,60,63,66,69,72,75,78,81
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12         3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14   3,6,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81,84,87
#> 15                                 3,6,15,18,27,30,39,42,51,54,63,66,75,78,87,90,93
#> 16                           3,6,15,18,27,30,39,42,51,54,63,66,75,78,81,84,87,90,93
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                         3,6,9,12,21,24,33,36,45,48,57,60,63,66,69,72,75,78,81,84
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                     3,6,15,18,27,30,39,42,51,54,63,66,69,72,75,78,81,84,87,90,93
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                                                           C+m?_probabilities
#> 1                             29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41
#> 2                                                    10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253
#> 3                                   45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206
#> 4                                          216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82
#> 5                                         79,7,77,130,27,34,34,230,42,229,41,79,99,229,50,139,36,120,236,170
#> 6                                                              242,26,182,10,111,33,40,83,34,52,71,144,9,189
#> 7                                                  31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127
#> 8                                81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250
#> 9                            147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193
#> 10                                       189,79,161,215,6,244,19,153,88,122,77,30,143,108,194,88,109,181,149
#> 11 163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179
#> 12                  55,62,108,252,125,78,191,54,145,206,27,145,203,126,130,86,205,127,34,85,66,8,108,217,122
#> 13                 176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13
#> 14         193,155,62,243,105,167,209,178,73,116,72,188,200,234,109,94,88,68,139,209,129,7,204,96,194,91,191
#> 15                                           104,174,233,196,140,253,49,115,242,113,137,250,90,79,162,29,177
#> 16                                        225,187,235,168,48,109,94,87,39,101,220,51,213,89,104,49,50,37,104
#> 17                                              243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11
#> 18                                            51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168
#> 19                                      175,29,55,27,1,53,75,168,107,26,194,101,78,124,224,68,249,185,209,60
#> 20                                     49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48
#> 21                              14,51,238,27,88,231,169,105,34,198,131,106,221,55,247,206,198,106,159,24,193
#> 22                               109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224
#> 23                                       161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49
#>                                                                                          forward_sequence
#> 1  GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 2                                         GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 3                 GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 4                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 5           GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 6                                         GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA
#> 7                                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA
#> 8                 GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
#> 9                       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA
#> 10                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA
#> 11          GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 12                   GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 13                GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 14             GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
#> 15       GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 16       GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 17          GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 18             GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA
#> 19                GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA
#> 20       GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 21       GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
#> 22                      GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA
#> 23             GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA
#>                                                                                           forward_quality
#> 1  )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90
#> 2                                         60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139
#> 3                 ;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@
#> 4                       :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0
#> 5           ;4*2E3-48?@6A-!00!;-3%:H,4H>H530C(85I/&75-62.:2#!/D=A?8&7E!-@:=::5,)51,97D*04'2.!20@/;6)947<6
#> 6                                         E6(<)"-./EE<(5:47,(C818I9CC1=.&)4G6-7<(*"(,2C>8/5:0@@).A$97I!-<
#> 7                                   F='I#*5I:<F?)<4G3&:95*-5?1,!:9BD4B5.-27577<2E9)2:189B.5/*#7;;'**.7;-!
#> 8                 ?;.*26<C-8B,3#8/,-9!1++:94:/!A317=9>502=-+8;$=53@D*?/6:6&0D7-.@8,5;F,1?0D?$9'&665B8.604
#> 9                       *46.5//3:37?24:(:0*#.))E)?:,/172=2!4">.*/;"8+5<;D6.I2=>:C3)108,<)GC161)!55E!.>86/
#> 10                   736/A@B121C269<2I,'5G66>46A6-9*&4*;4-E4C429?I+3@83(234E0%:43;!/3;2+956A0)(+'5G4=*3;1
#> 11          =</-I354/,*>+<CA40*537/;<@I7/4%6192'5'>#4:&C,072+90:0+4;74"D5,38&<7A?00+1>G>#=?;,@<<1=64D=!1&
#> 12                   ;1>:5417*<1.2H#260197.;7<(-3?0+=:)ID'I$6*128*!4.7-=5;+384F!=5>4!93+.6I7+H1-).H><68;7
#> 13                7?38,EC#3::=1)8&;<">3.9BE)1661!2)5-4.11B<3)?')-+,B4.<7)/:IE=5$.3:66G9216-C20,>(0848(1$-
#> 14             @86,/+6=8/;9=1)48E494IB3456/6.*=</B32+5469>8?@!1;*+81$>-99D7<@1$6B'?462?CE+=1+95=G?.6CA%>2
#> 15       /*2<C643?*8?@9)-.'5A!=3-=;6,.%H3-!10'I>&@?;96;+/+36;:C;B@/=:6,;61>?>!,>.97@.48B38(;7;1F464=-7;)7
#> 16       /C<$>7/1(9%4:6>6I,D%*,&D?C/6@@;7)83.E.7:@9I906<!4536!850!164/8,<=?=15A;8B/5B364A66.1%9=(9876E8C:
#> 17          :0I4099<,4E01;/@96%2I2<,%<C&=81F+4<*@4A5.('4!%I3CE657<=!5;37>4D:%3;7'"4<.9;?;7%0>:,84B512,B7/
#> 18             9>124!752+@06I/.72097*';-+A60=B?+/8'15477>4-435D;G@G'./21:(0/1/A=7'I>A"3=9;;12,@"2=3D=,458
#> 19                0/2>@/6+-/(!=9-?G!AA70*,/!/?-E46:,-1G94*491,,38?(-!6<8A;/C9;,3)4C06=%',86A)1!E@/24G59<<
#> 20       $<,5"7+!$';8<0794*@FI>34224!57+#1!F<+53$,?)-.A3;=1*71C02<.5:1)82!86$03/;%+1C3+D3;@9B-E#+/70;9<D'
#> 21       ?2-#-2"1:(5(4>!I)>I,.?-+EG3IH4-.C:;570@2I;?D5#/;A7=>?<3?080::459*?8:3"<2;I)C1400)6:3%19./);.I?35
#> 22                      .85$#;!1F$8E:B+;7CI6@11/'65<3,4G:8@GF1413:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4
#> 23             5@<733';9+3BB)=69,3!.2B*86'8E>@3?!(36:<002/4>:1.43A!+;<.3G*G8?0*991,B(C/"I9*1-86)8.;;5-0+=
#>                                                              forward_C+h?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                          3,6,9,12,15,18,27,30,33,42,45,48,57,60,63,72,75,78,87,90
#> 6                                            3,6,9,12,15,18,21,24,27,30,42,45,57,60
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                            3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,78,81
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12          3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,78,81
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,84,87
#> 15                                  3,6,9,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 16                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                         3,6,9,12,15,18,21,24,27,30,39,42,51,54,63,66,75,78,81,84
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                      3,6,9,12,15,18,21,24,27,30,33,42,45,54,57,66,69,78,81,90,93
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                             forward_C+h?_probabilities
#> 1                  26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34
#> 2                                       10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2
#> 3                          40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37
#> 4                            33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55
#> 5                           57,18,64,31,63,40,23,61,55,34,23,35,23,30,29,24,64,53,7,54
#> 6                                              49,9,63,52,41,30,56,33,29,63,9,52,23,12
#> 7                                       27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64
#> 8                            55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5
#> 9                     62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20
#> 10                        80,43,103,71,21,112,47,126,21,40,80,35,142,1,238,1,79,111,20
#> 11 68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49
#> 12      93,18,125,104,6,44,74,17,25,136,42,66,26,88,129,5,89,114,14,133,40,1,145,82,49
#> 13        17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4
#> 14  3,123,22,121,19,198,3,23,95,102,45,55,54,9,51,53,135,39,83,22,32,72,98,5,184,24,38
#> 15                               59,157,11,112,51,2,116,77,6,133,93,0,114,32,17,74,103
#> 16                           61,89,30,41,29,68,15,170,7,133,86,26,55,54,88,16,13,63,22
#> 17                              11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225
#> 18                                   9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73
#> 19                       191,30,16,5,136,30,35,156,75,19,90,112,9,76,133,75,47,0,24,17
#> 20                           24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161
#> 21                 36,44,73,14,35,20,6,162,33,32,108,24,113,116,11,10,111,207,6,21,225
#> 22                          29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31
#> 23                            52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81
#>                                                              forward_C+m?_locations
#> 1                 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
#> 2                                      3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
#> 3                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 4                          3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
#> 5                          3,6,9,12,15,18,27,30,33,42,45,48,57,60,63,72,75,78,87,90
#> 6                                            3,6,9,12,15,18,21,24,27,30,42,45,57,60
#> 7                                      3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66
#> 8                          3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
#> 9                    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
#> 10                            3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,78,81
#> 11 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
#> 12          3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,78,81
#> 13       3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84
#> 14    3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,84,87
#> 15                                  3,6,9,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 16                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 17                               3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
#> 18                                  3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
#> 19                         3,6,9,12,15,18,21,24,27,30,39,42,51,54,63,66,75,78,81,84
#> 20                            3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
#> 21                      3,6,9,12,15,18,21,24,27,30,33,42,45,54,57,66,69,78,81,90,93
#> 22                         3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
#> 23                            3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
#>                                                                                   forward_C+m?_probabilities
#> 1                             29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41
#> 2                                                    10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253
#> 3                                   206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45
#> 4                                          216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82
#> 5                                         170,236,120,36,139,50,229,99,79,41,229,42,230,34,34,27,130,77,7,79
#> 6                                                              189,9,144,71,52,34,83,40,33,111,10,182,26,242
#> 7                                                  31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127
#> 8                                81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250
#> 9                            147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193
#> 10                                       149,181,109,88,194,108,143,30,77,122,88,153,19,244,6,215,161,79,189
#> 11 163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179
#> 12                  122,217,108,8,66,85,34,127,205,86,130,126,203,145,27,206,145,54,191,78,125,252,108,62,55
#> 13                 176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13
#> 14         191,91,194,96,204,7,129,209,139,68,88,94,109,234,200,188,72,116,73,178,209,167,105,243,62,155,193
#> 15                                           177,29,162,79,90,250,137,113,242,115,49,253,140,196,233,174,104
#> 16                                        104,37,50,49,104,89,213,51,220,101,39,87,94,109,48,168,235,187,225
#> 17                                              243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11
#> 18                                            51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168
#> 19                                      60,209,185,249,68,224,124,78,101,194,26,107,168,75,53,1,27,55,29,175
#> 20                                     49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48
#> 21                              193,24,159,106,198,206,247,55,221,106,131,198,34,105,169,231,88,27,238,51,14
#> 22                               109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224
#> 23                                       161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49
```
