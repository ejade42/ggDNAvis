root <- "test_plot_images/"
reference <- "reference_images/"
acceptable_distortion <- fetch_acceptable_distortion(verbose = FALSE)


test_that("methylation visualisation works as expected, all defaults", {
    filename <- "visualise_methylation_test_01"
    locations     <- extract_and_sort_sequences(example_many_sequences, sequence_variable = "methylation_locations")
    probabilities <- extract_and_sort_sequences(example_many_sequences, sequence_variable = "methylation_probabilities")
    sequences <- extract_and_sort_sequences(example_many_sequences, sequence_variable = "sequence")
    expect_message(visualize_methylation(locations, probabilities, sequences, filename = paste0(root, filename, ".png"), index_annotation_lines = NA, outline_linewidth = 0, pixels_per_base = 10))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, ascending sort, via extract_methylation_from_dataframe", {
    filename <- "visualise_methylation_test_02"
    d <- extract_methylation_from_dataframe(example_many_sequences, desc_sort = FALSE)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), index_annotation_lines = NULL, outline_linewidth = 0, pixels_per_base = 10))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, wacky colours", {
    filename <- "visualise_methylation_test_03"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = c("individual" = 2), sort_by = NA)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), background_colour = "pink", index_annotation_lines = numeric(), other_bases_colour = "lightblue", low_colour = "white", high_colour = "black", margin = 1, outline_linewidth = 0, pixels_per_base = 10))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)

    filename <- "visualise_methylation_scalebar_test_03"
    visualize_methylation_color_scale(background_col = "pink", low_color = "white", high_colour = "black")
    ggsave(paste0(root, filename, ".png"), dpi = 200, device = ragg::agg_png, width = 6, height = 1.5)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, hard clamping", {
    filename <- "visualise_methylation_test_04"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = NA, sort_by = NA)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), low_clamp = 108, high_clamp = 148, index_annotation_lines = numeric(), margin = 0, outline_linewidth = 0, pixels_per_base = 10))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)

    filename <- "visualise_methylation_scalebar_test_04"
    visualise_methylation_colour_scale(low_clamp = 108, high_clamp = 148, x_axis_title = NA, side_scale_title = NA)
    ggsave(paste0(root, filename, ".png"), dpi = 200, device = ragg::agg_png, width = 6, height = 1.5)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with all individuals merged, mild clamping", {
    filename <- "visualise_methylation_test_05"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = NA)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), low_clamp = 50, high_clamp = 200, index_annotation_lines = numeric(), margin = 1.5, outline_linewidth = 0, pixels_per_base = 10))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)

    filename <- "visualise_methylation_scalebar_test_05"
    visualise_methylation_colour_scale(low_clamp = 50, high_clamp = 200, precision = 20, x_axis_title = "probability", do_x_ticks = FALSE, do_side_scale = TRUE, side_scale_title = "raw probability")
    ggsave(paste0(root, filename, ".png"), dpi = 200, device = ragg::agg_png, width = 6, height = 1.5)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with unified outlines", {
    filename <- "visualise_methylation_test_06"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), pixels_per_base = 10, index_annotation_lines = NA)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with differing outlines", {
    filename <- "visualise_methylation_test_07"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), other_bases_outline_color = "green", index_annotation_interval = 0, modified_bases_outline_col = "orange", pixels_per_base = 10))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with differing outlines", {
    filename <- "visualise_methylation_test_08"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), other_bases_outline_linewidth = 0, index_annotation_size = 0, pixels_per_base = 10))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with index annotations", {
    filename <- "visualise_methylation_test_09"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), index_annotation_lines = c(1, 10, 37, 51, 51), other_bases_outline_linewidth = 0, pixels_per_base = 30))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with index annotations below", {
    filename <- "visualise_methylation_test_10"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_message(expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), index_annotation_lines = c(1, 10, 51, 37, 37), index_annotations_above = FALSE, other_bases_outline_linewidth = 0, pixels_per_base = 30)))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with index annotations, big", {
    filename <- "visualise_methylation_test_11"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), index_annotation_lines = c(1, 37, 10, 51), index_annotation_vertical_position = 4/3, index_annotation_size = 20, index_annotation_colour = "magenta", index_annotation_interval = 7, index_annotations_full_line = FALSE, background_colour = "orange", margin = 1.5, other_bases_outline_linewidth = 0, pixels_per_base = 30))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with index annotations, big, below", {
    filename <- "visualise_methylation_test_12"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), index_annotation_lines = c(1, 10, 37, 51), index_annotation_vertical_position = 4/3, index_annotation_size = 20, index_annotations_above = FALSE, index_annotation_colour = "magenta", index_annotation_interval = 7, index_annotation_full_lines = FALSE, background_colour = "orange", margin = 1.5, other_bases_outline_linewidth = 0, pixels_per_base = 30)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with index annotations, default", {
    filename <- "visualise_methylation_test_13"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_message(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), high_colour = "magenta", low_colour = "cyan", sequence_text_type = "sequence", sequence_text_size = 0, other_bases_color = "orange", other_bases_outline_linewidth = 0, pixels_per_base = 30))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with sequence, default", {
    filename <- "visualise_methylation_test_14"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), sequence_text_type = "sequence", pixels_per_base = 15)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with sequence, fancy", {
    filename <- "visualise_methylation_test_15"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), sequence_text_type = "sequence", sequence_text_color = "magenta", sequence_text_size = 20, index_annotation_interval = 5, index_annotation_full_line = TRUE, index_annotation_lines = c(1, 23, 37), pixels_per_base = 15)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with scaled probabilities, default", {
    filename <- "visualise_methylation_test_16"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), sequence_text_type = "probability", sequence_text_size = 10, sequence_text_col = "white", other_bases_outline_linewidth = 0, index_annotation_lines = c(1, 23, 37), pixels_per_base = 15)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with scaled probabilities, integer", {
    filename <- "visualise_methylation_test_17"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), sequence_text_type = "probability", sequence_text_scaling = c(0, 1), sequence_text_rounding = 0, sequence_text_size = 10, sequence_text_colour = "white", other_bases_outline_linewidth = 0, index_annotation_lines = c(1, 23, 37), pixels_per_base = 15)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with scaled probabilities, warning", {
    filename <- "visualise_methylation_test_18"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_warning(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), sequence_text_type = "probability", sequence_text_scaling = c(0, 255), sequence_text_rounding = 1, sequence_text_size = 10, sequence_text_colour = "white", other_bases_outline_linewidth = 0, index_annotation_lines = c(1, 23, 37), pixels_per_base = 15),
                   class = "unrecommended_argument")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with scaled probabilities, default size warning", {
    filename <- "visualise_methylation_test_19"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_warning(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), sequence_text_type = "probability", sequence_text_colour = "white", other_bases_outline_linewidth = 0, index_annotation_lines = c(1, 23, 37), pixels_per_base = 15),
                   class = "default_text_too_large_for_prob")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing rasterisation works and produces a warning", {
    filename <- "visualise_methylation_test_20"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    expect_warning(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = paste0(root, filename, ".png"), sequence_text_type = "sequence", force_raster = TRUE, low_colour = "white", high_colour = "black", other_bases_colour = "lightblue1", background_colour = "orange", margin = 2, pixels_per_base = 10),
                   class = "raster_is_forced")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})


test_that("argument validation rejects bad arguments for methylation visualisation", {
    d <- extract_methylation_from_dataframe(example_many_sequences)

    bad_param_value_for_single_character <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), NA, c(NA, NA), NULL)
    for (param in bad_param_value_for_single_character) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, background_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, other_bases_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, low_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, high_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, outline_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, outline_join = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, index_annotation_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, sequence_text_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, sequence_text_type = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_character_na_allowed <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), c(NA, NA), NULL)
    for (param in bad_param_value_for_single_character_na_allowed) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, modified_bases_outline_join = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, other_bases_outline_join = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, modified_bases_outline_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, other_bases_outline_colour = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_numeric <- list("x", TRUE, FALSE, NA, NULL, c(1, 2))
    for (param in bad_param_value_for_single_numeric) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, low_clamp = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, high_clamp = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, margin = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, outline_linewidth = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, index_annotation_size = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, index_annotation_vertical_position = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, sequence_text_size = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_int <- list("x", TRUE, FALSE, NA, NULL, c(1, 2), 0.5, -1)
    for (param in bad_param_value_for_single_int) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, pixels_per_base = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, index_annotation_interval = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, sequence_text_rounding = param), class = "argument_value_or_type")

    }

    bad_param_value_for_num_vec <- list("x", TRUE, FALSE, NA, NULL)
    for (param in bad_param_value_for_num_vec) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, sequence_text_scaling = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_numeric_na_allowed <- list("x", TRUE, FALSE, NULL, c(1, 2))
    for (param in bad_param_value_for_single_numeric_na_allowed) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, modified_bases_outline_linewidth = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, other_bases_outline_linewidth = param), class = "argument_value_or_type")
    }

    bad_param_value_for_index_annotation_lines <- list("x", TRUE, FALSE, c(1, -1), c(1, 0), c(1, 1.5))
    for (param in bad_param_value_for_index_annotation_lines) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, index_annotation_lines = param), class = "argument_value_or_type")
    }

    bad_param_value_for_logical <- list(1, 1.5, -1, "hi", c(TRUE, FALSE), NA, NULL)
    for (param in bad_param_value_for_logical) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, return = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, index_annotations_above = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, index_annotation_full_line = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, force_raster = param), class = "argument_value_or_type")
    }

    bad_param_value_for_filename <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), c(NA, NA), NULL)
    for (param in bad_param_value_for_filename) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, filename = param), class = "argument_value_or_type")
    }

    expect_error(visualise_methylation(d$locations, d$probabilities, d$sequences, sequence_text_type = "hola"), class = "argument_value_or_type")
    expect_error(visualise_methylation(c("3,6,9", "3,6,9,12"), c("25,48,60"), c(30, 40)), class = "argument_value_or_type")
    expect_error(visualise_methylation("3,6,9", "100,200,0", 12, low_clamp = 200, high_clamp = 200), class = "argument_value_or_type")
    expect_error(visualise_methylation("3,6,9", "100,200,0", 12, low_clamp = 200, high_clamp = 190), class = "argument_value_or_type")
    expect_error(visualise_methylation_colour_scale(low_clamp = 200, high_clamp = 200), class = "argument_value_or_type")
    expect_error(visualise_methylation_colour_scale(low_clamp = 200, high_clamp = 190), class = "argument_value_or_type")
})




test_that("argument validation rejects bad arguments for methylation scalebar", {
    bad_param_value_for_single_character <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), NA, c(NA, NA), NULL)
    for (param in bad_param_value_for_single_character) {
        expect_error(visualise_methylation_colour_scale(low_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation_colour_scale(high_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation_colour_scale(background_colour = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_numeric <- list("x", TRUE, FALSE, NA, NULL, c(1, 2))
    for (param in bad_param_value_for_single_numeric) {
        expect_error(visualise_methylation_colour_scale(low_clamp = param), class = "argument_value_or_type")
        expect_error(visualise_methylation_colour_scale(high_clamp = param), class = "argument_value_or_type")
        expect_error(visualise_methylation_colour_scale(precision = param), class = "argument_value_or_type")
    }

    bad_param_value_for_optional_axis_title <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), c(NA, NA))
    for (param in bad_param_value_for_optional_axis_title) {
        expect_error(visualise_methylation_colour_scale(x_axis_title = param), class = "argument_value_or_type")
        expect_error(visualise_methylation_colour_scale(side_scale_title = param), class = "argument_value_or_type")
    }
})



## Testing for extraction of methylation information from dataframe is covered in testing of extract_and_sort_sequences().




test_that("argument validation rejects bad arguments for converting modification to number vector", {
    bad_param_value_for_modification <- list(c(3,6,9), TRUE, NA, NULL, 0, -1)
    for (param in bad_param_value_for_modification) {
        expect_error(convert_modification_to_number_vector(modification_locations_str = param, modification_probabilities_str = "3,6,9", max_length = 20, sequence_length = 15))
        expect_error(convert_modification_to_number_vector(modification_locations_str = "3,6,9", modification_probabilities_str = param, max_length = 20, sequence_length = 15))
    }

    bad_param_value_for_modification_warn <- list("3. 6. 9", "x")
    for (param in bad_param_value_for_modification_warn) {
        expect_warning(expect_error(convert_modification_to_number_vector(modification_locations_str = param, modification_probabilities_str = "3,6,9", max_length = 20, sequence_length = 15)))
        expect_warning(expect_error(convert_modification_to_number_vector(modification_locations_str = "3,6,9", modification_probabilities_str = param, max_length = 20, sequence_length = 15)))
    }

    bad_param_value_for_non_negative_int <- list(1.5, -1, c(2, 3), TRUE, FALSE, NA, NULL, "x")
    for (param in bad_param_value_for_non_negative_int) {
        expect_error(convert_modification_to_number_vector(modification_locations = "3,6,9", modification_probabilities = "3,6,9", max_length = param, sequence_length = 15))
        expect_error(convert_modification_to_number_vector(modification_locations = "3,6,9", modification_probabilities = "3,6,9", max_length = 15, sequence_length = param))
    }
})



test_that("creating probabilities data works", {
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = NA)
    expect_equal(convert_probabilities_to_annotations(d$locations, d$probabilities, d$sequences, sequence_text_scaling = c(0, 1), sequence_text_rounding = 0)[1:10,],
                 data.frame(x_position = c(0.0245098039215686, 0.053921568627451, 0.0833333333333333, 0.112745098039216, 0.142156862745098, 0.17156862745098, 0.200980392156863, 0.230392156862745, 0.259803921568627, 0.348039215686274),
                            y_position = c(0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217),
                            annotation = c("29", "159", "155", "159", "220", "163", "2", "59", "170", "131"),
                            type = c("Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability")))

    expect_equal(convert_probabilities_to_annotations(d$locations, d$probabilities, d$sequences, sequence_text_scaling = c(-0.5, 256), sequence_text_rounding = 3)[10:20,],
                 data.frame(x_position = c(0.348039215686274, 0.377450980392157, 0.406862745098039, 0.495098039215686, 0.524509803921569, 0.553921568627451, 0.642156862745098, 0.67156862745098, 0.700980392156863, 0.78921568627451, 0.818627450980392),
                            y_position = c(0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217, 0.978260869565217),
                            annotation = c("0.514", "0.693", "0.545", "0.283", "0.920", "0.295", "0.838", "0.287", "0.268", "0.189", "0.232"),
                            type = c("Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability", "Probability"),
                            row.names = 10:20))
})

test_that("creating probabilities data rejects bad arguments", {
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = NA)

    bad_param_value_for_char_vector <- c(TRUE, NA, NULL, 6, -1, 0.5, c(1, 2))
    for (param in bad_param_value_for_char_vector) {
        expect_error(convert_probabilities_to_annotations(param, d$probabilities, d$sequences), class = "argument_value_or_type")
        expect_error(convert_probabilities_to_annotations(d$locations, param, d$sequences), class = "argument_value_or_type")
        expect_error(convert_probabilities_to_annotations(d$locations, d$probabilities, param), class = "argument_value_or_type")
    }

    bad_param_value_for_string_to_vector <- c("x", c("x", "y"))
    for (param in bad_param_value_for_string_to_vector) {
        expect_warning(expect_error(convert_probabilities_to_annotations(param, d$probabilities, d$sequences), class = "argument_value_or_type"))
        expect_warning(expect_error(convert_probabilities_to_annotations(d$locations, param, d$sequences), class = "argument_value_or_type"))
    }

    bad_param_value_for_num <- c(TRUE, NA, NULL, "X", c(1, 2, 3))
    for (param in bad_param_value_for_num) {
        expect_error(convert_probabilities_to_annotations(d$locations, d$probabilities, d$sequences, sequence_text_rounding = param), class = "argument_value_or_type")
        expect_error(convert_probabilities_to_annotations(d$locations, d$probabilities, d$sequences, sequence_text_scaling = param), class = "argument_value_or_type")
    }
})
