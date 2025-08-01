
- [1 ggDNAvis](#1-ggdnavis)
- [2 Loading data](#2-loading-data)
  - [2.1 Introduction to
    `example_many_sequences`](#21-introduction-to-example_many_sequences)
  - [2.2 Introduction to `string_to_vector()` and
    `vector_to_string()`](#22-introduction-to-string_to_vector-and-vector_to_string)
  - [2.3 Loading from FASTQ and metadata
    file](#23-loading-from-fastq-and-metadata-file)
    - [2.3.1 Standard FASTQ](#231-standard-fastq)
    - [2.3.2 Modified FASTQ
      (e.g. methylation)](#232-modified-fastq-eg-methylation)
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

Throughout this manual, only ggDNAvis and its dependencies dplyr and
ggplot2 are loaded:

``` r
## Load this package
library(ggDNAvis)

## Load dependencies
library(dplyr)
library(ggplot2)

## Function for viewing tables throughout this document
github_table <- function(data) {
    quoted <- as.data.frame(
        lapply(data, function(x) {paste0("`", x, "`")}),
        check.names = FALSE
    )
    kable_output <- knitr::kable(quoted)
    return(kable_output)
}
```

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
github_table(head(example_many_sequences, 4))
```

| family | individual | read | sequence | sequence_length | quality | methylation_locations | methylation_probabilities | hydroxymethylation_locations | hydroxymethylation_probabilities |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `Family 1` | `F1-1` | `F1-1a` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` |
| `Family 1` | `F1-1` | `F1-1b` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` |
| `Family 1` | `F1-1` | `F1-1c` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `87` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37` |
| `Family 1` | `F1-1` | `F1-1d` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` |

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

## 2.2 Introduction to `string_to_vector()` and `vector_to_string()`

Lots of the data used in ggDNAvis requires a series of multiple values
to be stored within a single observation in a dataframe. The solution
used here is condensing vectors to a single string (character value) for
simple storage, then reconstituting the original vectors when needed.
These functions are basic wrappers around `strsplit()` and
`paste(, collapse = ",")` but are easy to use and readable.

Additionally, these can be used when reading SAM/BAM MM and ML tags,
which are stored as comma-separated lists within modified FASTQ files,
so can also be processed using these functions.

``` r
vector_to_string(c(1, 2, 3, 4))
```

    ## [1] "1,2,3,4"

``` r
string_to_vector("1,2,3,4") # the default vector type is numeric
```

    ## [1] 1 2 3 4

``` r
vector_to_string(c("these", "are", "some", "words"))
```

    ## [1] "these,are,some,words"

``` r
string_to_vector("these,are,some,words", type = "character")
```

    ## [1] "these" "are"   "some"  "words"

``` r
vector_to_string(c(TRUE, FALSE, TRUE))
```

    ## [1] "TRUE,FALSE,TRUE"

``` r
string_to_vector("TRUE,FALSE,TRUE", type = "logical")
```

    ## [1]  TRUE FALSE  TRUE

If multiple strings (i.e. a character vector) are input to
`string_to_vector()`, it will concatenate them and produce a single
output vector. This is intended, useful behaviour to help with some of
the visualisation code in this package. If a list of separate vectors
for each input value is desired, `lapply()` can be used.

``` r
string_to_vector(c("1,2,3", "4,5,6"))
```

    ## [1] 1 2 3 4 5 6

``` r
lapply(c("1,2,3", "4,5,6"), string_to_vector)
```

    ## [[1]]
    ## [1] 1 2 3
    ## 
    ## [[2]]
    ## [1] 4 5 6

## 2.3 Loading from FASTQ and metadata file

### 2.3.1 Standard FASTQ

To read in a normal FASTQ file (containing a read ID/header, sequence,
and quality scores for each read), the function `read_fastq()` can be
used. The example data file for this is
`inst/extdata/example_many_sequences_raw.fastq`

``` r
## Look at first 16 lines of FASTQ
fastq_raw <- readLines("inst/extdata/example_many_sequences_raw.fastq")
for (i in 1:16) {
    cat(fastq_raw[i], "\n")
}
```

    ## F1-1a 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90 
    ## F1-1b 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## 60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139 
    ## F1-1c 
    ## TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC 
    ## + 
    ## @9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F; 
    ## F1-1d 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0

``` r
## Load data from FASTQ
fastq_data <- read_fastq("inst/extdata/example_many_sequences_raw.fastq", calculate_length = TRUE)

## View first 4 rows
github_table(head(fastq_data, 4))
```

| read | sequence | quality | sequence_length |
|:---|:---|:---|:---|
| `F1-1a` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `102` |
| `F1-1b` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `63` |
| `F1-1c` | `TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC` | `@9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F;` | `87` |
| `F1-1d` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `81` |

Using the basic `read_fastq()` function returns a dataframe with read
ID, sequence, and quality columns. Optionally, a `sequence_length`
column can be generated by setting `calculate_length = TRUE`. However,
we can see that some of the sequences (e.g. F1-1c) are reversed. This
occurs when the read is of the - strand at the biochemical level.

To convert reverse reads to their forward equivalents, and incorporate
additional data such as the participant and family to which each read
belongs, we will make use of a metadata file located at
`inst/extdata/example_many_sequences_metadata.csv`

``` r
## Load metadata from CSV
metadata <- read.csv("inst/extdata/example_many_sequences_metadata.csv")

## View first 4 rows
github_table(head(metadata, 4))
```

| family     | individual | read    | direction |
|:-----------|:-----------|:--------|:----------|
| `Family 1` | `F1-1`     | `F1-1a` | `forward` |
| `Family 1` | `F1-1`     | `F1-1b` | `forward` |
| `Family 1` | `F1-1`     | `F1-1c` | `reverse` |
| `Family 1` | `F1-1`     | `F1-1d` | `forward` |

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
awk '{print $1}'  > "forward_reads.txt"

samtools view -f 16 ${input_bam_file} | \
awk '{print $1}'  > "reverse_reads.txt"
```

Then simply read the lines from each file and use that to assign
directions:

``` r
## Use files from last step to construct vectors of forward and reverse IDs
forward_reads <- readLines("forward_reads.txt")
reverse_reads <- readLines("reverse_reads.txt")

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
github_table(head(merged_fastq_data, 4))
```

| read | family | individual | direction | sequence | quality | sequence_length | forward_sequence | forward_quality |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `F1-1a` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `102` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` |
| `F1-1b` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `63` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` |
| `F1-1c` | `Family 1` | `F1-1` | `reverse` | `TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC` | `@9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F;` | `87` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` |
| `F1-1d` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `81` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` |

Now we have a `forward_sequence` column (scroll to the right if you
can’t see it!). We can now reformat this data to be exactly the same as
the included `example_many_sequences` data:

``` r
## Subset to only the columns present in example_many_sequences
merged_fastq_data <- merged_fastq_data[, c("family", "individual", "read", "forward_sequence", "sequence_length", "forward_quality")]

## Rename "forward_sequence" to "sequence" and same for quality
colnames(merged_fastq_data)[c(4,6)] <- c("sequence", "quality")

## View first 4 rows of data produced from files
github_table(head(merged_fastq_data, 4))
```

| family | individual | read | sequence | sequence_length | quality |
|:---|:---|:---|:---|:---|:---|
| `Family 1` | `F1-1` | `F1-1a` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` |
| `Family 1` | `F1-1` | `F1-1b` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` |
| `Family 1` | `F1-1` | `F1-1c` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `87` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` |
| `Family 1` | `F1-1` | `F1-1d` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` |

``` r
## View first 4 rows of example_many_sequences (with modification columns excluded)
github_table(head(example_many_sequences[, 1:6], 4))
```

| family | individual | read | sequence | sequence_length | quality |
|:---|:---|:---|:---|:---|:---|
| `Family 1` | `F1-1` | `F1-1a` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` |
| `Family 1` | `F1-1` | `F1-1b` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` |
| `Family 1` | `F1-1` | `F1-1c` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `87` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` |
| `Family 1` | `F1-1` | `F1-1d` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` |

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
## Use write_fastq with filename = NA and return = TRUE to create the FASTQ, 
## but return it as a character vector rather than writing to file.
output_fastq <- write_fastq(merged_fastq_data, 
                            filename = NA, return = TRUE,
                            read_id_colname = "read", 
                            sequence_colname = "sequence",
                            quality_colname = "quality")
## View first 16 lines
for (i in 1:16) {
    cat(output_fastq[i], "\n")
}
```

    ## F1-1a 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90 
    ## F1-1b 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## 60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139 
    ## F1-1c 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## ;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@ 
    ## F1-1d 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0

### 2.3.2 Modified FASTQ (e.g. methylation)

FASTQ files can be extended to include DNA modification (most often
5-cytosine-methylation) information within the header rows. Most often,
this information comes from Nanopore long-read sequencing being
basecalled with a modification-capable model in Guppy or Dorado,
resulting in SAM or BAM files. In SAM/BAM files, modification
information is stored in the MM and ML tags. These can be copied to the
header rows of a FASTQ file via

``` bash
samtools fastq -T MM,ML ${input_bam_file} > "modified_fastq_file.fastq"
```

ggDNAvis then contains tools for reading from, processing, and writing
to these modified FASTQ files. The example data file for this is
`inst/extdata/example_many_sequences_raw_modified.fastq`

``` r
## Look at first 16 lines of FASTQ
modified_fastq_raw <- readLines("inst/extdata/example_many_sequences_raw_modified.fastq")
for (i in 1:16) {
    cat(modified_fastq_raw[i], "\n")
}
```

    ## F1-1a    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34,29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90 
    ## F1-1b    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2,10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## 60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139 
    ## F1-1c    MM:Z:C+h?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1;C+m?,1,1,5,1,1,5,1,1,5,1,1,5,1,1,1,1,1,1,1,1; ML:B:C,37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40,45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206 
    ## TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC 
    ## + 
    ## @9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F; 
    ## F1-1d    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55,216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0

This file is identical to the standard FASTQ seen in
<a href="#standard-fastq">2.3.1</a> in the sequence and quality lines,
but has the MM and ML tags stored in the header. See the [SAM tags
specification](https://samtools.github.io/hts-specs/SAMtags.pdf) or the
documentation for `read_modified_fastq()`,
`merge_methylation_with_metadata()`, and `reverse_locations_if_needed()`
for a comprehensive explanation of how these store
methylation/modification information.

The modification information stored in these FASTQ header lines can be
parsed with `read_modified_fastq()`. This converts the locations from
the SAM/BAM MM format to simply being the indices along the read at
which modification was assessed (starting indexing at 1). For example,
in F1-1a, the `C+m?` (methylation) locations start `"3,6,9,12"`,
indicating that the third, sixth, ninth, and twelfth bases in the read
were assessed for probability of methylation. Checking the sequence, we
see that all of these are CpG sites (CG dinucleotides), which are the
main DNA methylation sites in the genome. For each assessed site, the
modification probability is given as an 8-bit integer (0-255), where 0
represents ~0% modification probability and 255 represents ~100%
modification probability (this is fully explained in
@ref(introduction-to-example_many_sequences)).

``` r
## Load data from FASTQ
methylation_data <- read_modified_fastq("inst/extdata/example_many_sequences_raw_modified.fastq")

## View first 4 rows
github_table(head(methylation_data, 4))
```

| read | sequence | sequence_length | quality | modification_types | C+h?\_locations | C+h?\_probabilities | C+m?\_locations | C+m?\_probabilities |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `F1-1a` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` |
| `F1-1b` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` |
| `F1-1c` | `TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC` | `87` | `@9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F;` | `C+h?,C+m?` | `3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84` | `37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40` | `3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84` | `45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206` |
| `F1-1d` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` |

Ultimately, `read_modified_fastq()` outputs a dataframe with the
standard read information (ID, sequence, length, quality), a column
stating which modification types were assessed for each read
(e.g. `"C+h?"` for hydroxymethylation or `"C+m?"` for methylation -
refer to the [SAM tags
specification](https://samtools.github.io/hts-specs/SAMtags.pdf)), and
for each modification type, a column of assessed locations (indices
along the read) and a column of modification probabilities (as 8-bit
integers).

Modification types, locations, and probabilities are all stored as
comma-condensed strings produced from vectors via `vector_to_string()`.
These can be converted back to vectors via `string_to_vector()` - see
@ref(introduction-to-string_to_vector-and-vector_to_string).

As with the standard FASTQ, some of the reads in the modified FASTQ are
reverse. However, as the assessed modification locations are indices
along the read and the probabilities correspond to locations in
sequence, the modification information needs to be reversed in addition
to reverse complementing the DNA sequence. Analogous to before, this is
achieved via the `merge_methylation_with_metadata()` function.

``` r
## Load metadata from CSV
metadata <- read.csv("inst/extdata/example_many_sequences_metadata.csv")

## View first 4 rows
github_table(head(metadata, 4))
```

| family     | individual | read    | direction |
|:-----------|:-----------|:--------|:----------|
| `Family 1` | `F1-1`     | `F1-1a` | `forward` |
| `Family 1` | `F1-1`     | `F1-1b` | `forward` |
| `Family 1` | `F1-1`     | `F1-1c` | `reverse` |
| `Family 1` | `F1-1`     | `F1-1d` | `forward` |

The metadata is identical to previously
(<a href="#standard-fastq">2.3.1</a>).

``` r
## Merge fastq data with metadata
## This function reverse-complements reverse reads to get all forward versions
## And correctly flips location and probability information
## See ?merged_methylation_data and ?reverse_locations_if_needed for details
merged_methylation_data <- merge_methylation_with_metadata(methylation_data, metadata)

## View first 4 rows
github_table(head(merged_methylation_data, 4))
```

| read | family | individual | direction | sequence | sequence_length | quality | modification_types | C+h?\_locations | C+h?\_probabilities | C+m?\_locations | C+m?\_probabilities | forward_sequence | forward_quality | forward_C+h?\_locations | forward_C+h?\_probabilities | forward_C+m?\_locations | forward_C+m?\_probabilities |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `F1-1a` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` |
| `F1-1b` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` |
| `F1-1c` | `Family 1` | `F1-1` | `reverse` | `TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC` | `87` | `@9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F;` | `C+h?,C+m?` | `3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84` | `37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40` | `3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84` | `45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` | `4,7,10,13,16,19,22,25,28,37,40,43,52,55,58,67,70,73,82,85` | `40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37` | `4,7,10,13,16,19,22,25,28,37,40,43,52,55,58,67,70,73,82,85` | `206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45` |
| `F1-1d` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` |

The merged methylation data contains `forward_` rows for sequence and
quality, as before, but also for hydroxymethylation and methylation
locations and probabilities. However, looking at the modification
locations columns (scroll right on the table), we can see that the
indices assessed for modification are 4, 7, 10 etc for sequence
`"GGCGGCGGCGGC..."`. This is because the actual biochemical modification
was on the Cs on the reverse strand, corresponding to Gs on the forward
strand according to Watson-Crick base pairing. For many purposes, it may
be desirable to keep these positions to indicate that in reality, the
modification occurred at exactly that location on the other strand. This
is accomplished by setting `offset = 0` (the default) inside
`merge_methylation_with_metadata()`.

However, there is also the option to offset the modification locations
by 1. For symmetrical modification sites such as CGs, this means that
when the C on the reverse strand is modified, that gets attributed to
the *C* on the forward strand even though the direct complementary base
is the G. The advantage of this is that it means CG sites
(i.e. potential methylation sites) always have 5-methylcytosine
modifications associated with the C of each CG, regardless of which
strand the information came from. This is also often useful, as it
ensures the information is consistent and (provided locations are
palindromic when reverse-complemented) modifications are always attached
to the correct base e.g. C-methylation to C. This is accomplished by
setting `offset = 1` inside `merge_methylation_with_metadata()`.

***Either of these options can be valid and useful, but make sure you
think about it!***

    ## Here the stars represent the true biochemical modifications on the reverse strand:
    ## (occurring at the Cs of CGs in the 5'-3' direction)
    ## 
    ## 
    ## 5'  GGCGGCGGCGGCGGCGGA  3'
    ## 3'  CCGCCGCCGCCGCCGCCT  5'
    ##        *  *  *  *  *

    ## If we take the complementary locations on the forward strand,
    ## the modification locations correspond to Gs rather than Cs,
    ## but are in the exact same locations:
    ## 
    ##        o  o  o  o  o      
    ## 5'  GGCGGCGGCGGCGGCGGA  3'
    ## 3'  CCGCCGCCGCCGCCGCCT  5'
    ##        *  *  *  *  *

    ## If we offset the locations by 1 on the forward strand,
    ## the modifications are always associated with the C of a CG,
    ## but the locations are moved slightly:
    ## 
    ##       o  o  o  o  o       
    ## 5'  GGCGGCGGCGGCGGCGGA  3'
    ## 3'  CCGCCGCCGCCGCCGCCT  5'
    ##        *  *  *  *  *

We will proceed with `offset = 1` so that the forward versions match up
with `example_many_sequences`.

``` r
## Merge fastq data with metadata, offsetting reversed locations by 1
merged_methylation_data <- merge_methylation_with_metadata(methylation_data, 
                                                           metadata, 
                                                           reversed_location_offset = 1)

## View first 4 rows
github_table(head(merged_methylation_data, 4))
```

| read | family | individual | direction | sequence | sequence_length | quality | modification_types | C+h?\_locations | C+h?\_probabilities | C+m?\_locations | C+m?\_probabilities | forward_sequence | forward_quality | forward_C+h?\_locations | forward_C+h?\_probabilities | forward_C+m?\_locations | forward_C+m?\_probabilities |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `F1-1a` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` |
| `F1-1b` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` |
| `F1-1c` | `Family 1` | `F1-1` | `reverse` | `TCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCTCCTCCGCCGCCGCCGCCGCCGCCGCCGCCGCC` | `87` | `@9889C8<<*96;52!*86,227.<I.8AI<>;2/391%D19*5@G=8<7<:!7+;:I:-!03<0AI>9?4!57I*-C#25FD24F;` | `C+h?,C+m?` | `3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84` | `37,47,64,63,33,64,52,55,17,46,47,64,56,64,56,60,55,58,63,40` | `3,6,15,18,21,30,33,36,45,48,51,60,63,66,69,72,75,78,81,84` | `45,192,126,129,39,129,183,79,19,195,62,124,173,128,84,159,80,165,141,206` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45` |
| `F1-1d` | `Family 1` | `F1-1` | `forward` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `C+h?,C+m?` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` |

Now, looking at the methylation and hydroxymethylation locations we see
that the forward-version locations are 3, 6, 9, 12…, corresponding to
the Cs of CGs. This makes the reversed reverse read consistent with the
forward reads.

We can now extract the relevant columns and demonstrate that this new
dataframe read from modified FASTQ and metadata CSV is exactly the same
as `example_many_sequences`.

``` r
## Subset to only the columns present in example_many_sequences
merged_methylation_data <- merged_methylation_data[, c("family", "individual", "read", "forward_sequence", "sequence_length", "forward_quality", "forward_C+m?_locations", "forward_C+m?_probabilities", "forward_C+h?_locations", "forward_C+h?_probabilities")]

## Rename "forward_sequence" to "sequence" and same for quality
colnames(merged_methylation_data)[c(4,6:10)] <- c("sequence", "quality", "methylation_locations", "methylation_probabilities", "hydroxymethylation_locations", "hydroxymethylation_probabilities")

## View first 4 rows of data produced from files
github_table(head(merged_methylation_data, 4))
```

| family | individual | read | sequence | sequence_length | quality | methylation_locations | methylation_probabilities | hydroxymethylation_locations | hydroxymethylation_probabilities |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `Family 1` | `F1-1` | `F1-1a` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` |
| `Family 1` | `F1-1` | `F1-1b` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` |
| `Family 1` | `F1-1` | `F1-1c` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `87` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37` |
| `Family 1` | `F1-1` | `F1-1d` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` |

``` r
## View first 4 rows of example_many_sequences
github_table(head(example_many_sequences, 4))
```

| family | individual | read | sequence | sequence_length | quality | methylation_locations | methylation_probabilities | hydroxymethylation_locations | hydroxymethylation_probabilities |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| `Family 1` | `F1-1` | `F1-1a` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `102` | `)8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84,87,96,99` | `26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34` |
| `Family 1` | `F1-1` | `F1-1b` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `63` | `60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253` | `3,6,9,12,15,18,21,24,27,30,33,42,45,48,57,60` | `10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2` |
| `Family 1` | `F1-1` | `F1-1c` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `87` | `;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45` | `3,6,9,12,15,18,21,24,27,36,39,42,51,54,57,66,69,72,81,84` | `40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37` |
| `Family 1` | `F1-1` | `F1-1d` | `GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA` | `81` | `:<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82` | `3,6,9,12,15,18,21,24,27,30,33,36,45,48,51,60,63,66,75,78` | `33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55` |

``` r
## Check if equal
identical(merged_methylation_data, example_many_sequences)
```

    ## [1] TRUE

So, from a modified FASTQ file and the metadata CSV we have successfully
reproduced the example_many_sequences data *including*
methylation/modification information via `read_modified_fastq()` and
`merge_methylation_with_metadata()`. And similarly to before, we can
write back to a modified FASTQ file via `write_modified_fastq()`.

``` r
## Use write_modified_fastq with filename = NA and return = TRUE to create 
## the FASTQ, but return it as a character vector rather than writing to file.
output_fastq <- write_modified_fastq(merged_methylation_data, 
                                     filename = NA, return = TRUE,
                                     read_id_colname = "read", 
                                     sequence_colname = "sequence",
                                     quality_colname = "quality",
                                     locations_colnames = c("hydroxymethylation_locations",
                                                            "methylation_locations"),
                                     probabilities_colnames = c("hydroxymethylation_probabilities",
                                                                "methylation_probabilities"),
                                     modification_prefixes = c("C+h?", "C+m?"))
## View first 16 lines
for (i in 1:16) {
    cat(output_fastq[i], "\n")
}
```

    ## F1-1a    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,26,60,61,60,30,59,2,46,57,64,54,63,52,18,53,34,52,50,39,46,55,54,34,29,159,155,159,220,163,2,59,170,131,177,139,72,235,75,214,73,68,48,59,81,77,41 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## )8@!9:/0/,0+-6?40,-I601:.';+5,@0.0%)!(20C*,2++*(00#/*+3;E-E)<I5.5G*CB8501;I3'.8233'3><:13)48F?09*>?I90 
    ## F1-1b    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,10,44,39,64,20,36,11,63,50,54,64,38,46,41,49,2,10,56,207,134,233,212,12,116,68,78,129,46,194,51,66,253 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## 60-7,7943/*=5=)7<53-I=G6/&/7?8)<$12">/2C;4:9F8:816E,6C3*,1-2139 
    ## F1-1c    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,40,63,58,55,60,56,64,56,64,47,46,17,55,52,64,33,63,64,47,37,206,141,165,80,159,84,128,173,124,62,195,19,79,183,129,39,129,126,192,45 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## ;F42DF52#C-*I75!4?9>IA0<30!-:I:;+7!:<7<8=G@5*91D%193/2;><IA8.I<.722,68*!25;69*<<8C9889@ 
    ## F1-1d    MM:Z:C+h?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;C+m?,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0; ML:B:C,33,29,10,55,3,46,53,54,64,12,63,27,24,4,43,21,64,60,17,55,216,221,11,81,4,61,180,79,130,13,144,31,228,4,200,23,132,98,18,82 
    ## GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA 
    ## + 
    ## :<*1D)89?27#8.3)9<2G<>I.=?58+:.=-8-3%6?7#/FG)198/+3?5/0E1=D9150A4D//650%5.@+@/8>0

# 3 Visualising a single DNA/RNA sequence

ggDNAvis can be used to visualise a single DNA sequence via
`visualise_single_sequence()`. This function is extremely simple, just
taking a DNA sequence as input. We will use the *NOTCH2NLC* repeat
expansion sequence of F1-1 from Figure 1 of Sone et al. (2019).

``` r
## Define sequence variable
sone_2019_f1_1_expanded <- "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGCGGCGGCGGCGGC"

## Use all default settings
visualise_single_sequence(sone_2019_f1_1_expanded)
```

![](README_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

By default, `visualise_single_sequence()` will return a ggplot object.
It can be useful to view this for instant debugging. However, it is not
usually rendered at a sensible scale or aspect ratio. Therefore, it is
preferable to set a `filename = <file_to_write_to.png>` for export, as
the function has built-in logic for scaling correctly (with resolution
configurable via the `pixels_per_base` argument). We don’t have a use
for interactive debugging, so we will also set `return = FALSE`.

``` r
## Create image
visualise_single_sequence(sone_2019_f1_1_expanded, 
                          filename = "README_files/output/single_sequence_01.png", 
                          return = FALSE)

## View image
knitr::include_graphics("README_files/output/single_sequence_01.png")
```

<img src="README_files/output/single_sequence_01.png" width="7600" />

<div id="refs" class="references csl-bib-body hanging-indent"
entry-spacing="0" line-spacing="2">

<div id="ref-sone_long-read_2019" class="csl-entry">

Sone, J., Mitsuhashi, S., Fujita, A., Mizuguchi, T., Hamanaka, K., Mori,
K., Koike, H., Hashiguchi, A., Takashima, H., Sugiyama, H., Kohno, Y.,
Takiyama, Y., Maeda, K., Doi, H., Koyano, S., Takeuchi, H., Kawamoto,
M., Kohara, N., Ando, T., … Sobue, G. (2019). Long-read sequencing
identifies GGC repeat expansions in *NOTCH2NLC* associated with neuronal
intranuclear inclusion disease. *Nature Genetics*, *51*(8), 1215–1221.
<https://doi.org/10.1038/s41588-019-0459-y>

</div>

</div>
