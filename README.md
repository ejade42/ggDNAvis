
- [1 ggDNAvis](#1-ggdnavis)
- [2 Loading data](#2-loading-data)
  - [2.1 Introduction to
    `example_many_sequences`](#21-introduction-to-example_many_sequences)
  - [2.2 Loading from FASTQ and metadata
    file](#22-loading-from-fastq-and-metadata-file)
    - [2.2.1 Standard FASTQ](#221-standard-fastq)
- [3 Visualising a single DNA/RNA
  sequence](#3-visualising-a-single-dnarna-sequence)

# 1 ggDNAvis

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

Throughout this manual, only ggDNAvis and its dependecies (including the
full namespaces of dplyr and ggplot2) are loaded:

``` r
library(ggDNAvis)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

# 2 Loading data

## 2.1 Introduction to `example_many_sequences`

ggDNAvis comes with example dataset `example_many_sequences`. In this
data, each row/observation represents one read. Reads are associated
with metadata such as the participant and family to which they belong,
and with sequence data such as the DNA sequence, FASTQ quality scores,
and modification information retrieved from the MM and ML tags in a
SAM/BAM file.

``` r
## View the first 4 rows of example_many_sequences data
knitr::kable(head(example_many_sequences, 4))
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

## 2.2 Loading from FASTQ and metadata file

### 2.2.1 Standard FASTQ

To read in a normal FASTQ file (containing a read ID/header, sequence,
and quality scores for each read), the function `read_fastq()` can be
used. The example data file for this is
`inst/extdata/example_many_sequences_raw.fastq`

``` r
## Load data from FASTQ
fastq_data <- read_fastq("inst/extdata/example_many_sequences_raw.fastq", calculate_length = TRUE)

## View first 4 rows
knitr::kable(head(fastq_data, 4))
```

| read | sequence | quality | sequence_length |
|:---|:---|:---|---:|
| F1-1a | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | )8@!9:/0/,0+-6?40,-I601:.’;+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)\<I5.5G*CB8501;I3’.8233’3\>\<:13)48F?09\*\>?I90 | 102 |
| F1-1b | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 60-7,7943/*=5=)7\<53-I=G6/&/7?8)\<\$12”\>/2C;4:9F8:816E,6C3*,1-2139 | 63 |
| F1-1c | TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC | @9889C8\<\<*96;52!*86,227.\<I.8AI\<\>;<2/391%D19*5@G>=8\<7\<:!7+;:I:-!03\<0AI\>9?4!57I\*-C#25FD24F; | 87 |
| F1-1d | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | :\<\*1D)89?27#8.3)9\<2G\<\>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8\>0 | 81 |

Using the basic `read_fastq()` function returns a dataframe with read
ID, sequence, and quality columns. Optionally, a sequence_length column
can be generated by setting `calculate_length = TRUE`. However, we can
see that some of the sequences e.g. F1-1c are reversed. This occurs when
the read is of the - strand at the biochemical level.

To convert reverse reads to their forward equivalents, and incorporate
additional data such as the participant and family to which each read
belongs, we will make use of a metadata file located at
`inst/extdata/example_many_sequences_metadata.csv`

``` r
## Load metadata from CSV
metadata <- read.csv("inst/extdata/example_many_sequences_metadata.csv")

## View first 4 rows
knitr::kable(head(metadata, 4))
```

| family   | individual | read  | direction |
|:---------|:-----------|:------|:----------|
| Family 1 | F1-1       | F1-1a | forward   |
| Family 1 | F1-1       | F1-1b | forward   |
| Family 1 | F1-1       | F1-1c | reverse   |
| Family 1 | F1-1       | F1-1d | forward   |

We see that this metadata file contains the same `read` column with the
same unique read IDs and a `direction` column specifying whether each
read is `"forward"` or `"reverse"`. These two columns are mandatory.
Additionally, we have family and participant ID columns providing
additional information on each read.

Note: the `direction` column can be produced manually. However, for
large data volumes it may be more effective to use SAMtools to write TXT
files of all forward and reverse read IDs via the -F/-f 16 flags, e.g.:

``` bash
## bash/shell code for using SAMtools on the command line:

## See the samtools flag documentation for more details on why
## -F 16 selects forward reads and -F 16 selects reverse reads
samtools view -F 16 ${input_bam_file} | \
awk '{print $1}'  > "forward_reads.fastq"

samtools view -f 16 ${input_bam_file} | \
awk '{print $1}'  > "reverse_reads.fastq"
```

Then simply read the lines from each file and use that to assign
directions:

``` r
## Use files from last step to construct vectors of forward and reverse IDs
forward_reads <- readLines("forward_reads.fastq")
reverse_reads <- readLines("reverse_reads.fastq")

## Use rep() to add a direction column
constructed_metadata <- data.frame(
    read = c(forward_reads, reverse_reads),
    direction = c(rep("forward", length(forward_reads)),
                  rep("reverse", length(reverse_reads)))
    )
```

In any case, once we have metadata with the `read` and `direction`
columns, we can use `merge_fastq_with_metadata()` to combine the
metadata and the fastq data. Crucially, this function uses the
`direction` column of the metadata to determine which reads are reverse,
and reverse-complements these reverse reads only to produce a new column
containing the forward version of all reads:

``` r
## Merge fastq data with metadata
## This function reverse-complements reverse reads to get all forward versions
merged_fastq_data <- merge_fastq_with_metadata(fastq_data, metadata)

## View first 4 rows
knitr::kable(head(merged_fastq_data, 4))
```

| read | family | individual | direction | sequence | quality | sequence_length | forward_sequence | forward_quality |
|:---|:---|:---|:---|:---|:---|---:|:---|:---|
| F1-1a | Family 1 | F1-1 | forward | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | )8@!9:/0/,0+-6?40,-I601:.’;+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)\<I5.5G*CB8501;I3’.8233’3\>\<:13)48F?09\*\>?I90 | 102 | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | )8@!9:/0/,0+-6?40,-I601:.’;+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)\<I5.5G*CB8501;I3’.8233’3\>\<:13)48F?09\*\>?I90 |
| F1-1b | Family 1 | F1-1 | forward | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 60-7,7943/*=5=)7\<53-I=G6/&/7?8)\<\$12”\>/2C;4:9F8:816E,6C3*,1-2139 | 63 | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 60-7,7943/*=5=)7\<53-I=G6/&/7?8)\<\$12”\>/2C;4:9F8:816E,6C3*,1-2139 |
| F1-1c | Family 1 | F1-1 | reverse | TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC | @9889C8\<\<*96;52!*86,227.\<I.8AI\<\>;<2/391%D19*5@G>=8\<7\<:!7+;:I:-!03\<0AI\>9?4!57I\*-C#25FD24F; | 87 | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | ;F42DF52#C-*I75!4?9\>IA0\<30!-:I:;+7!:\<7<8=G@5*91D%193/2;>\<IA8.I\<.722,68*!25;69\*\<\<8C9889@ |
| F1-1d | Family 1 | F1-1 | forward | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | :\<\*1D)89?27#8.3)9\<2G\<\>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8\>0 | 81 | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | :\<\*1D)89?27#8.3)9\<2G\<\>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8\>0 |

Now we have a `forward_sequence` column (scroll to the right if you
can’t see it!). We can now reformat this data to be exactly the same as
the included `example_many_sequences` data:

``` r
## Subset to only the columns present in example_many_sequences
merged_fastq_data <- merged_fastq_data[, c("family", "individual", "read", "forward_sequence", "sequence_length", "forward_quality")]

## Rename "forward_sequence" to "sequence" and same for quality
colnames(merged_fastq_data)[c(4,6)] <- c("sequence", "quality")

## View first 4 rows of data produced from files
knitr::kable(head(merged_fastq_data, 4))
```

| family | individual | read | sequence | sequence_length | quality |
|:---|:---|:---|:---|---:|:---|
| Family 1 | F1-1 | F1-1a | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 102 | )8@!9:/0/,0+-6?40,-I601:.’;+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)\<I5.5G*CB8501;I3’.8233’3\>\<:13)48F?09\*\>?I90 |
| Family 1 | F1-1 | F1-1b | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 63 | 60-7,7943/*=5=)7\<53-I=G6/&/7?8)\<\$12”\>/2C;4:9F8:816E,6C3*,1-2139 |
| Family 1 | F1-1 | F1-1c | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 87 | ;F42DF52#C-*I75!4?9\>IA0\<30!-:I:;+7!:\<7<8=G@5*91D%193/2;>\<IA8.I\<.722,68*!25;69\*\<\<8C9889@ |
| Family 1 | F1-1 | F1-1d | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 81 | :\<\*1D)89?27#8.3)9\<2G\<\>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8\>0 |

``` r
## View first 4 rows of example_many_sequences (with modification columns excluded)
knitr::kable(head(example_many_sequences[, 1:6], 4))
```

| family | individual | read | sequence | sequence_length | quality |
|:---|:---|:---|:---|---:|:---|
| Family 1 | F1-1 | F1-1a | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 102 | )8@!9:/0/,0+-6?40,-I601:.’;+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)\<I5.5G*CB8501;I3’.8233’3\>\<:13)48F?09\*\>?I90 |
| Family 1 | F1-1 | F1-1b | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 63 | 60-7,7943/*=5=)7\<53-I=G6/&/7?8)\<\$12”\>/2C;4:9F8:816E,6C3*,1-2139 |
| Family 1 | F1-1 | F1-1c | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 87 | ;F42DF52#C-*I75!4?9\>IA0\<30!-:I:;+7!:\<7<8=G@5*91D%193/2;>\<IA8.I\<.722,68*!25;69\*\<\<8C9889@ |
| Family 1 | F1-1 | F1-1d | GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA | 81 | :\<\*1D)89?27#8.3)9\<2G\<\>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8\>0 |

``` r
## Check if equal
identical(merged_fastq_data, example_many_sequences[, 1:6])
```

    ## [1] TRUE

So, from just a standard FASTQ file and a simple metadata CSV we have
successfully reproduced the example_many_sequences data (excluding
methylation/modification information) via `read_fastq()` and
`merge_fastq_with_metadata()`. We can also write from this dataframe to
FASTQ using `write_fastq()`:

``` r
output_fastq <- write_fastq()
```

# 3 Visualising a single DNA/RNA sequence

ggDNAvis can be used to visualise a single DNA sequence via
`visualise_single_sequence`
