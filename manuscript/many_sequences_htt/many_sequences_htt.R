library(ggDNAvis)
library(ggplot2)   ## v4.0.2
library(magick)    ## v2.9.0

## Create metadata dataframe
forward_reads <- readLines("output/05_forward_reads.txt")
reverse_reads <- readLines("output/05_reverse_reads.txt")

metadata <- data.frame(
    read = c(forward_reads, reverse_reads),
    direction = c(rep("forward", length(forward_reads)),
                  rep("reverse", length(reverse_reads)))
)



## Read in and merge with FASTQ
fastq_data <- read_fastq("output/06_final.fastq")
merged_data <- merge_fastq_with_metadata(fastq_data, metadata, reverse_complement_mode = "reverse_only")


## Exclude reads with ambiguous direction
## I don't really know why some are like this, but some get labelled as both forward and reverse
## Don't want to manually fish out correct direction and there's loads of data so just exclude entirely
merged_data <- merged_data[!duplicated(merged_data$read),]

## Exclude reads with length 0
merged_data <- merged_data[merged_data$sequence_length > 0,]




## ALLELE DETERMINATION
## ---------------------------------------------------------------------------------------------
## Histogram to justify allele separation threshold
## Exported to the github folder but not included in paper
threshold <- 138
ggplot(merged_data, aes(x = sequence_length)) +
    geom_histogram(binwidth = 1, center = 0) +
    geom_vline(xintercept = threshold, col = "red", linetype = "dashed") +
    theme_classic() +
    coord_cartesian(expand = FALSE) +
    labs(x = "Clipped HTT read length", y = "Read count")
ggsave("supplementary_htt_allele_separation_histogram.png", dpi = 300, width = 7, height = 5)

## Calculate how many are near threshold
flanking  <- 24
find_codons <- function(x, flanking = 24) {(x - flanking) / 3}
low <- 132
low_mid <- 133
high_mid <- 143
high <- 147
from_36_41 <- sum(merged_data$sequence_length >= low & merged_data$sequence_length <= high)
within_5_bp <- sum(merged_data$sequence_length >= low_mid & merged_data$sequence_length <= high_mid)
window <- find_codons(c(low, low_mid, high_mid, high))

## Summarise threshold information
cat(
    "Allele separation threshold: ", threshold, " bp (> expanded, <= wildtype)\n",
    "Equivalent to ", find_codons(threshold), " repeats with ", flanking, " bp flanking sequence\n",
    "Total reads after filtering: ", nrow(merged_data), "\n",
    "Reads from ", find_codons(low), "-", find_codons(high), " repeats: ", from_36_41, " reads (", round(from_36_41 / nrow(merged_data), 4) * 100, "%)\n",
    "Reads from ", low_mid, "-", high_mid, " bases: ", within_5_bp, " reads (", round(within_5_bp / nrow(merged_data), 4) * 100, "%)", 
    sep = ""
)

## Separate alleles by length
merged_data$allele <- ifelse(merged_data$sequence_length > threshold, "expanded", "wildtype")
## ---------------------------------------------------------------------------------------------





## Randomly subsample to make visualisation size manageable
set.seed(123)
subsampled_data <- merged_data[sample(1:nrow(merged_data), 250, replace = FALSE),]


## Extract, grouping by allele and sorting by length and direction
allele_spacing <- 20
direction_spacing <- 8
sequences <- c(
    ## Initial blank lines - need space for annotations
    rep("", allele_spacing),
    ## Sequences
    extract_and_sort_sequences(
        subsampled_data, 
        sequence_variable = "forward_sequence", 
        grouping_levels = c("allele" = allele_spacing,
                            "direction" = direction_spacing),
        sort_by = "sequence_length",
        desc_sort = TRUE
    )
)

## Calculate top line of each part
blank_lines <- which(sequences == "")
blank_lines_gap <- c(blank_lines[2:length(blank_lines)], 1000) - blank_lines
names(blank_lines_gap) <- blank_lines

last_blanks_before_sequences <- which(blank_lines_gap > 1)
direction_lines <- blank_lines[last_blanks_before_sequences]
allele_lines <- direction_lines[c(1,3)] - direction_spacing

## Visualisation parameters
sequence_colours <- sequence_colour_palettes$bright_deep
margin <- 0.5
width <- max(nchar(sequences)) 
height <- length(sequences)

## Create annotation dataframe
text_data <- data.frame(
    x = margin / width,
    y = 1 - ((c(allele_lines - 0.75, direction_lines - 1.5)) / height),
    label = c("Expanded", "Wildtype", rep(c("Forward (5’–3’)", "Reverse (3’–5’)"), times = 2)),
    size = rep(c(175, 125), times = c(2, 4))
)

visualise_many_sequences(
    sequences,
    sequence_colours = sequence_colours,
    sequence_text_size = 0,
    index_annotation_lines = NA,
    outline_linewidth = 2,
    pixels_per_base = 10,
    margin = margin,
    return = TRUE
) + 
    geom_text(data = text_data, aes(x = x, y = y, label = label, size = size), col = "black", family = "Helvetica Light", hjust = 0, vjust = 0) +
    scale_size_identity()

ggsave(filename = "many_sequences_htt_main.png", dpi = 10, width = width + 2*margin, height = height + 2*margin, device = ragg::agg_png, limitsize = FALSE)
    

## Create key
visualise_single_sequence(
    "ACGT",
    filename = "many_sequences_htt_key.png",
    sequence_colours = sequence_colours,
    sequence_text_colour = "white",
    index_annotation_interval = 0,
    index_annotation_always_first_base = FALSE,
    index_annotation_always_last_base = FALSE,
    pixels_per_base = 150,
    margin = 0.1
)


## Merge images via magick
main <- image_read("many_sequences_htt_main.png", strip = TRUE)
key  <- image_read("many_sequences_htt_key.png", strip = TRUE)

combined <- image_composite(main, key, operator = "over", gravity = "southeast", offset = "+0+0")
image_write(combined, "many_sequences_htt.png", format = "png")
