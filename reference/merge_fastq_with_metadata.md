# Merge FASTQ data with metadata

Merge a dataframe of sequence and quality data (as produced by
[`read_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_fastq.md)
from an unmodified FASTQ file) with a dataframe of metadata,
reverse-complementing sequences if required such that all reads are now
in the forward direction.
[`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
is the equivalent function for working with FASTQs that contain DNA
modification information.  
  
FASTQ dataframe must contain columns of `"read"` (unique read ID),
`"sequence"` (DNA sequence), and `"quality"` (FASTQ quality score).
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
quality scores reversed such that all reads are in the forward
direction, ideal for consistent analysis or visualisation. The output
columns are `"forward_sequence"` and `"forward_quality"`. Calls
[`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md)
and
[`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md)
to implement the reversing - see documentation for these functions for
more details.

## Usage

``` r
merge_fastq_with_metadata(
  fastq_data,
  metadata,
  reverse_complement_mode = "DNA"
)
```

## Arguments

- fastq_data:

  `dataframe`. A dataframe contaning sequence and quality data, as
  produced by
  [`read_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_fastq.md).  
    
  Must contain a read id column (must be called `"read"`), a sequence
  column (`"sequence"`), and a quality column (`"quality"`). Additional
  columns are fine and will simply be included unaltered in the merged
  dataframe.

- metadata:

  `dataframe`. A dataframe containing metadata for each read in
  `fastq_data`.  
    
  Must contain a `"read"` column identical to the column of the same
  name in `fastq_data`, containing unique read IDs (this is used to
  merge the dataframes). Must also contain a `"direction"` column of
  `"forward"` and `"reverse"` (e.g.
  `c("forward", "forward", "reverse")`) indicating the direction of each
  read.  
    
  **Important:** Reverse reads will have their sequence and quality
  scores reversed such that every output read is now forward. These will
  be stored in columns called `"forward_sequence"` and
  `"forward_quality"`.  
    
  See
  [`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md)
  and
  [`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md)
  documentation for details of how the reversing is implemented.

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
dataframes, as well as forward versions of sequences and qualities.

## Examples

``` r
## Locate files
fastq_file <- system.file("extdata",
                          "example_many_sequences_raw.fastq",
                          package = "ggDNAvis")
metadata_file <- system.file("extdata",
                             "example_many_sequences_metadata.csv",
                             package = "ggDNAvis")

## Read files
fastq_data <- read_fastq(fastq_file)
metadata   <- read.csv(metadata_file)

## Merge data (including reversing if needed)
merge_fastq_with_metadata(fastq_data, metadata)
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
```
