ggDNAvis README
================
Evelyn Jade
2025

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

Throughout this manual, only ggDNAvis and its dependencies are loaded.
This includes ggplot2 and dplyr, whose namespaces are loaded in full.

``` r
library(ggDNAvis)
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
## View the first 4 rows of the table
knitr::kable(head(as.data.frame(example_many_sequences), 4))
```

| family | individual | read | sequence | sequence_length | quality | methylation_locations | methylation_probabilities | hydroxymethylation_locations | hydroxymethylation_probabilities |
|:---|:---|:---|:---|---:|:---|:---|:---|:---|:---|
| Family 1 | F1-1 | F1-1a | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 102 | )8@!9:/0/,0+-6?40,-I601:.’;+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)\<I5.5G*CB8501;I3’.8233’3\>\<:13)48F?09\*\>?I90 | 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99 | 29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41 | 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99 | 26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34 |
| Family 1 | F1-1 | F1-1b | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 63 | 60-7,7943/*=5=)7\<53-I=G6/&/7?8)\<\$12”\>/2C;4:9F8:816E,6C3*,1-2139 | 3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60 | 10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253 | 3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60 | 10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2 |
| Family 1 | F1-1 | F1-1c | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 87 | ;F42DF52#C-*I75!4?9\>IA0\<30!-:I:;+7!:\<7<8=G@5*91D%193/2;>\<IA8.I\<.722,68*!25;69\*\<\<8C9889@ | 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84 | 206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45 | 3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84 | 40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37 |
| Family 1 | F1-1 | F1-1d | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 81 | :\<\*1D)89?27#8.3)9\<2G\<\>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8\>0 | 3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78 | 216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82 | 3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78 | 33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55 |

The DNA sequence in column `sequence` is the information used for
visualising single/multiple sequences. For visualising DNA modification,
this data contains information on both 5-cytosine-methylation and
5-cytosine-hydroxymethylation. For a given modification type
(e.g. methylation), visualisation requires a column of locations and a
column of probabilities.

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
8-bit integers (0-255) where a score of represents the probability space
from to . For the read above, a probability string of `"250,3,50,127"`
would indicate that the third base is almost certainly methylated
(97.66%-98.05%), the sixth base is almost certainly not methylated
(1.17%-1.56%), the twelfth base is most likely not methylated
(19.53%-19.92%), and the fifteenth base may or may not be methylated
(49.61%-50.00%)

``` r
## Function to convert integer scores to corresponding percentages
convert_8bit_to_decimal_prob <- function(x) {
    return(c(  x   / 256, 
             (x+1) / 256))
}

## Convert comma-condensed string back to numerical vector
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
