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
    visualize_many_sequences(sequence_vector_1, outline_linewidth = 0, index_annotation_lines = NA, margin = 0, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with margin", {
    filename <- "visualise_many_sequences_test_02"
    visualise_many_sequences(sequence_vector_1, sequence_cols = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, index_annotation_lines = NULL, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with double margin", {
    filename <- "visualise_many_sequences_test_03"
    visualise_many_sequences(sequence_vector_1, sequence_colors = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, index_annotation_lines = numeric(), margin = 2, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
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
    visualise_many_sequences(example_many_sequences$sequence, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, index_annotation_lines = NA, pixels_per_base = 10, margin = 0, sequence_text_size = 0, filename = paste0(root, filename, ".png"))
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
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, ascending", {
    filename <- "visualise_many_sequences_test_08"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 7, "individual" = 2), desc_sort = FALSE)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
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
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting", {
    filename <- "visualise_many_sequences_test_11"
    sequences <- extract_and_sort_sequences(example_many_sequences, sort_by = NA)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting or grouping", {
    filename <- "visualise_many_sequences_test_12"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, index_annotation_lines = NA, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
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



test_that("inserting blanks works as expected", {
    expect_equal(insert_at_indices(c("A", "B", "C", "D", "E"), c(2, 4)),
                 c("A", "", "B", "C", "", "D", "E"))
    expect_equal(insert_at_indices(c("A", "B", "C", "D", "E"), c(2, 4), insert_before = TRUE, insert = 0),
                 c("A", "0", "B", "C", "0", "D", "E"))
    expect_equal(insert_at_indices(c("A", "B", "C", "D", "E"), c(2, 4), insert_before = FALSE, insert = 0),
                 c("A", "B", "0", "C", "D", "0", "E"))
    expect_warning(expect_equal(insert_at_indices(c("A", "B", "C", "D", "E"), c(1, 4, 6), insert_before = TRUE, insert = c("X", "Y")),
                 c("X", "Y", "A", "B", "C", "X", "Y", "D", "E")),
                 class = "length_exceeded")

    expect_warning(expect_equal(insert_at_indices(NA, c(1, 2)),
                                c("", NA)),
                   class = "length_exceeded")

    expect_equal(insert_at_indices(c("A", "B", "C", "D", "E"), c(2, 4), insert = TRUE),
                 c("A", "TRUE", "B", "C", "TRUE", "D", "E"))

    expect_equal(insert_at_indices(list("A", "B", "C", "D", "E"), c(2, 4), insert = TRUE),
                 list("A", TRUE, "B", "C", TRUE, "D", "E"))

    expect_equal(insert_at_indices(list("A", c("B1", "B2"), "C", "D", "E"), c(2, 4), insert = list(TRUE, 7)),
                 list("A", TRUE, 7, c("B1", "B2"), "C", TRUE, 7, "D", "E"))
})

test_that("inserting blanks fails when required", {
    bad_param_value_for_sorted_unique_pos_int_vec <- list("X", TRUE, NA, NULL, list(1), -1, c(2, 0), c(2, 1), c(1, 1, 2), 0.5)
    for (param in bad_param_value_for_sorted_unique_pos_int_vec) {
        expect_error(insert_at_indices(c("A", "B", "C", "D", "E"), param), class = "argument_value_or_type")
    }

    bad_param_value_for_vec <- list(NULL)
    for (param in bad_param_value_for_vec) {
        expect_error(insert_at_indices(param, 1), class = "argument_value_or_type")
    }

    bad_param_value_for_bool <- list("X", 1, c(TRUE, FALSE), list(TRUE, FALSE), NA, NULL, -1)
    for (param in bad_param_value_for_bool) {
        expect_error(insert_at_indices(c("A", "B", "C", "D", "E"), c(1, 2), param), class = "argument_value_or_type")
    }
})



test_that("creating many sequences annotations works, full example", {
    ## Set up arguments (e.g. from visualise_many_sequences() call)
    sequences_data <- example_many_sequences
    index_annotation_lines <- c(1, 23, 37)
    index_annotation_interval <- 10
    index_annotations_above <- TRUE
    index_annotation_full_line <- FALSE
    index_annotation_vertical_position <- 1/3

    ## Create sequences vector
    sequences <- extract_and_sort_sequences(
        example_many_sequences,
        grouping_levels = c("family" = 8, "individual" = 2)
    )

    ## Insert blank rows as needed
    new_sequences <- insert_at_indices(
        sequences,
        insertion_indices = index_annotation_lines,
        insert_before = index_annotations_above,
        insert = "",
        vert = index_annotation_vertical_position
    )

    ## Create annnotation dataframe
    d <- convert_many_sequences_to_index_annotations(
        new_sequences_vector = new_sequences,
        original_sequences_vector = sequences,
        original_indices_to_annotate = index_annotation_lines,
        annotation_interval = 10,
        annotate_full_lines = index_annotation_full_line,
        annotations_above = index_annotations_above,
        annotation_vertical_position = index_annotation_vertical_position
    )

    ## Test
    expect_equal(d, data.frame(
        x_position = c(0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157),
        y_position = c(0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951),
        annotation = c("10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "10", "20", "30", "40", "50", "60", "70", "80", "90", "10", "20", "30", "40", "50", "60", "70", "80", "90"),
        type = c("Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number")
    ))


    ## Extra tests for returning blank dataframe
    blank_data <- data.frame("x_position" = numeric(), "y_position" = numeric(), "annotation" = character(), "type" = character())
    expect_equal(convert_many_sequences_to_index_annotations(new_sequences, sequences, annotation_interval = 0, original_indices_to_annotate = numeric()), blank_data)
    expect_equal(convert_many_sequences_to_index_annotations(new_sequences, sequences, annotation_interval = 10, original_indices_to_annotate = numeric()), blank_data)
    expect_equal(convert_many_sequences_to_index_annotations(new_sequences, sequences, annotation_interval = 0, original_indices_to_annotate = c(1, 2, 3)), blank_data)
})


test_that("creating many sequences annotations works, annotations below", {
    ## Set up arguments (e.g. from visualise_many_sequences() call)
    sequences_data <- example_many_sequences
    index_annotation_lines <- c(1, 23, 37)
    index_annotation_interval <- 10
    index_annotations_above <- FALSE
    index_annotation_full_line <- TRUE
    index_annotation_vertical_position <- 1/3

    ## Create sequences vector
    sequences <- extract_and_sort_sequences(
        example_many_sequences,
        grouping_levels = c("family" = 8, "individual" = 2)
    )

    ## Insert blank rows as needed
    new_sequences <- insert_at_indices(
        sequences,
        insertion_indices = index_annotation_lines,
        insert_before = index_annotations_above,
        insert = "",
        vert = index_annotation_vertical_position
    )

    ## Create annnotation dataframe
    d <- convert_many_sequences_to_index_annotations(
        new_sequences_vector = new_sequences,
        original_sequences_vector = sequences,
        original_indices_to_annotate = index_annotation_lines,
        annotation_interval = 10,
        annotate_full_lines = index_annotation_full_line,
        annotations_above = index_annotations_above,
        annotation_vertical_position = index_annotation_vertical_position
    )

    ## Test
    expect_equal(d, data.frame(
        x_position = c(0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431),
        y_position = c(0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605),
        annotation = c("10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"),
        type = c("Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number")
    ))
})


test_that("creating many sequences annotations fails when needed", {
    ## Create sequences vector
    sequences <- extract_and_sort_sequences(
        example_many_sequences,
        grouping_levels = c("family" = 8, "individual" = 2)
    )

    ## Insert blank rows as needed
    new_sequences <- insert_at_indices(
        sequences,
        insertion_indices = c(1, 23, 37)
    )


    bad_param_value_for_sorted_unique_pos_int_vec <- list("X", TRUE, NA, list(0), -1, 0, c(2, 0), c(2, 1), c(1, 1, 2), 0.5)
    for (param in bad_param_value_for_sorted_unique_pos_int_vec) {
        expect_error(convert_many_sequences_to_index_annotations(sequences, new_sequences, original_indices_to_annotate = param, annotation_interval = 1), class = "argument_value_or_type")
    }

    bad_param_value_for_bool <- list("X", 1, c(TRUE, FALSE), list(TRUE, FALSE), NA, NULL, -1)
    for (param in bad_param_value_for_bool) {
        expect_error(convert_many_sequences_to_index_annotations(sequences, new_sequences, annotate_full_lines = param, original_indices_to_annotate = 1, annotation_interval = 1), class = "argument_value_or_type")
        expect_error(convert_many_sequences_to_index_annotations(sequences, new_sequences, annotations_above = param, original_indices_to_annotate = 1, annotation_interval = 1), class = "argument_value_or_type")
    }

    bad_param_value_for_non_neg_int <- list("X", TRUE, NA, list(1), -1, c(2, 0), c(2, 1), c(1, 1, 2), 0.5)
    for (param in bad_param_value_for_non_neg_int) {
        expect_error(convert_many_sequences_to_index_annotations(sequences, new_sequences, original_indices_to_annotate = 1, annotation_interval = param), class = "argument_value_or_type")
    }

    bad_param_value_for_non_neg_num <- list("X", TRUE, NA, list(1), -1, c(2, 0), c(2, 1), c(1, 1, 2))
    for (param in bad_param_value_for_non_neg_num) {
        expect_error(convert_many_sequences_to_index_annotations(sequences, new_sequences, annotation_vertical_position = param, original_indices_to_annotate = 1, annotation_interval = 1), class = "argument_value_or_type")
    }
})
