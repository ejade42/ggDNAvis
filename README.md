
# ggDNAvis

ggDNAvis is an R package that uses ggplot2 to visualise genetic data of
three main types:

1)  a single DNA/RNA sequence split across multiple lines,

2)  multiple DNA/RNA sequences, each occupying a whole line, or

3)  base modifications such as DNA methylation called by modified-bases
    models in Dorado or Guppy.

This is accomplished through main functions
`visualise_single_sequence()`, `visualise_many_sequences()`, and
`visualise_methylation()` respectively. Each of these has helper
sequences for streamlined data processing, as detailed later in the
section for each visualisation type.

Additionally, ggDNAvis contains a built-in example dataset
(`example_many_sequences`) and a set of colour palettes for DNA
visualisation (`sequence_colour_palettes`).

Note that all spellings are the British English version (e.g. “colour”,
“visualise”). Aliases have not been defined, meaning American spellings
will not work.

All packages used in code in this manual are loaded in the following
chunk:

``` r
library(ggDNAvis)

## For table rendering in this document (no logic/data processing)
library(knitr)
library(kableExtra)
```

# Loading data

## Introduction to `example_many_sequences`

ggDNAvis comes with example dataset `example_many_sequences`. In this
data, each row/observation represents one read. Reads are associated
with metadata such as the participant and family to which they belong,
and with sequence data such as the DNA sequence, FASTQ quality scores,
and modification information retrieved from the MM and ML tags in a
SAM/BAM file.

``` r
## View the example_many_sequences data
table <- kable(as.data.frame(example_many_sequences), format = "html")

## Code to make the table scrollable horizontally and vertically
scrollable_table <- paste0(
  '<div style="overflow: auto; max-height: 400px; max-width: 100%;">',
  table,
  '</div>'
)
asis_output(scrollable_table)
```

<div style="overflow: auto; max-height: 400px; max-width: 100%;">

<table>

<thead>

<tr>

<th style="text-align:left;">

family
</th>

<th style="text-align:left;">

individual
</th>

<th style="text-align:left;">

read
</th>

<th style="text-align:left;">

sequence
</th>

<th style="text-align:right;">

sequence_length
</th>

<th style="text-align:left;">

quality
</th>

<th style="text-align:left;">

methylation_locations
</th>

<th style="text-align:left;">

methylation_probabilities
</th>

<th style="text-align:left;">

hydroxymethylation_locations
</th>

<th style="text-align:left;">

hydroxymethylation_probabilities
</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-1
</td>

<td style="text-align:left;">

F1-1a
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

102
</td>

<td style="text-align:left;">

)8@!9:/0/,0+-6?40,-I601:.’;+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)\<I5.5G*CB8501;I3’.8233’3\>\<:13)48F?09\*\>?I90
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
</td>

<td style="text-align:left;">

29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99
</td>

<td style="text-align:left;">

26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-1
</td>

<td style="text-align:left;">

F1-1b
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

63
</td>

<td style="text-align:left;">

60-7,7943/*=5=)7\<53-I=G6/&/7?8)\<\$12”\>/2C;4:9F8:816E,6C3*,1-2139
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
</td>

<td style="text-align:left;">

10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60
</td>

<td style="text-align:left;">

10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-1
</td>

<td style="text-align:left;">

F1-1c
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

87
</td>

<td style="text-align:left;">

;F42DF52#C-*I75!4?9\>IA0\<30!-:I:;+7!:\<<7%3C8=G@5>*91D%193/2;\>\<IA8.I\<.722,68*!25;69*\<\<8C9889@
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
</td>

<td style="text-align:left;">

206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
</td>

<td style="text-align:left;">

40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-1
</td>

<td style="text-align:left;">

F1-1d
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

81
</td>

<td style="text-align:left;">

:\<\*1D)89?27#8.3)9\<2G\<\>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8\>0
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
</td>

<td style="text-align:left;">

216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78
</td>

<td style="text-align:left;">

33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-1
</td>

<td style="text-align:left;">

F1-1e
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

93
</td>

<td style="text-align:left;">

;<4*2E3-48?@6A>-!00!;-3%:H,4H\>H530C(85I/&75-62.:2#!/D=A?8&7E!-@:=::5,)51,97D\*04’2.!20@/;6)947\<6
</td>

<td style="text-align:left;">

3,6,9,12,15,18,27,30,33,42,45,48,57,60,63,72,75,78,87,90
</td>

<td style="text-align:left;">

170,236,120,36,139,50,229,99,79,41,229,42,230,34,34,27,130,77,7,79
</td>

<td style="text-align:left;">

3,6,9,12,15,18,27,30,33,42,45,48,57,60,63,72,75,78,87,90
</td>

<td style="text-align:left;">

57,18,64,31,63,40,23,61,55,34,23,35,23,30,29,24,64,53,7,54
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-2
</td>

<td style="text-align:left;">

F1-2a
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

63
</td>

<td style="text-align:left;">

E6(\<)“-./EE\<(5:47,(C818I9CC1=.&)4G6-7\<(*“(,2C\>8/5:0@@).A$97I!-&lt; </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,42,45,57,60 </td>
   <td style="text-align:left;"> 189,9,144,71,52,34,83,40,33,111,10,182,26,242 </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,42,45,57,60 </td>
   <td style="text-align:left;"> 49,9,63,52,41,30,56,33,29,63,9,52,23,12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Family 1 </td>
   <td style="text-align:left;"> F1-2 </td>
   <td style="text-align:left;"> F1-2b </td>
   <td style="text-align:left;"> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA </td>
   <td style="text-align:right;"> 69 </td>
   <td style="text-align:left;"> F='I#*5I:&lt;F?)&lt;4G3&amp;:95*-5?1,!:9BD4B5.-27577&lt;2E9)2:189B.5/*#7;;'**.7;-! </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66 </td>
   <td style="text-align:left;"> 31,56,233,241,71,31,203,190,234,254,240,124,72,64,128,127 </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,48,51,63,66 </td>
   <td style="text-align:left;"> 27,44,20,13,51,28,41,48,19,1,14,64,52,48,64,64 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Family 1 </td>
   <td style="text-align:left;"> F1-3 </td>
   <td style="text-align:left;"> F1-3a </td>
   <td style="text-align:left;"> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA </td>
   <td style="text-align:right;"> 87 </td>
   <td style="text-align:left;"> ?;.*26&lt;C-8B,3#8/,-9!1++:94:/!A317=9&gt;502=-+8;$=<53@D>*?/6:6&0D7-.@8,5;F,1?0D?\$9’&665B8.604
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
</td>

<td style="text-align:left;">

81,245,162,32,108,233,119,232,152,161,222,128,251,83,123,91,160,189,144,250
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84
</td>

<td style="text-align:left;">

55,10,59,28,62,20,64,21,62,59,29,64,4,56,64,59,60,49,63,5
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-3
</td>

<td style="text-align:left;">

F1-3b
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA
</td>

<td style="text-align:right;">

81
</td>

<td style="text-align:left;">

*46.5//3:37?24:(:0*\#.))E)?:,/172=2!4”\>.\*/;“8+5\<;D6.I2=\>:C3)108,\<)GC161)!55E!.\>86/
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
</td>

<td style="text-align:left;">

147,112,58,21,217,60,252,153,255,96,142,110,147,110,57,22,163,110,19,205,83,193
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,54,57,60,69,72,75,78
</td>

<td style="text-align:left;">

62,63,45,19,32,46,3,61,0,159,42,80,46,84,86,52,8,92,102,4,138,20
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 1
</td>

<td style="text-align:left;">

F1-3
</td>

<td style="text-align:left;">

F1-3c
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

84
</td>

<td style="text-align:left;">

<736/A@B121C269>\<2I,’<5G66%3E46A6-9*&4*;4-E4C429?I+3@83>(234E0%:43;!/3;2+956A0)(+’5G4=\*3;1
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,78,81
</td>

<td style="text-align:left;">

149,181,109,88,194,108,143,30,77,122,88,153,19,244,6,215,161,79,189
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,78,81
</td>

<td style="text-align:left;">

80,43,103,71,21,112,47,126,21,40,80,35,142,1,238,1,79,111,20
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 2
</td>

<td style="text-align:left;">

F2-1
</td>

<td style="text-align:left;">

F2-1a
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

93
</td>

<td style="text-align:left;">

=\</-I354/,\*\>+\<<CA40*537/;%3C@I7>/4%6192’5’\>#4:&C,072+90:0+4;74”D5,38&\<7A?00+1\>G\>#=?;,@\<\<1=64D=!1&
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
</td>

<td style="text-align:left;">

163,253,33,225,207,210,213,187,251,163,168,135,81,196,134,187,78,103,52,251,144,71,47,193,145,238,163,179
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,87,90
</td>

<td style="text-align:left;">

68,1,220,4,42,36,35,57,3,90,56,79,92,19,93,36,130,47,82,1,109,104,58,11,83,10,86,49
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 2
</td>

<td style="text-align:left;">

F2-2
</td>

<td style="text-align:left;">

F2-2a
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA
</td>

<td style="text-align:right;">

84
</td>

<td style="text-align:left;">

;1\>:5417*\<1.2H#260197.;7\<(-3?0+=:)ID’I$6*128*!4.7-=5;+384F!=5&gt;4!93+.6I7+H1-).H&gt;&lt;68;7 </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,78,81 </td>
   <td style="text-align:left;"> 122,217,108,8,66,85,34,127,205,86,130,126,203,145,27,206,145,54,191,78,125,252,108,62,55 </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,78,81 </td>
   <td style="text-align:left;"> 93,18,125,104,6,44,74,17,25,136,42,66,26,88,129,5,89,114,14,133,40,1,145,82,49 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Family 2 </td>
   <td style="text-align:left;"> F2-2 </td>
   <td style="text-align:left;"> F2-2b </td>
   <td style="text-align:left;"> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA </td>
   <td style="text-align:right;"> 87 </td>
   <td style="text-align:left;"> 7?38,EC#3::=1)8&amp;;&lt;"&gt;3.9BE)1661!2)5-4.11B&lt;3)?')-+,B4.&lt;7)/:IE=5$.3:66G9216-C20,\>(0848(1$- </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84 </td>
   <td style="text-align:left;"> 176,250,122,197,146,246,203,136,152,67,71,17,144,67,1,150,133,215,8,153,68,31,26,191,4,13 </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,81,84 </td>
   <td style="text-align:left;"> 17,3,130,28,84,5,50,95,55,112,49,67,7,106,67,0,72,21,209,3,112,60,28,6,188,4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Family 2 </td>
   <td style="text-align:left;"> F2-2 </td>
   <td style="text-align:left;"> F2-2c </td>
   <td style="text-align:left;"> GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA </td>
   <td style="text-align:right;"> 90 </td>
   <td style="text-align:left;"> @86,/+6=8/;9=1)48E494IB3456/6.*=&lt;/B32+5469&gt;8?@!1;*+81$\>-<99D7%3C@1>$6B'?462?CE+=1+95=G?.6CA%&gt;2 </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,84,87 </td>
   <td style="text-align:left;"> 191,91,194,96,204,7,129,209,139,68,88,94,109,234,200,188,72,116,73,178,209,167,105,243,62,155,193 </td>
   <td style="text-align:left;"> 3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,84,87 </td>
   <td style="text-align:left;"> 3,123,22,121,19,198,3,23,95,102,45,55,54,9,51,53,135,39,83,22,32,72,98,5,184,24,38 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Family 3 </td>
   <td style="text-align:left;"> F3-1 </td>
   <td style="text-align:left;"> F3-1a </td>
   <td style="text-align:left;"> GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA </td>
   <td style="text-align:right;"> 96 </td>
   <td style="text-align:left;"> /*2&lt;C643?*8?@9)-.'5A!=3-=;6,.%H3-!10'I&gt;&amp;@?;96;+/+36;:C;B@/=:6,;61&gt;?&gt;!,&gt;.97@.48B38(;7;1F464=-7;)7 </td>
   <td style="text-align:left;"> 3,6,9,18,21,30,33,42,45,54,57,66,69,78,81,90,93 </td>
   <td style="text-align:left;"> 177,29,162,79,90,250,137,113,242,115,49,253,140,196,233,174,104 </td>
   <td style="text-align:left;"> 3,6,9,18,21,30,33,42,45,54,57,66,69,78,81,90,93 </td>
   <td style="text-align:left;"> 59,157,11,112,51,2,116,77,6,133,93,0,114,32,17,74,103 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Family 3 </td>
   <td style="text-align:left;"> F3-1 </td>
   <td style="text-align:left;"> F3-1b </td>
   <td style="text-align:left;"> GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA </td>
   <td style="text-align:right;"> 96 </td>
   <td style="text-align:left;"> /C&lt;$\>7/1(9%4:6\>6I,D%*,&D?C/6@@;7)83.E.7:@9I906&lt;!4536!850!164/8,\<=?=15A;8B/5B364A66.1%9=(9876E8C:
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
</td>

<td style="text-align:left;">

104,37,50,49,104,89,213,51,220,101,39,87,94,109,48,168,235,187,225
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
</td>

<td style="text-align:left;">

61,89,30,41,29,68,15,170,7,133,86,26,55,54,88,16,13,63,22
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 3
</td>

<td style="text-align:left;">

F3-2
</td>

<td style="text-align:left;">

F3-2a
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
</td>

<td style="text-align:right;">

93
</td>

<td style="text-align:left;">

:0I4099\<,<4E01;/@96>%2I2\<,%\<<C&=81F+4%3C*@4A5>.(‘4!%I3CE657\<=!5;37\>4D:%3;7’“4\<.9;?;7%0\>:,84B512,B7/
</td>

<td style="text-align:left;">

3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
</td>

<td style="text-align:left;">

243,50,121,98,95,7,237,105,244,69,132,249,94,79,9,170,235,11
</td>

<td style="text-align:left;">

3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87,90
</td>

<td style="text-align:left;">

11,195,26,74,62,93,1,139,5,178,33,3,158,65,76,3,13,225
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 3
</td>

<td style="text-align:left;">

F3-2
</td>

<td style="text-align:left;">

F3-2b
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA
</td>

<td style="text-align:right;">

90
</td>

<td style="text-align:left;">

<9%3E124!752+@06I>/.72097\*‘;-+<A60=B?+/8'15477%3E4-435D;G@G>’./21:(0/1/A=7’I\>A”3=9;;12,@“2=3D=,458
</td>

<td style="text-align:left;">

3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
</td>

<td style="text-align:left;">

51,190,33,181,255,241,151,186,124,196,1,142,117,84,213,249,168
</td>

<td style="text-align:left;">

3,6,9,12,15,18,27,30,39,42,51,54,63,66,75,78,87
</td>

<td style="text-align:left;">

9,13,165,10,0,10,104,65,78,43,124,87,0,95,19,2,73
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 3
</td>

<td style="text-align:left;">

F3-2
</td>

<td style="text-align:left;">

F3-2c
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA
</td>

<td style="text-align:right;">

87
</td>

<td style="text-align:left;">

0/2\>@/6+-/(!=9-?G!AA70*,/!/?-E46:,-1G94*491,,38?(-!6\<8A;/C9;,3)4C06=%’,86A)1!E@/24G59\<\<
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,39,42,51,54,63,66,75,78,81,84
</td>

<td style="text-align:left;">

60,209,185,249,68,224,124,78,101,194,26,107,168,75,53,1,27,55,29,175
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,39,42,51,54,63,66,75,78,81,84
</td>

<td style="text-align:left;">

191,30,16,5,136,30,35,156,75,19,90,112,9,76,133,75,47,0,24,17
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 3
</td>

<td style="text-align:left;">

F3-3
</td>

<td style="text-align:left;">

F3-3a
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
</td>

<td style="text-align:right;">

96
</td>

<td style="text-align:left;">

$&lt;,5"7+!$’;<8%3C0794*@FI>\>34224!57+#1!F\<+53\$,?)-.A3;=1\*71C02\<.5:1)<a href="mailto:82!86$03/;%+1C3+D3;@9B-E"
class="email">82!86$03/;%+1C3+D3;@9B-E</a>\#+/70;9\<D’
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
</td>

<td style="text-align:left;">

49,251,241,176,189,187,166,43,235,144,137,5,93,175,106,193,198,146,48
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,30,33,42,45,54,57,66,69,78,81,90,93
</td>

<td style="text-align:left;">

24,3,3,78,63,47,66,155,13,19,109,141,87,2,55,43,24,83,161
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 3
</td>

<td style="text-align:left;">

F3-4
</td>

<td style="text-align:left;">

F3-4a
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA
</td>

<td style="text-align:right;">

96
</td>

<td style="text-align:left;">

?2-#-2”1:(5(4\>!I)\>I,.?-+EG3IH4-.C:;<570@2I>;?D5#/;A7=\>?\<3?080::459\*?8:3”\<2;I)C1400)6:3%19./);.I?35
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,42,45,54,57,66,69,78,81,90,93
</td>

<td style="text-align:left;">

193,24,159,106,198,206,247,55,221,106,131,198,34,105,169,231,88,27,238,51,14
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,42,45,54,57,66,69,78,81,90,93
</td>

<td style="text-align:left;">

36,44,73,14,35,20,6,162,33,32,108,24,113,116,11,10,111,207,6,21,225
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 3
</td>

<td style="text-align:left;">

F3-4
</td>

<td style="text-align:left;">

F3-4b
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA
</td>

<td style="text-align:right;">

81
</td>

<td style="text-align:left;">

.85\$#;!1F\$8E:<B+;7CI6@11>/’65\<3,4G:<8@GF1413>:0)3CH1=44.%G=#2E67=?;9DF7358.;(I!74:1I4
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
</td>

<td style="text-align:left;">

109,86,70,169,200,112,237,69,168,97,239,188,150,208,225,190,128,252,142,224
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,27,30,33,36,45,48,57,60,69,72,75,78
</td>

<td style="text-align:left;">

29,9,79,29,15,95,14,82,81,43,11,25,98,35,18,53,112,2,57,31
</td>

</tr>

<tr>

<td style="text-align:left;">

Family 3
</td>

<td style="text-align:left;">

F3-4
</td>

<td style="text-align:left;">

F3-4c
</td>

<td style="text-align:left;">

GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA
</td>

<td style="text-align:right;">

90
</td>

<td style="text-align:left;">

5@\<733’;9+3BB)=69,<3!.2B*86'8E%3E@3>?!(36:\<002/4\>:1.43A!+;\<.3G*G8?0*991,B(C/“I9\*1-86)8.;;5-0+=
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
</td>

<td style="text-align:left;">

161,156,9,65,198,255,245,191,174,63,155,146,13,95,228,100,132,45,49
</td>

<td style="text-align:left;">

3,6,9,12,15,18,21,24,33,36,45,48,57,60,69,72,81,84,87
</td>

<td style="text-align:left;">

52,87,155,117,2,0,3,50,81,184,75,74,60,97,15,8,46,188,81
</td>

</tr>

</tbody>

</table>

</div>

The DNA sequence in column `sequence` is the information used for
visualising single/multiple sequences. For visualising DNA modification,
this data contains information on both 5-cytosine-methylation and
5-cytosine-hydroxymethylation. For a given modification type
(e.g. methylation), visualisation requires a column of locations and a
column of probabilities. In this dataset, the relevant columns are
`methylation_locations` and `methylation_probabilities` for methylation
and `hydroxymethylation_locations` and
`hydroxymethylation_probabilities` for hydroxymethylation.

Locations are stored as a comma-condensed string of integers for each
read, produced via `vector_to_string()`, and indicate the indices along
the read at which the probability of modification was assessed. For
example, methylation might be assessed at each CpG site, which in the
read `"GGCGGCGGAGGCGGCGGA"` would be the third, sixth, twelfth, and
fifteenth bases, thus the location string would be `"3,6,12,15"` for
that read.

Probabilities are also a comma-condensed string of integers produced via
`vector_to_string()`, but here each integer represents the probability
that the corresponding base is modified. Probabilities are stored as
8-bit integers (0-255) where a score of $N$ represents the probability
space from $\frac{N}{256}$ to $\frac{N+1}{256}$. For the read above, a
probability string of `"250,3,50,127"` would indicate that the third
base is almost certainly methylated (97.66%-98.05%), the sixth base is
almost certainly not methylated (1.17%-1.56%), the twelfth base is most
likely not methylated (19.53%-19.92%), and the fifteenth base may or may
not be methylated (49.61%-50.00%)

``` r
## Function to convert integer scores to corresponding percentages
convert_8bit_to_decimal_prob <- function(x) {
    return(c(  x   / 256, 
             (x+1) / 256))
}

## Convert comma-condensed string back to numerical vector
## string_to_vector() and vector_to_string() are crucial ggDNAvis helpers
probabilities <- string_to_vector("250,3,50,127")

## For each probability, print 8-bit score then percentage range
for (probability in probabilities) {
    percentages <- round(convert_8bit_to_decimal_prob(probability), 4) * 100
    cat("8-bit probability: ", probability, "\n", sep = "")
    cat("Decimal probability: ", percentages[1], "% - ", percentages[2], "%", "\n\n", sep = "")
}
```

    ## 8-bit probability: 250
    ## Decimal probability: 97.66% - 98.05%
    ## 
    ## 8-bit probability: 3
    ## Decimal probability: 1.17% - 1.56%
    ## 
    ## 8-bit probability: 50
    ## Decimal probability: 19.53% - 19.92%
    ## 
    ## 8-bit probability: 127
    ## Decimal probability: 49.61% - 50%

## Loading from FASTQ and metadata file

I need to add a way to read/write unmodified FASTQ

# Visualising a single DNA/RNA sequence

ggDNAvis can be used to visualise a single DNA sequence via
`visualise_single_sequence`
