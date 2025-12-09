## Test whether the main plotting function works as expected
root <- "test_plot_images/"
reference <- "reference_images/"
acceptable_distortion <- fetch_acceptable_distortion()


sequence_vector_1 <- c("GGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGC",
                       "GGCGGCGGCGGCGGTGGUGGCGGCGGTGGTGGCGGC",
                       "",
                       "GGCGGCGGCGGCGGAGGC",
                       "GGCGGCGGCGGCGGCGGC")

test_that("main plotting function works in basic case", {
    filename <- "visualise_many_sequences_test_01"
    expect_message(visualize_many_sequences(sequence_vector_1, outline_linewidth = 0, index_annotation_lines = NA, margin = 0, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with margin", {
    filename <- "visualise_many_sequences_test_02"
    expect_message(visualise_many_sequences(sequence_vector_1, sequence_cols = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, index_annotation_lines = NULL, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with double margin", {
    filename <- "visualise_many_sequences_test_03"
    expect_message(visualise_many_sequences(sequence_vector_1, sequence_colors = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, index_annotation_lines = numeric(), margin = 2, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with text turned on", {
    filename <- "visualise_many_sequences_test_04"
    visualise_many_sequences(sequence_vector_1, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, index_annotation_lines = NA, pixels_per_base = 30, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with family data, unsorted/unseparated, no margin + text off", {
    filename <- "visualise_many_sequences_test_05"
    expect_message(visualise_many_sequences(example_many_sequences$sequence, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, index_annotation_lines = NA, pixels_per_base = 10, margin = 0, sequence_text_size = 0, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with family data, unsorted/unseparated, 0.5 margin + text on", {
    filename <- "visualise_many_sequences_test_06"
    visualise_many_sequences(example_many_sequences$sequence, sequence_colours = sequence_colour_palettes$bright_pale, pixels_per_base = 30, outline_linewidth = 0, index_annotation_lines = NA, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only", {
    filename <- "visualise_many_sequences_test_07"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    expect_message(visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, ascending", {
    filename <- "visualise_many_sequences_test_08"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 7, "individual" = 2), desc_sort = FALSE)
    expect_message(visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes & text", {
    filename <- "visualise_many_sequences_test_09"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 1, "individual" = 0))
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, margin = 0.5, pixels_per_base = 30, sequence_text_colour = "pink", background_colour = "black", filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no grouping", {
    filename <- "visualise_many_sequences_test_10"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    expect_message(visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting", {
    filename <- "visualise_many_sequences_test_11"
    sequences <- extract_sequences_from_dataframe(example_many_sequences, sort_by = NA)
    expect_message(visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting or grouping", {
    filename <- "visualise_many_sequences_test_12"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    expect_message(visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes & text", {
    filename <- "visualise_many_sequences_test_13"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 4))
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, margin = 0.5, outline_linewidth = 0, index_annotation_lines = NA, pixels_per_base = 30, sequence_text_colour = "brown", filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines", {
    filename <- "visualise_many_sequences_test_14"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    expect_message(visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale, margin = 0.5, outline_join = "RoUnD", index_annotation_size = 0, index_annotation_lines = 1, pixels_per_base = 30, sequence_text_colour = "black", filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines", {
    filename <- "visualise_many_sequences_test_15"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    expect_message(expect_warning(visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$sanger, margin = 0, outline_linewidth = 5, index_annotation_interval = 0, index_annotation_lines = 1,outline_colour = "magenta", pixels_per_base = 30, sequence_text_colour = "white", filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, ungrouped", {
    filename <- "visualise_many_sequences_test_16"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale2, pixels_per_base = 30, index_annotation_lines = c(1, 15, 20), index_annotation_full_lines = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, ungrouped, not first row", {
    filename <- "visualise_many_sequences_test_17"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale2, pixels_per_base = 30, index_annotation_lines = c(2, 15, 20), index_annotations_full_line = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, ungrouped, below", {
    filename <- "visualise_many_sequences_test_18"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale2, pixels_per_base = 30, index_annotation_lines = c(1, 15, 20), index_annotations_full_lines = FALSE, index_annotation_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, ungrouped, below, last line", {
    filename <- "visualise_many_sequences_test_19"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale2, pixels_per_base = 30, index_annotation_lines = c(1, 9, 15, 23), index_annotation_full_line = FALSE, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, grouped", {
    filename <- "visualise_many_sequences_test_20"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$ggplot_style, pixels_per_base = 30, index_annotation_lines = c(1, 23, 37), index_annotation_interval = 20, index_annotation_size = 20, index_annotation_colour = "purple", index_annotation_vertical_position = 1/2, index_annotation_full_line = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, grouped, below", {
    filename <- "visualise_many_sequences_test_21"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    ## Also check that the messages for sanitising the lines vector are working
    ## Doesn't seem like expect_message class matches with cli_alert_info class so I removed class here.
    expect_message(expect_message(visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$ggplot_style, pixels_per_base = 30, index_annotation_lines = c(1, 37, 23, 23), index_annotation_interval = 20, index_annotation_size = 20, index_annotation_colour = "purple", index_annotation_vertical_position = 1/2, index_annotation_full_line = FALSE, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, all", {
    filename <- "visualise_many_sequences_test_22"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualize_many_sequences(sequences, sequence_cols = sequence_colour_palettes$bright_deep, pixels_per_base = 15, index_annotation_lines = c(1:23), index_annotation_interval = 1, index_annotation_size = 20, index_annotation_colour = "purple", sequence_text_colour = "cyan", background_colour = "orange", outline_colour = "red", index_annotation_vertical_position = 5/4, index_annotation_full_line = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, all, below", {
    filename <- "visualise_many_sequences_test_23"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, pixels_per_base = 15, index_annotation_lines = c(1:23), index_annotation_interval = 1, index_annotation_size = 20, index_annotation_colour = "purple", sequence_text_colour = "cyan", background_colour = "orange", outline_colour = "red", index_annotation_vertical_position = 5/4, index_annotation_full_line = FALSE, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing raster works", {
    filename <- "visualise_many_sequences_test_24"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    expect_warning(visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, pixels_per_base = 10, background_col = "red", margin = 1.6, force_raster = TRUE, filename = paste0(root, filename, ".png")),
                   class = "raster_is_forced")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence works with space but no annotation text", {
    filename <- "visualise_many_sequences_test_25"
    visualise_many_sequences("ACGT", sequence_colours = sequence_colour_palettes$bright_deep, pixels_per_base = 25, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence works with no space but no annotation text", {
    filename <- "visualise_many_sequences_test_26"
    visualise_many_sequences("ACGT", sequence_colours = sequence_colour_palettes$bright_deep, index_annotation_lines = NA, pixels_per_base = 25, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing first line annotation works", {
    filename <- "visualise_many_sequences_test_27"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, index_annotation_always_first_base = TRUE, index_annotation_lines = seq_along(sequences), pixels_per_base = 25, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing first line annotation works, not full lines", {
    filename <- "visualise_many_sequences_test_28"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, index_annotation_always_first_base = TRUE, index_annotation_lines = seq_along(sequences), index_annotation_full_line = FALSE, pixels_per_base = 25, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

## Test fail cases/invalid arguments to main multiple sequence visualisation function
test_that("single sequence visualisation fails when arguments are invalid", {
    bad_param_value_for_num <- list("hi", TRUE, NA, NULL)
    for (param in bad_param_value_for_num) {
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotation_vertical_position = param), class = "argument_value_or_type")
    }

    bad_param_value_for_non_negative_num <- list("hi", -1, TRUE, c(1, 2), NA, NULL)
    for (param in bad_param_value_for_non_negative_num) {
        expect_error(visualise_many_sequences(sequence_vector_1, sequence_text_size = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotation_size = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, margin = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, outline_linewidth = param), class = "argument_value_or_type")
    }

    bad_param_value_for_positive_int <- list("hi", -1, TRUE, c(1, 2), NA, 1.5, sqrt(5), 0, NULL)
    for (param in bad_param_value_for_positive_int) {
        expect_error(visualise_many_sequences(sequence_vector_1, pixels_per_base = param), class = "argument_value_or_type")
    }

    bad_param_value_for_positive_int_vector <- list("hi", -1, TRUE, 1.5, sqrt(5), 0, c(1, 0), c(1, 2, 3, -5), c(1, 1.1))
    for (param in bad_param_value_for_positive_int_vector) {
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotation_lines = param), class = "argument_value_or_type")
    }

    bad_param_value_for_non_neg_int <- list("hi", -1, TRUE, c(1, 2), NA, 1.5, sqrt(5), NULL)
    for (param in bad_param_value_for_non_neg_int) {
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotation_interval = param), class = "argument_value_or_type")
    }

    bad_param_value_for_logical <- list(1, 1.5, -1, "hi", c(TRUE, FALSE), NA, NULL)
    for (param in bad_param_value_for_logical) {
        expect_error(visualise_many_sequences(sequence_vector_1, return = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotations_above = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotation_full_line = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotation_always_first_base = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, force_raster = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_character <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), NA, c(NA, NA), NULL)
    for (param in bad_param_value_for_single_character) {
        expect_error(visualise_many_sequences(sequence_vector_1, background_colour = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, sequence_text_colour = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, index_annotation_colour = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, outline_colour = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, outline_join = param), class = "argument_value_or_type")
    }

    bad_param_value_for_sequence_colours <- list("orange", 1, c("orange", "pink", "red", NA), NA, -1, 0, TRUE, FALSE, c("orange", "red", "green", "blue", "white"))
    for (param in bad_param_value_for_sequence_colours) {
        expect_error(visualise_many_sequences(sequence_vector_1, sequence_colours = param), class = "argument_value_or_type")
    }

    bad_param_value_for_sequences_vector <- list(1, NA, -1, 0, TRUE, FALSE, c(1.5, 3))
    for (param in bad_param_value_for_sequences_vector) {
        expect_error(visualise_many_sequences(sequence_vector_1, sequences_vector = param), class = "argument_value_or_type")
    }

    bad_param_value_for_filename <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), c(NA, NA))
    for (param in bad_param_value_for_filename) {
        expect_error(visualise_many_sequences(sequence_vector_1, filename = param), class = "argument_value_or_type")
    }
})





## Test whether constructing sequences vector works as expected
test_that("constructing sequences vector works as expected", {
    expect_equal(extract_and_sort_sequences(example_many_sequences), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA", "", "", "", "", "", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "", "", "", "", "", "", "", "", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "", "", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA", "", "", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 3), desc_sort = FALSE), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, sequence_variable = "read", grouping_levels = c("individual" = 4, "family" = 1)), c("F1-1a", "F1-1e", "F1-1c", "F1-1d", "F1-1b", "", "", "", "", "F1-2b", "F1-2a", "", "", "", "", "F1-3a", "F1-3c", "F1-3b", "", "", "", "", "F2-1a", "", "", "", "", "F2-2c", "F2-2b", "F2-2a", "", "", "", "", "F3-1a", "F3-1b", "", "", "", "", "F3-2a", "F3-2b", "F3-2c", "", "", "", "", "F3-3a", "", "", "", "", "F3-4a", "F3-4c", "F3-4b"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 5, "individual" = 1), sort_by = NA), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA", "", "", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "", "", "", "", "", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA", "", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, grouping_levels = NA), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGA", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGA"))
})


## Test whether constructing sequences vector fails when expected
test_that("constructing sequences vector fails when columns are wrong", {
    expect_error(extract_and_sort_sequences(example_many_sequences, sort_by = "hello"), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, sort_by = 3), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, sort_by = c("hello", "world")), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, sort_by = TRUE), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, sort_by = NULL), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = "family"), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family", "individual")), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = "x", "individual" = "y")), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = NA, "individual" = "y")), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = NA, "individual" = "y")), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = TRUE)), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family_2" = 3, "individual" = 1)), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = c(3, 1)), class = "argument_value_or_type")
    expect_error(extract_and_sort_sequences(example_many_sequences, grouping_levels = NULL), class = "argument_value_or_type")

    bad_param_value_for_logical <- list(1, 1.5, -1, "hi", c(TRUE, FALSE), NA, NULL)
    for (param in bad_param_value_for_logical) {
        expect_error(extract_and_sort_sequences(example_many_sequences, desc_sort = param), class = "argument_value_or_type")
    }
})




