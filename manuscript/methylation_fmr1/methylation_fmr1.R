library(ggDNAvis)
library(ggplot2)   ## v4.0.1
library(dplyr)     ## v1.2.0
library(purrr)     ## v1.2.1
library(magick)    ## v2.9.0

participant_ids <- c("NA04026", "NA05131", "NA06905", "NA12878")


## READING DATA
## -------------------------------------------------------------------------------------------
## Create metadata based on read ID txts
metadata <- map_df(participant_ids, function(id) {
    forward_reads <- readLines(paste0("output/", id, "/", id, "_05_forward_reads.txt"))
    reverse_reads <- readLines(paste0("output/", id, "/", id, "_05_reverse_reads.txt"))
    
    data.frame(
        participant_id = id,
        read = c(forward_reads, reverse_reads),
        direction = c(rep("forward", length(forward_reads)),
                      rep("reverse", length(reverse_reads)))
    )
})

## Read modified FASTQs
methylation_data <- map_df(participant_ids, function(id) {
    read_modified_fastq(paste0("output/", id, "/", id, "_09_final.fastq"))
})

## Merge
merged_data <- merge_methylation_with_metadata(methylation_data, metadata, reversed_location_offset = 1)

## Combine hydroxymethylation and methylation probabilities
merged_data$total_modification_prob <- sapply(1:nrow(merged_data), function(i) {
    meth <- string_to_vector(merged_data[i, "C+m?_probabilities"])
    hoxy <- string_to_vector(merged_data[i, "C+h?_probabilities"])
    return(vector_to_string(meth + hoxy))
})


## Designate alleles
full_threshold <- 1000
pre_threshold <- 200
merged_data$allele <- sapply(merged_data$sequence_length, function(x) {
    if (x > full_threshold) {
        "Full mutation"
    } else if (x > pre_threshold) {
        "Premutation"
    } else {
        "Wildtype"
    }
})

## Investigate allele distribution
ggplot(data = merged_data, aes(x = sequence_length)) +
    geom_histogram(binwidth = 5) +
    theme_classic() +
    geom_vline(xintercept = c(full_threshold, pre_threshold), col = "red", linetype = "dashed", linewidth = 1) +
    scale_x_continuous(breaks = seq(0, 2500, 200)) +
    labs(x = "Clipped FMR1 read length", y = "Number of reads") +
    coord_cartesian(expand = FALSE)
## -------------------------------------------------------------------------------------------





## ALLELE FIGURE
## -------------------------------------------------------------------------------------------
## Extract modification info from dataframe, using combined probability column
allele_spacing <- 30
participant_spacing <- 8

vis_input <- extract_and_sort_methylation(
    merged_data,
    locations_colname = "C+m?_locations",
    probabilities_colname = "total_modification_prob",
    sequences_colname = "sequence",
    lengths_colname = "sequence_length",
    grouping_levels = c("allele" = allele_spacing,
                        "participant_id" = participant_spacing)
)
vis_input <- lapply(vis_input, function(vec) {c(rep("", allele_spacing), vec)})


## Calculate which lines need to have titles added
blank_lines <- which(vis_input$sequences == "")
blank_lines_gap <- c(blank_lines[2:length(blank_lines)], 1000) - blank_lines
names(blank_lines_gap) <- blank_lines

last_blanks_before_sequences <- which(blank_lines_gap > 1)
participant_lines <- blank_lines[last_blanks_before_sequences]
allele_lines <- participant_lines[c(1,3,4)] - participant_spacing

## Visualisation parameters
margin <- 0.5
width <- max(nchar(vis_input$sequences)) 
height <- length(vis_input$sequences)
pixels_per_base <- 20


## Create annotation dataframe
text_data <- data.frame(
    x = margin / width,
    y = 1 - ((c(10, allele_lines - 0.75, participant_lines - 1.5)) / height),
    label = c("(a) Blue/red gradient",
              c("Full mutation (truncated)", "Premutation", "Wildtype"),
              c("NA04026", "NA05131", "NA06905", "NA05131", "NA06905", "NA12878")),
    size = c(225, rep(c(175, 125), times = c(3, 6)))
)
text_data_binary <- text_data
text_data_binary[1, "label"] <- "(b) White/black binary"

## Create smooth/gradient visualisation
visualise_methylation(
    vis_input$locations,
    vis_input$probabilities,
    vis_input$sequences,
    sequence_text_type = "none",
    index_annotation_lines = NA,
    margin = margin
) +
    geom_text(data = text_data, aes(x = x, y = y, label = label, size = size), col = "black", family = "Helvetica Light", hjust = 0, vjust = 0) +
    scale_size_identity()
ggsave(filename = "methylation_fmr1_alleles_smooth.png", dpi = pixels_per_base, width = width + 2*margin, height = height + 2*margin, device = ragg::agg_png, limitsize = FALSE)

## Create binary visualisation
visualise_methylation(
    vis_input$locations,
    vis_input$probabilities,
    vis_input$sequences,
    sequence_text_type = "none",
    low_colour = "white",
    high_colour = "black",
    low_clamp = 127,
    high_clamp = 128,
    other_bases_colour = "lightblue2",
    other_bases_outline_colour = "grey",
    other_bases_outline_linewidth = 1,
    index_annotation_lines = NA,
    margin = margin
) +
    geom_text(data = text_data_binary, aes(x = x, y = y, label = label, size = size), col = "black", family = "Helvetica Light", hjust = 0, vjust = 0) +
    scale_size_identity()
ggsave(filename = "methylation_fmr1_alleles_binary.png", dpi = pixels_per_base, width = width + 2*margin, height = height + 2*margin, device = ragg::agg_png, limitsize = FALSE)


## Create scalebars
x_axis_title = "Combined methylation + hydroxymethylation probability"
dpi <- pixels_per_base * 20
scalebar_width <- 4.7
scalebar_height <- 1.25
visualise_methylation_colour_scale(
    low_colour = "blue",
    high_colour = "red",
    low_clamp = 0,
    high_clamp = 255,
    precision = 10^3,
    x_axis_title = x_axis_title
) +
    theme(axis.title = element_text(family = "Helvetica Light"))
ggsave(filename = "methylation_fmr1_alleles_smooth_scalebar.png", dpi = dpi, width = scalebar_width, height = scalebar_height, device = ragg::agg_png)

visualise_methylation_colour_scale(
    low_colour = "white",
    high_colour = "black",
    low_clamp = 127,
    high_clamp = 128,
    precision = 256,
    x_axis_title = x_axis_title
) +
    theme(axis.title = element_text(family = "Helvetica Light"))
ggsave(filename = "methylation_fmr1_alleles_binary_scalebar.png", dpi = dpi, width = scalebar_width, height = scalebar_height, device = ragg::agg_png)



## Composite images using magick
## Create pure white image to layer onto
max_premutation_width <- merged_data %>%
    filter(allele == "Premutation") %>%
    pull(sequence_length) %>%
    max()
right_padding <- 20  ## in bases
v_separation <- 20 ## in bases
composite_px_width <- pixels_per_base * (max_premutation_width + 2*margin + right_padding)
composite_px_height <- pixels_per_base * (2 * (height + 2*margin) + v_separation)
ggplot() + theme_classic()
ggsave("methylation_fmr1_alleles_canvas.png", dpi = 1, width = composite_px_width, height = composite_px_height, limitsize = FALSE)

## Calculations for scalebar placements
single_part_height <- pixels_per_base * (height + 2*margin + v_separation)
scalebar_from_bottom <- pixels_per_base * 5
scalebar_from_right <- pixels_per_base * 5

canvas <- image_read("methylation_fmr1_alleles_canvas.png", strip = TRUE)
smooth <- image_read("methylation_fmr1_alleles_smooth.png", strip = TRUE)
binary <- image_read("methylation_fmr1_alleles_binary.png", strip = TRUE)
smooth_scalebar <- image_read("methylation_fmr1_alleles_smooth_scalebar.png", strip = TRUE)
binary_scalebar <- image_read("methylation_fmr1_alleles_binary_scalebar.png", strip = TRUE)

## Merge in main visualisations
composite <- image_composite(canvas, smooth, operator = "over", gravity = "northwest", offset = "+0+0")
composite <- image_composite(composite, binary, operator = "over", gravity = "southwest", offset = "+0+0")

## Merge in scalebars
composite <- image_composite(composite, smooth_scalebar, operator = "over", gravity = "southeast", 
                             offset = paste0("+", scalebar_from_right, "+", single_part_height+scalebar_from_bottom))
composite <- image_composite(composite, binary_scalebar, operator = "over", gravity = "southeast", 
                             offset = paste0("+", scalebar_from_right, "+", scalebar_from_bottom))

## Write final figure
image_write(composite, "methylation_fmr1_alleles.png", format = "png")
## -------------------------------------------------------------------------------------------





## TEXT FIGURE
## -------------------------------------------------------------------------------------------
## todo - wildtype alleles only, show seq/int/prob text types
## -------------------------------------------------------------------------------------------
