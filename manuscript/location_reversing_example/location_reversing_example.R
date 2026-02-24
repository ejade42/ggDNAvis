library(ggDNAvis)  ## v1.0.0
library(dplyr)     ## v1.1.4
library(ggplot2)   ## v4.0.1

## Create random methylation probabilities
set.seed(1234)
random_probabilities <- sample(0:255, size = 12, replace = TRUE)

## Set up original dataframe with reads always 5’-3’
location_reversing_example <- data.frame(
    read = c("example_f", "example_r"),
    sequence = c("GGCGGCGGCGGCGGAGGAGGCGGCGGAGGAA", "TTCCTCCGCCGCCTCCTCCGCCGCCGCCGCC"),
    quality  = rep("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB", 2),
    sequence_length = rep(31, 2),
    modification_types = rep("methylation", 2),
    methylation_locations = c("3,6,9,12,21,24", "7,10,19,22,25,28"),
    methylation_probabilities = c(vector_to_string(random_probabilities[1:6]), vector_to_string(random_probabilities[7:12]))
)

## Set up metadata
location_reversing_metadata <- data.frame(
    read = c("example_f", "example_r"),
    direction = c("forward", "reverse")
)

## Create new dataframes with various reversal settings and save all to list
## Use c(list(original_dataframe), new_list) to make list of original then the three new ones
offsets <- c(0, 0, 1)
modes <- c("reverse_only", "DNA", "DNA")
dataframes <- c(list(location_reversing_example), lapply(seq_along(offsets), function(i) {
    reversed_data <- merge_methylation_with_metadata(
        location_reversing_example,
        location_reversing_metadata,
        reversed_location_offset = offsets[i],
        reverse_complement_mode = modes[i]
    )

    ## Overwrite "sequence" with "forward_sequence" etc in the returned dataframe
    ## This means "sequence" will hold the original sequences for the original dataframe,
    ## but hold the reversed/forwardified sequences for the following three dataframes
    reversed_data$sequence = reversed_data$forward_sequence
    reversed_data$methylation_locations = reversed_data$forward_methylation_locations
    reversed_data$methylation_probabilities = reversed_data$forward_methylation_probabilities

    return(reversed_data)
}))

## Extract locations/probabilities/sequences vectors from each dataframe
## Because of the overwriting at the previous step, "sequence", "modification_locations" etc
## hold the original values for the first (unmodified) dataset, but the forward-ified versions
## for the three later datasets
vectors_for_plotting <- lapply(dataframes, function(x) {
    extract_methylation_from_dataframe(
        x,
        locations_colname = "methylation_locations",
        probabilities_colname = "methylation_probabilities",
        sequences_colname = "sequence",
        lengths_colname = "sequence_length",
        grouping_levels = NA,
        sort_by = NA
    )
})

## Merge vectors across dataframes, with padding in between to visually separate the examples
blanks <- 3
input <- lapply(c("locations", "probabilities", "sequences"), function(x) {
    lapply(vectors_for_plotting, function(y) c(y[[x]], rep("", blanks))) %>%
        unlist() %>%
        head(-blanks) %>%
        c("", .)
})



## Calculate the tile width and height that we will end up with
lines_to_annotate <- 0:3*blanks + 1:4*2
margin = 0.5

k <- max(nchar(input[[3]]))
n <- length(input[[3]]) + length(lines_to_annotate)

## Create dataframe for titles
titles <- data.frame(
    text = c("(a) Original sequences, both 5’–3’ (e.g. original reads):",
             "(b) Reversed to be 3’–5’, offset 0:",
             "(c) Reverse-complemented to 5’–3’ of other strand, offset 0:",
             "(d) Reverse-complemented to 5’–3’ of other strand, offset 1:"),
    lines = lines_to_annotate - 1,
    x = 0
)
titles$y = 1 - (titles$lines - 0.66) / length(input[[1]])

## Create dataframe for 1 extra tile on each edge
## and for 5’ and 3’ direction indicators
lines_for_tiles <- sort(
    rep(seq_along(lines_to_annotate) + lines_to_annotate - 2, times = 2) +
    rep(0:1, each = length(lines_to_annotate)),
    decreasing = TRUE
)
directions <- data.frame(
    x = rep(c(-0.5, k+0.5) / k, each = length(lines_for_tiles)),
    y = rep((lines_for_tiles - 0.5 ) / n, times = 2),
    width = 1 / k,
    height = 1 / n,
    text = c(rep("5’", 2), "5’", "3’", rep("5’", 4),
             rep("3’", 2), "3’", "5’", rep("3’", 4))
)

## Create visualisation
visualise_methylation(
    input[[1]],
    input[[2]],
    input[[3]],
    index_annotation_lines = lines_to_annotate,
    index_annotation_interval = 6,
    index_annotation_always_first_base = FALSE,
    index_annotation_always_last_base = FALSE,
    other_bases_outline_linewidth = 1,
    other_bases_outline_colour = "darkgrey",
    sequence_text_type = "sequence",
    low_clamp = 255*0.4,
    high_clamp = 255*0.6,
    margin = margin
) +
    ## Add titles and 5’/3’ directions
    geom_tile(data = directions, aes(x = x, y = y, width = width, height = height), fill = alpha("white", 0), linewidth = 0) +
    geom_text(data = directions, aes(x = x, y = y, label = text), size = 15, col = "darkred", fontface = "bold") +
    geom_text(data = titles, aes(x = x, y = y, label = text), hjust = 0, size = 16, family = "Helvetica Light")


## Save visualisation
ggsave(
    "location_reversing_example.png",
    dpi = 100,
    ## k is the width in bases of the original visualisation
    ## We added 2 new squares, and need to account for the margin
    width = k + 2 + 2*margin,
    ## n is the height in bases of the original visualisation
    ## We didn't add any new lines, but still need to account for the margin
    height = n + 2*margin,
    device = ragg::agg_png
)

