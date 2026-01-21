# Write sequence and quality information to FASTQ

This function simply writes a FASTQ file from a dataframe containing
columns for read ID, sequence, and quality scores.  
  
See
[`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md)
for an explanation of quality.  
  
Said dataframe can be produced from FASTQ via
[`read_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_fastq.md).
To read/write a modified FASTQ containing modification information
(SAM/BAM MM and ML tags) in the header lines, use
[`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md)
and
[`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md).

## Usage

``` r
write_fastq(
  dataframe,
  filename = NA,
  ...,
  read_id_colname = "read",
  sequence_colname = "sequence",
  quality_colname = "quality",
  return = FALSE
)
```

## Arguments

- dataframe:

  Dataframe containing sequence information to write back to FASTQ. Must
  have columns for unique read ID and DNA sequence. Should also have a
  column for quality, unless wanting to fill in qualities with `"B"`.

- filename:

  `character`. File to write the FASTQ to. Recommended to end with
  `.fastq` (warns but works if not). If set to `NA` (default), no file
  will be output, which may be useful for testing/debugging.

- ...:

  Used to recognise aliases e.g. American spellings or common
  misspellings - see
  [aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).
  If any American spellings do not work, please make a bug report at
  <https://github.com/ejade42/ggDNAvis/issues>.

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

- return:

  `logical`. Boolean specifying whether this function should return the
  FASTQ (as a character vector of each line in the FASTQ), otherwise it
  will return `invisible(NULL)`. Defaults to `FALSE`.

## Value

`character vector`. The resulting FASTQ file as a character vector of
its constituent lines (or `invisible(NULL)` if `return` is `FALSE`).
This is probably mostly useful for debugging, as setting `filename`
within this function directly writes to FASTQ via
[`writeLines()`](https://rdrr.io/r/base/writeLines.html). Therefore,
defaults to returning `invisible(NULL)`.

## Examples

``` r
## Write to FASTQ (using filename = NA, return = FALSE
## to view as char vector rather than writing to file)
write_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = "quality",
    return = TRUE
)
#>  [1] "F1-1a"                                                                                                 
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#>  [3] "+"                                                                                                     
#>  [4] ")8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90"
#>  [5] "F1-1b"                                                                                                 
#>  [6] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#>  [7] "+"                                                                                                     
#>  [8] "60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12\">/2C;4:9F8:816E,6C3*,1-2139"                                      
#>  [9] "F1-1c"                                                                                                 
#> [10] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [11] "+"                                                                                                     
#> [12] ";F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@"               
#> [13] "F1-1d"                                                                                                 
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#> [15] "+"                                                                                                     
#> [16] ":<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0"                     
#> [17] "F1-1e"                                                                                                 
#> [18] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [19] "+"                                                                                                     
#> [20] ";4*2E3-48?@6A-!00!;-3%:H,4H>H530C(85I/&75-62.:2#!/D=A?8&7E!-@:=::5,)51,97D*04'2.!20@/;6)947<6"         
#> [21] "F1-2a"                                                                                                 
#> [22] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       
#> [23] "+"                                                                                                     
#> [24] "E6(<)\"-./EE<(5:47,(C818I9CC1=.&)4G6-7<(*\"(,2C>8/5:0@@).A$97I!-<"                                     
#> [25] "F1-2b"                                                                                                 
#> [26] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#> [27] "+"                                                                                                     
#> [28] "F='I#*5I:<F?)<4G3&:95*-5?1,!:9BD4B5.-27577<2E9)2:189B.5/*#7;;'**.7;-!"                                 
#> [29] "F1-3a"                                                                                                 
#> [30] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [31] "+"                                                                                                     
#> [32] "?;.*26<C-8B,3#8/,-9!1++:94:/!A317=9>502=-+8;$=53@D*?/6:6&0D7-.@8,5;F,1?0D?$9'&665B8.604"               
#> [33] "F1-3b"                                                                                                 
#> [34] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#> [35] "+"                                                                                                     
#> [36] "*46.5//3:37?24:(:0*#.))E)?:,/172=2!4\">.*/;\"8+5<;D6.I2=>:C3)108,<)GC161)!55E!.>86/"                   
#> [37] "F1-3c"                                                                                                 
#> [38] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
#> [39] "+"                                                                                                     
#> [40] "736/A@B121C269<2I,'5G66>46A6-9*&4*;4-E4C429?I+3@83(234E0%:43;!/3;2+956A0)(+'5G4=*3;1"                  
#> [41] "F2-1a"                                                                                                 
#> [42] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [43] "+"                                                                                                     
#> [44] "=</-I354/,*>+<CA40*537/;<@I7/4%6192'5'>#4:&C,072+90:0+4;74\"D5,38&<7A?00+1>G>#=?;,@<<1=64D=!1&"        
#> [45] "F2-2a"                                                                                                 
#> [46] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [47] "+"                                                                                                     
#> [48] ";1>:5417*<1.2H#260197.;7<(-3?0+=:)ID'I$6*128*!4.7-=5;+384F!=5>4!93+.6I7+H1-).H><68;7"                  
#> [49] "F2-2b"                                                                                                 
#> [50] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [51] "+"                                                                                                     
#> [52] "7?38,EC#3::=1)8&;<\">3.9BE)1661!2)5-4.11B<3)?')-+,B4.<7)/:IE=5$.3:66G9216-C20,>(0848(1$-"              
#> [53] "F2-2c"                                                                                                 
#> [54] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
#> [55] "+"                                                                                                     
#> [56] "@86,/+6=8/;9=1)48E494IB3456/6.*=</B32+5469>8?@!1;*+81$>-99D7<@1$6B'?462?CE+=1+95=G?.6CA%>2"            
#> [57] "F3-1a"                                                                                                 
#> [58] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [59] "+"                                                                                                     
#> [60] "/*2<C643?*8?@9)-.'5A!=3-=;6,.%H3-!10'I>&@?;96;+/+36;:C;B@/=:6,;61>?>!,>.97@.48B38(;7;1F464=-7;)7"      
#> [61] "F3-1b"                                                                                                 
#> [62] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [63] "+"                                                                                                     
#> [64] "/C<$>7/1(9%4:6>6I,D%*,&D?C/6@@;7)83.E.7:@9I906<!4536!850!164/8,<=?=15A;8B/5B364A66.1%9=(9876E8C:"      
#> [65] "F3-2a"                                                                                                 
#> [66] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"         
#> [67] "+"                                                                                                     
#> [68] ":0I4099<,4E01;/@96%2I2<,%<C&=81F+4<*@4A5.('4!%I3CE657<=!5;37>4D:%3;7'\"4<.9;?;7%0>:,84B512,B7/"        
#> [69] "F3-2b"                                                                                                 
#> [70] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"            
#> [71] "+"                                                                                                     
#> [72] "9>124!752+@06I/.72097*';-+A60=B?+/8'15477>4-435D;G@G'./21:(0/1/A=7'I>A\"3=9;;12,@\"2=3D=,458"          
#> [73] "F3-2c"                                                                                                 
#> [74] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"               
#> [75] "+"                                                                                                     
#> [76] "0/2>@/6+-/(!=9-?G!AA70*,/!/?-E46:,-1G94*491,,38?(-!6<8A;/C9;,3)4C06=%',86A)1!E@/24G59<<"               
#> [77] "F3-3a"                                                                                                 
#> [78] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [79] "+"                                                                                                     
#> [80] "$<,5\"7+!$';8<0794*@FI>34224!57+#1!F<+53$,?)-.A3;=1*71C02<.5:1)82!86$03/;%+1C3+D3;@9B-E#+/70;9<D'"     
#> [81] "F3-4a"                                                                                                 
#> [82] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [83] "+"                                                                                                     
#> [84] "?2-#-2\"1:(5(4>!I)>I,.?-+EG3IH4-.C:;570@2I;?D5#/;A7=>?<3?080::459*?8:3\"<2;I)C1400)6:3%19./);.I?35"    
#> [85] "F3-4b"                                                                                                 
#> [86] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     
#> [87] "+"                                                                                                     
#> [88] ".85$#;!1F$8E:B+;7CI6@11/'65<3,4G:8@GF1413:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4"                     
#> [89] "F3-4c"                                                                                                 
#> [90] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            
#> [91] "+"                                                                                                     
#> [92] "5@<733';9+3BB)=69,3!.2B*86'8E>@3?!(36:<002/4>:1.43A!+;<.3G*G8?0*991,B(C/\"I9*1-86)8.;;5-0+="           

## quality_colname = NA fills in quality with "B"
write_fastq(
    example_many_sequences,
    filename = NA,
    read_id_colname = "read",
    sequence_colname = "sequence",
    quality_colname = NA,
    return = TRUE
)
#>  [1] "F1-1a"                                                                                                 
#>  [2] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"
#>  [3] "+"                                                                                                     
#>  [4] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
#>  [5] "F1-1b"                                                                                                 
#>  [6] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                                       
#>  [7] "+"                                                                                                     
#>  [8] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                       
#>  [9] "F1-1c"                                                                                                 
#> [10] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [11] "+"                                                                                                     
#> [12] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"               
#> [13] "F1-1d"                                                                                                 
#> [14] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"                     
#> [15] "+"                                                                                                     
#> [16] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                     
#> [17] "F1-1e"                                                                                                 
#> [18] "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [19] "+"                                                                                                     
#> [20] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"         
#> [21] "F1-2a"                                                                                                 
#> [22] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                       
#> [23] "+"                                                                                                     
#> [24] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                       
#> [25] "F1-2b"                                                                                                 
#> [26] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"                                 
#> [27] "+"                                                                                                     
#> [28] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                                 
#> [29] "F1-3a"                                                                                                 
#> [30] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [31] "+"                                                                                                     
#> [32] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"               
#> [33] "F1-3b"                                                                                                 
#> [34] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA"                     
#> [35] "+"                                                                                                     
#> [36] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                     
#> [37] "F1-3c"                                                                                                 
#> [38] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA"                  
#> [39] "+"                                                                                                     
#> [40] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                  
#> [41] "F2-1a"                                                                                                 
#> [42] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"         
#> [43] "+"                                                                                                     
#> [44] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"         
#> [45] "F2-2a"                                                                                                 
#> [46] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"                  
#> [47] "+"                                                                                                     
#> [48] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                  
#> [49] "F2-2b"                                                                                                 
#> [50] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"               
#> [51] "+"                                                                                                     
#> [52] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"               
#> [53] "F2-2c"                                                                                                 
#> [54] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA"            
#> [55] "+"                                                                                                     
#> [56] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"            
#> [57] "F3-1a"                                                                                                 
#> [58] "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [59] "+"                                                                                                     
#> [60] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"      
#> [61] "F3-1b"                                                                                                 
#> [62] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [63] "+"                                                                                                     
#> [64] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"      
#> [65] "F3-2a"                                                                                                 
#> [66] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"         
#> [67] "+"                                                                                                     
#> [68] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"         
#> [69] "F3-2b"                                                                                                 
#> [70] "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA"            
#> [71] "+"                                                                                                     
#> [72] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"            
#> [73] "F3-2c"                                                                                                 
#> [74] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA"               
#> [75] "+"                                                                                                     
#> [76] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"               
#> [77] "F3-3a"                                                                                                 
#> [78] "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [79] "+"                                                                                                     
#> [80] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"      
#> [81] "F3-4a"                                                                                                 
#> [82] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"      
#> [83] "+"                                                                                                     
#> [84] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"      
#> [85] "F3-4b"                                                                                                 
#> [86] "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"                     
#> [87] "+"                                                                                                     
#> [88] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"                     
#> [89] "F3-4c"                                                                                                 
#> [90] "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"            
#> [91] "+"                                                                                                     
#> [92] "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"            
```
