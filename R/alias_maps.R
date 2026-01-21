.alias_maps <- function() {
    list(
        ## parse_methylation_from_fastq.R
        write_fastq = list(
            sequence_colname = list(default = "sequence", aliases = c("sequences_colname")),
            quality_colname = list(default = "quality", aliases = c("qualities_colname"))
        ),

        write_modified_fastq = list(
            sequence_colname = list(default = "sequence", aliases = c("sequences_colname")),
            quality_colname = list(default = "quality", aliases = c("qualities_colname")),
            locations_colnames = list(default = c("hydroxymethylation_locations", "methylation_locations"), aliases = c("location_colnames")),
            probabilities_colnames = list(default = c("hydroxymethylation_probabilities", "methylation_probabilities"), aliases = c("probability_colnames"))
        ),


        ## visualise_many_sequences.R
        visualise_many_sequences = list(
            sequence_colours = list(default = sequence_colour_palettes$ggplot_style, aliases = c("sequence_colors", "sequence_cols")),
            background_colour = list(default = "white", aliases = c("background_color", "background_col")),
            sequence_text_colour = list(default = "black", aliases = c("sequence_text_color", "sequence_text_col")),
            index_annotation_colour = list(default = "darkred", aliases = c("index_annotation_color", "index_annotation_col")),
            outline_colour = list(default = "black", aliases = c("outline_color", "outline_col")),
            index_annotations_above = list(default = TRUE, aliases = c("index_annotation_above")),
            index_annotation_full_line = list(default = TRUE, aliases = c("index_annotations_full_line", "index_annotations_full_lines", "index_annotation_full_lines")),
            index_annotation_always_first_base = list(default = TRUE, aliases = c("index_annotations_always_first_base")),
            index_annotation_always_last_base = list(default = TRUE, aliases = c("index_annotations_always_last_base"))
        ),


        ## visualise_methylation.R
        visualise_methylation = list(
            low_colour = list(default = "blue", aliases = c("low_color", "low_col")),
            high_colour = list(default = "red", aliases = c("high_color", "high_col")),
            background_colour = list(default = "white", aliases = c("background_color", "background_col")),
            other_bases_colour = list(default = "grey", aliases = c("other_bases_color", "other_bases_col")),
            sequence_text_colour = list(default = "black", aliases = c("sequence_text_color", "sequence_text_col")),
            index_annotation_colour = list(default = "darkred", aliases = c("index_annotation_color", "index_annotation_col")),
            outline_colour = list(default = "black", aliases = c("outline_color", "outline_col")),
            modified_bases_outline_colour = list(default = NA, aliases = c("modified_bases_outline_color", "modified_bases_outline_col")),
            other_bases_outline_colour = list(default = NA, aliases = c("other_bases_outline_color", "other_bases_outline_col")),
            index_annotations_above = list(default = TRUE, aliases = c("index_annotation_above")),
            index_annotation_full_line = list(default = TRUE, aliases = c("index_annotations_full_line", "index_annotations_full_lines", "index_annotation_full_lines")),
            index_annotation_always_first_base = list(default = TRUE, aliases = c("index_annotations_always_first_base")),
            index_annotation_always_last_base = list(default = TRUE, aliases = c("index_annotations_always_last_base"))
        ),

        visualise_methylation_colour_scale = list(
            low_colour = list(default = "blue", aliases = c("low_color", "low_col")),
            high_colour = list(default = "red", aliases = c("high_color", "high_col")),
            background_colour = list(default = "white", aliases = c("background_color", "background_col")),
            outline_colour = list(default = "black", aliases = c("outline_color", "outline_col"))
        ),

        extract_and_sort_methylation = list(
            sequences_colname = list(default = "sequence", aliases = c("sequence_colname")),
            locations_colname = list(default = "methylation_locations", aliases = c("location_colname")),
            probabilities_colname = list(default = "methylation_probabilities", aliases = c("probability_colname")),
            lengths_colname = list(default = "sequence_length", aliases = c("length_colname"))
        ),


        ## visualise_single_sequence.R
        visualise_single_sequence = list(
            sequence_colours = list(default = sequence_colour_palettes$ggplot_style, aliases = c("sequence_colors", "sequence_cols")),
            background_colour = list(default = "white", aliases = c("background_color", "background_col")),
            sequence_text_colour = list(default = "black", aliases = c("sequence_text_color", "sequence_text_col")),
            index_annotation_colour = list(default = "darkred", aliases = c("index_annotation_color", "index_annotation_col")),
            outline_colour = list(default = "black", aliases = c("outline_color", "outline_col")),
            index_annotations_above = list(default = TRUE, aliases = c("index_annotation_above")),
            index_annotation_always_first_base = list(default = TRUE, aliases = c("index_annotations_always_first_base")),
            index_annotation_always_last_base = list(default = TRUE, aliases = c("index_annotations_always_last_base"))
        )
    )
}
