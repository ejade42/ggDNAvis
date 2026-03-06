# Example multiple sequences data

A collection of made-up sequences in the style of long reads over a
repeat region (e.g. *NOTCH2NLC*), with meta-data describing the
participant each read is from and the family each participant is from.
Can be used in
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md),
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md),
and helper functions to visualise these sequences.  
  
Generation code is available at `data-raw/example_many_sequences.R`

## Usage

``` r
example_many_sequences
```

## Format

### `example_many_sequences`

A dataframe with 23 rows and 10 columns:

- family:

  Participant family

- individual:

  Participant ID

- read:

  Unique read ID

- sequence:

  DNA sequence of the read

- sequence_length:

  Length (nucleotides) of the read

- quality:

  FASTQ quality scores for the read. Each character represents a score
  from 0 to 40 - see
  [`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md).  
    
  These values are made up via
  `pmin(pmax(round(rnorm(n, mean = 20, sd = 10)), 0), 40)` i.e. sampled
  from a normal distribution with mean 20 and standard deviation 10,
  then rounded to integers between 0 and 40 (inclusive) - see
  `example_many_sequences.R`

- methylation_locations:

  Indices along the read (starting at 1) at which methylation
  probability was assessed i.e. CpG sites. Stored as a single character
  value per read, condensed from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).

- methylation_probabilities:

  Probability of methylation (8-bit integer i.e. 0-255) for each
  assessed base. Stored as a single character value per read, condensed
  from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).  
    
  These values are made up via `round(runif(n, min = 0, max = 255))` -
  see `example_many_sequences.R`

- hydroxymethylation_locations:

  Indices along the read (starting at 1) at which hydroxymethylation
  probability was assessed i.e. CpG sites. Stored as a single character
  value per read, condensed from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).

- hydroxymethylation_probabilities:

  Probability of hydroxymethylation (8-bit integer i.e. 0-255) for each
  assessed base. Stored as a single character value per read, condensed
  from a numeric vector via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md).  
    
  These values are made up via
  `round(runif(n, min = 0, max = 255 - this_base_methylation_probability))`
  such that the summed methylation and hydroxymethylation probability
  never exceeds 255 (100%) - see `example_many_sequences.R`

## Examples

``` r
example_many_sequences
#>      family individual  read
#> 1  Family 1       F1-1 F1-1a
#> 2  Family 1       F1-1 F1-1b
#> 3  Family 1       F1-1 F1-1c
#> 4  Family 1       F1-1 F1-1d
#> 5  Family 1       F1-1 F1-1e
#> 6  Family 1       F1-2 F1-2a
#> 7  Family 1       F1-2 F1-2b
#> 8  Family 1       F1-3 F1-3a
#> 9  Family 1       F1-3 F1-3b
#> 10 Family 1       F1-3 F1-3c
#> 11 Family 2       F2-1 F2-1a
#> 12 Family 2       F2-2 F2-2a
#> 13 Family 2       F2-2 F2-2b
#> 14 Family 2       F2-2 F2-2c
#> 15 Family 3       F3-1 F3-1a
#> 16 Family 3       F3-1 F3-1b
#> 17 Family 3       F3-2 F3-2a
#> 18 Family 3       F3-2 F3-2b
#> 19 Family 3       F3-2 F3-2c
#> 20 Family 3       F3-3 F3-3a
#> 21 Family 3       F3-4 F3-4a
#> 22 Family 3       F3-4 F3-4b
#> 23 Family 3       F3-4 F3-4c
#>                                                                                                  sequence
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
#>                                                               methylation_locations
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
#>                                                                                    methylation_probabilities
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
#>                                                        hydroxymethylation_locations
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
#>                                                       hydroxymethylation_probabilities
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
```
