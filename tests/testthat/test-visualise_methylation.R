root <- "test_plot_images/"
reference <- "reference_images/"
acceptable_distortion <- fetch_acceptable_distortion(verbose = FALSE)


test_that("methylation visualisation works as expected, all defaults", {
    filename <- "visualise_methylation_test_01"
    locations     <- extract_and_sort_sequences(example_many_sequences, sequence_variable = "methylation_locations")
    probabilities <- extract_and_sort_sequences(example_many_sequences, sequence_variable = "methylation_probabilities")
    lengths <- as.numeric(extract_and_sort_sequences(example_many_sequences, sequence_variable = "sequence_length")) %>% replace_na(0)
    visualise_methylation(locations, probabilities, lengths, filename = paste0(root, filename, ".png"), outline_linewidth = 0, pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, ascending sort, via extract_methylation_from_dataframe", {
    filename <- "visualise_methylation_test_02"
    d <- extract_methylation_from_dataframe(example_many_sequences, desc_sort = FALSE)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), outline_linewidth = 0, pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, wacky colours", {
    filename <- "visualise_methylation_test_03"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = c("individual" = 2), sort_by = NA)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), background_colour = "pink", other_bases_colour = "lightblue", low_colour = "white", high_colour = "black", margin = 1, outline_linewidth = 0, pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)

    filename <- "visualise_methylation_scalebar_test_03"
    visualise_methylation_colour_scale(background_colour = "pink", low_colour = "white", high_colour = "black")
    ggsave(paste0(root, filename, ".png"), dpi = 200, device = ragg::agg_png, width = 6, height = 1.5)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, hard clamping", {
    filename <- "visualise_methylation_test_04"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), low_clamp = 108, high_clamp = 148, margin = 0, outline_linewidth = 0, pixels_per_base = 10)
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
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), low_clamp = 50, high_clamp = 200, margin = 1.5, outline_linewidth = 0, pixels_per_base = 10)
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
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with differing outlines", {
    filename <- "visualise_methylation_test_07"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), other_bases_outline_colour = "green", modified_bases_outline_colour = "orange", pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with differing outlines", {
    filename <- "visualise_methylation_test_08"
    d <- extract_methylation_from_dataframe(example_many_sequences)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), other_bases_outline_linewidth = 0, pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})




test_that("argument validation rejects bad arguments for methylation visualisation", {
    d <- extract_methylation_from_dataframe(example_many_sequences)

    bad_param_value_for_single_character <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), NA, c(NA, NA), NULL)
    for (param in bad_param_value_for_single_character) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, background_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, other_bases_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, low_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, high_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, outline_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, outline_join = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_character_na_allowed <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), c(NA, NA), NULL)
    for (param in bad_param_value_for_single_character_na_allowed) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, modified_bases_outline_join = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, other_bases_outline_join = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, modified_bases_outline_colour = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, other_bases_outline_colour = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_numeric <- list("x", TRUE, FALSE, NA, NULL, c(1, 2))
    for (param in bad_param_value_for_single_numeric) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, low_clamp = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, high_clamp = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, margin = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, pixels_per_base = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, outline_linewidth = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_numeric_na_allowed <- list("x", TRUE, FALSE, NULL, c(1, 2))
    for (param in bad_param_value_for_single_numeric_na_allowed) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, modified_bases_outline_linewidth = param), class = "argument_value_or_type")
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, other_bases_outline_linewidth = param), class = "argument_value_or_type")
    }

    bad_param_value_for_logical <- list(1, 1.5, -1, "hi", c(TRUE, FALSE), NA, NULL)
    for (param in bad_param_value_for_logical) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, return = param), class = "argument_value_or_type")
    }

    bad_param_value_for_filename <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), c(NA, NA), NULL)
    for (param in bad_param_value_for_filename) {
        expect_error(visualise_methylation(d$locations, d$probabilities, d$lengths, filename = param), class = "argument_value_or_type")
    }

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

