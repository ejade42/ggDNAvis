# Read modification information from modified FASTQ

This function reads a modified FASTQ file (e.g. created by
`samtools fastq -T MM,ML` from a BAM basecalled with a
modification-capable model in Dorado or Guppy) to a dataframe.  
  
By default, the dataframe contains columns for unique read id (`read`),
sequence (`sequence`), sequence length (`sequence_length`), quality
(`quality`), comma-separated (via
[`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
modification types present in each read (`modification_types`), and for
each modification type, a column of comma-separated modification
locations (`<type>_locations`) and a column of comma-separated
modification probabilities (`<type>_probabilities`).  
  
Modification locations are the indices along the read at which
modification was assessed e.g. a 3 indicates that the third base in the
read was assessed for modifications of the given type. Modification
probabilities are the probability that the given modification is
present, given as an integer from 0-255 where integer \\p\\ represents
the probability space from \\\frac{p}{256}\\ to \\\frac{p+1}{256}\\.  
  
To extract the numbers from these columns as numeric vectors to analyse,
use
[`string_to_vector()`](https://ejade42.github.io/ggDNAvis/reference/string_to_vector.md)
e.g.
`` list_of_locations <- lapply(test_01$`C+h?_locations`, string_to_vector) ``.
Be aware that the SAM modification types often contain special
characters, meaning the colname may need to be enclosed in backticks as
in this example. Alternatively, use
[`extract_methylation_from_dataframe()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_methylation.md)
to create a list of locations, probabilities, and lengths ready for
visualisation in
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md).
This works with any modification type extracted in this function, just
provide the relevant colname when calling
[`extract_methylation_from_dataframe()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_methylation.md).  
  
Optionally (by specifying `debug = TRUE`), the dataframe will also
contain columns of the raw MM and ML tags (`<MM/ML>_raw`) and of the
same tags with the initial label trimmed out (`<MM/ML>_tags`). This is
not recommended in most situations but may help with debugging
unexpected issues as it contains the raw data exactly from the FASTQ.  
  
Dataframes produced by this function can be written back to modified
FASTQ via
[`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md).

## Usage

``` r
read_modified_fastq(filename = file.choose(), strip_at = TRUE, debug = FALSE)
```

## Arguments

- filename:

  `character`. The file to be read. Defaults to
  [`file.choose()`](https://rdrr.io/r/base/file.choose.html) to select a
  file interactively.

- strip_at:

  `logical`. Boolean value for whether "`@`" characters at the start of
  read IDs should automatically be stripped if they are present, via
  [`strip_leading_at()`](https://ejade42.github.io/ggDNAvis/reference/strip_leading_at.md).  
    
  These "`@`"s tend to be introduced by writing BAM to FASTQ via
  `samtools fastq` and can cause read IDs to not match between FASTQ
  data and metadata, causing metadata merging to fail.

- debug:

  `logical`. Boolean value for whether the extra `<MM/ML>_tags` and
  `<MM/ML>_raw` columns should be added to the dataframe. Defaults to
  `FALSE` as I can't imagine this is often helpful, but the option is
  provided to assist with debugging.

## Value

`dataframe`. Dataframe of modification information, as described
above.  
  
Sequences can be visualised with
[`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
and modification information can be visualised with
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
(despite the name, any type of information can be visualised as long as
it has locations and probabilities columns).  
  
Can be written back to FASTQ via
[`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md).

## Examples

``` r
## Locate file
modified_fastq_file <- system.file("extdata",
                                   "example_many_sequences_raw_modified.fastq",
                                   package = "ggDNAvis")

## View file
for (i in 1:16) {
    cat(readLines(modified_fastq_file)[i], "\n")
}
#> F1-1a    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34,29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41 
#> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
#> + 
#> )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90 
#> F1-1b    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2,10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253 
#> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
#> + 
#> 60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139 
#> F1-1c    MM:Z:C+h?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1; ML:B:C,37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40,45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206 
#> TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC 
#> + 
#> @9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F; 
#> F1-1d    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55,216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82 
#> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
#> + 
#> :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0 

## Read file to dataframe
read_modified_fastq(modified_fastq_file, debug = FALSE)
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
read_modified_fastq(modified_fastq_file, debug = TRUE)
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
#>                                                                                                                       MM_tags
#> 1                      C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 2                                                  C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 3                                  C+h?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;
#> 4                                  C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 5                                  C+h?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1;C+m?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1;
#> 6                                                          C+h?,1,1,7,1,7,1,1,1,1,1,1,1,1,1;C+m?,1,1,7,1,7,1,1,1,1,1,1,1,1,1;
#> 7                                                  C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 8                                  C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 9                          C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 10                                     C+h?,1,1,5,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;
#> 11 C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 12             C+h?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
#> 13         C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 14     C+h?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
#> 15                                             C+h?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,1;C+m?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,1;
#> 16                                     C+h?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1;C+m?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1;
#> 17                                         C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 18                                             C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 19                                 C+h?,1,1,1,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1;C+m?,1,1,1,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1;
#> 20                                     C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 21                             C+h?,1,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1,1;
#> 22                                 C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 23                                     C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#>                                                                                                                                                                                          ML_tags
#> 1                                             26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34,29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41
#> 2                                                                                         10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2,10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253
#> 3                                                           37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40,45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206
#> 4                                                                    33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55,216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82
#> 5                                                                  54,7,53,64,24,29,30,23,35,23,34,55,61,23,40,63,31,64,18,57,79,7,77,130,27,34,34,230,42,229,41,79,99,229,50,139,36,120,236,170
#> 6                                                                                                          12,23,52,9,63,29,33,56,30,41,52,63,9,49,242,26,182,10,111,33,40,83,34,52,71,144,9,189
#> 7                                                                                       27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64,31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127
#> 8                                                          55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5,81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250
#> 9                                               62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20,147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193
#> 10                                                              20,111,79,1,238,1,142,35,80,40,21,126,47,112,21,71,103,43,80,189,79,161,215,6,244,19,153,88,122,77,30,143,108,194,88,109,181,149
#> 11 68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49,163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179
#> 12                       49,82,145,1,40,133,14,114,89,5,129,88,26,66,42,136,25,17,74,44,6,104,125,18,93,55,62,108,252,125,78,191,54,145,206,27,145,203,126,130,86,205,127,34,85,66,8,108,217,122
#> 13                        17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4,176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13
#> 14          38,24,184,5,98,72,32,22,83,39,135,53,51,9,54,55,45,102,95,23,3,198,19,121,22,123,3,193,155,62,243,105,167,209,178,73,116,72,188,200,234,109,94,88,68,139,209,129,7,204,96,194,91,191
#> 15                                                                         103,74,17,32,114,0,93,133,6,77,116,2,51,112,11,157,59,104,174,233,196,140,253,49,115,242,113,137,250,90,79,162,29,177
#> 16                                                                  22,63,13,16,88,54,55,26,86,133,7,170,15,68,29,41,30,89,61,225,187,235,168,48,109,94,87,39,101,220,51,213,89,104,49,50,37,104
#> 17                                                                           11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225,243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11
#> 18                                                                              9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73,51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168
#> 19                                                            17,24,0,47,75,133,76,9,112,90,19,75,156,35,30,136,5,16,30,191,175,29,55,27,1,53,75,168,107,26,194,101,78,124,224,68,249,185,209,60
#> 20                                                               24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161,49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48
#> 21                                              225,21,6,207,111,10,11,116,113,24,108,32,33,162,6,20,35,14,73,44,36,14,51,238,27,88,231,169,105,34,198,131,106,221,55,247,206,198,106,159,24,193
#> 22                                                        29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31,109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224
#> 23                                                                  52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81,161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49
#>                                                                                                                             MM_raw
#> 1                      MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 2                                                  MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 3                                  MM:Z:C+h?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;
#> 4                                  MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 5                                  MM:Z:C+h?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1;C+m?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1;
#> 6                                                          MM:Z:C+h?,1,1,7,1,7,1,1,1,1,1,1,1,1,1;C+m?,1,1,7,1,7,1,1,1,1,1,1,1,1,1;
#> 7                                                  MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 8                                  MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 9                          MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 10                                     MM:Z:C+h?,1,1,5,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;
#> 11 MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 12             MM:Z:C+h?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
#> 13         MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 14     MM:Z:C+h?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1;
#> 15                                             MM:Z:C+h?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,1;C+m?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,5,1,1;
#> 16                                     MM:Z:C+h?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1;C+m?,1,1,5,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1;
#> 17                                         MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 18                                             MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 19                                 MM:Z:C+h?,1,1,1,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1;C+m?,1,1,1,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1;
#> 20                                     MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 21                             MM:Z:C+h?,1,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,5,1,5,1,5,1,5,1,1,1,1,1,1,1,1,1,1;
#> 22                                 MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#> 23                                     MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
#>                                                                                                                                                                                                  ML_raw
#> 1                                             ML:B:C,26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34,29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41
#> 2                                                                                         ML:B:C,10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2,10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253
#> 3                                                           ML:B:C,37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40,45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206
#> 4                                                                    ML:B:C,33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55,216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82
#> 5                                                                  ML:B:C,54,7,53,64,24,29,30,23,35,23,34,55,61,23,40,63,31,64,18,57,79,7,77,130,27,34,34,230,42,229,41,79,99,229,50,139,36,120,236,170
#> 6                                                                                                          ML:B:C,12,23,52,9,63,29,33,56,30,41,52,63,9,49,242,26,182,10,111,33,40,83,34,52,71,144,9,189
#> 7                                                                                       ML:B:C,27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64,31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127
#> 8                                                          ML:B:C,55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5,81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250
#> 9                                               ML:B:C,62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20,147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193
#> 10                                                              ML:B:C,20,111,79,1,238,1,142,35,80,40,21,126,47,112,21,71,103,43,80,189,79,161,215,6,244,19,153,88,122,77,30,143,108,194,88,109,181,149
#> 11 ML:B:C,68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49,163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179
#> 12                       ML:B:C,49,82,145,1,40,133,14,114,89,5,129,88,26,66,42,136,25,17,74,44,6,104,125,18,93,55,62,108,252,125,78,191,54,145,206,27,145,203,126,130,86,205,127,34,85,66,8,108,217,122
#> 13                        ML:B:C,17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4,176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13
#> 14          ML:B:C,38,24,184,5,98,72,32,22,83,39,135,53,51,9,54,55,45,102,95,23,3,198,19,121,22,123,3,193,155,62,243,105,167,209,178,73,116,72,188,200,234,109,94,88,68,139,209,129,7,204,96,194,91,191
#> 15                                                                         ML:B:C,103,74,17,32,114,0,93,133,6,77,116,2,51,112,11,157,59,104,174,233,196,140,253,49,115,242,113,137,250,90,79,162,29,177
#> 16                                                                  ML:B:C,22,63,13,16,88,54,55,26,86,133,7,170,15,68,29,41,30,89,61,225,187,235,168,48,109,94,87,39,101,220,51,213,89,104,49,50,37,104
#> 17                                                                           ML:B:C,11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225,243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11
#> 18                                                                              ML:B:C,9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73,51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168
#> 19                                                            ML:B:C,17,24,0,47,75,133,76,9,112,90,19,75,156,35,30,136,5,16,30,191,175,29,55,27,1,53,75,168,107,26,194,101,78,124,224,68,249,185,209,60
#> 20                                                               ML:B:C,24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161,49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48
#> 21                                              ML:B:C,225,21,6,207,111,10,11,116,113,24,108,32,33,162,6,20,35,14,73,44,36,14,51,238,27,88,231,169,105,34,198,131,106,221,55,247,206,198,106,159,24,193
#> 22                                                        ML:B:C,29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31,109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224
#> 23                                                                  ML:B:C,52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81,161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49
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
```
