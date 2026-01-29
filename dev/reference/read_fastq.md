# Read sequence and quality information from FASTQ

This function simply reads a FASTQ file into a dataframe containing
columns for read ID, sequence, and quality scores. Optionally also
contains a column of sequence lengths.  
  
See
[`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md)
for an explanation of quality.  
  
Resulting dataframe can be written back to FASTQ via
[`write_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_fastq.md).
To read/write a modified FASTQ containing modification information
(SAM/BAM MM and ML tags) in the header lines, use
[`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md)
and
[`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md).

## Usage

``` r
read_fastq(filename = file.choose(), calculate_length = TRUE, strip_at = TRUE)
```

## Arguments

- filename:

  `character`. The file to be read. Defaults to
  [`file.choose()`](https://rdrr.io/r/base/file.choose.html) to select a
  file interactively.

- calculate_length:

  `logical`. Whether or not `sequence_length` column should be
  calculated and included.

- strip_at:

  `logical`. Boolean value for whether "`@`" characters at the start of
  read IDs should automatically be stripped if they are present.  
    
  These "`@`"s tend to be introduced by writing BAM to FASTQ via
  `samtools fastq` and can cause read IDs to not match between FASTQ
  data and metadata, causing metadata merging to fail.

## Value

`dataframe`. A dataframe with `read`, `sequence`, `quality`, and
optionally `sequence_length` columns.

## Examples

``` r
## Locate file
fastq_file <- system.file("extdata",
                          "example_many_sequences_raw.fastq",
                          package = "ggDNAvis")

## View file
for (i in 1:16) {
    cat(readLines(fastq_file)[i], "\n")
}
#> F1-1a 
#> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
#> + 
#> )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90 
#> F1-1b 
#> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
#> + 
#> 60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139 
#> F1-1c 
#> TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC 
#> + 
#> @9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F; 
#> F1-1d 
#> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
#> + 
#> :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0 

## Read file to dataframe
read_fastq(fastq_file, calculate_length = FALSE)
#>     read
#> 1  F1-1a
#> 2  F1-1b
#> 3  F1-1c
#> 4  F1-1d
#> 5  F1-1e
#> 6  F1-2a
#> 7  F1-2b
#> 8  F1-3a
#> 9  F1-3b
#> 10 F1-3c
#> 11 F2-1a
#> 12 F2-2a
#> 13 F2-2b
#> 14 F2-2c
#> 15 F3-1a
#> 16 F3-1b
#> 17 F3-2a
#> 18 F3-2b
#> 19 F3-2c
#> 20 F3-3a
#> 21 F3-4a
#> 22 F3-4b
#> 23 F3-4c
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
read_fastq(fastq_file, calculate_length = TRUE)
#>     read
#> 1  F1-1a
#> 2  F1-1b
#> 3  F1-1c
#> 4  F1-1d
#> 5  F1-1e
#> 6  F1-2a
#> 7  F1-2b
#> 8  F1-3a
#> 9  F1-3b
#> 10 F1-3c
#> 11 F2-1a
#> 12 F2-2a
#> 13 F2-2b
#> 14 F2-2c
#> 15 F3-1a
#> 16 F3-1b
#> 17 F3-2a
#> 18 F3-2b
#> 19 F3-2c
#> 20 F3-3a
#> 21 F3-4a
#> 22 F3-4b
#> 23 F3-4c
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
```
