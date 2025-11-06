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
    visualise_many_sequences(sequence_vector_1, outline_linewidth = 0, margin = 0, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with margin", {
    filename <- "visualise_many_sequences_test_02"
    visualise_many_sequences(sequence_vector_1, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with double margin", {
    filename <- "visualise_many_sequences_test_03"
    visualise_many_sequences(sequence_vector_1, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, margin = 2, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with text turned on", {
    filename <- "visualise_many_sequences_test_04"
    visualise_many_sequences(sequence_vector_1, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with family data, unsorted/unseparated, no margin + text off", {
    filename <- "visualise_many_sequences_test_05"
    visualise_many_sequences(example_many_sequences$sequence, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 10, margin = 0, sequence_text_size = 0, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with family data, unsorted/unseparated, 0.5 margin + text on", {
    filename <- "visualise_many_sequences_test_06"
    visualise_many_sequences(example_many_sequences$sequence, sequence_colours = sequence_colour_palettes$bright_pale, pixels_per_base = 30, outline_linewidth = 0, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only", {
    filename <- "visualise_many_sequences_test_07"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, ascending", {
    filename <- "visualise_many_sequences_test_08"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 7, "individual" = 2), desc_sort = FALSE)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes & text", {
    filename <- "visualise_many_sequences_test_09"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 1, "individual" = 0))
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, margin = 0.5, pixels_per_base = 30, sequence_text_colour = "pink", background_colour = "black", filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no grouping", {
    filename <- "visualise_many_sequences_test_10"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting", {
    filename <- "visualise_many_sequences_test_11"
    sequences <- extract_and_sort_sequences(example_many_sequences, sort_by = NA)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting or grouping", {
    filename <- "visualise_many_sequences_test_12"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), outline_linewidth = 0, sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes & text", {
    filename <- "visualise_many_sequences_test_13"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 4))
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, margin = 0.5, outline_linewidth = 0, pixels_per_base = 30, sequence_text_colour = "brown", filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines", {
    filename <- "visualise_many_sequences_test_14"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale, margin = 0.5, outline_join = "RoUnD", pixels_per_base = 30, sequence_text_colour = "black", filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines", {
    filename <- "visualise_many_sequences_test_15"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    expect_warning(visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$sanger, margin = 0, outline_linewidth = 5, outline_colour = "magenta", pixels_per_base = 30, sequence_text_colour = "white", filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, ungrouped", {
    filename <- "visualise_many_sequences_test_16"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale2, pixels_per_base = 30, index_annotation_lines = c(1, 15, 20), index_annotation_full_line = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, ungrouped, not first row", {
    filename <- "visualise_many_sequences_test_17"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale2, pixels_per_base = 30, index_annotation_lines = c(2, 15, 20), index_annotation_full_line = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, ungrouped, below", {
    filename <- "visualise_many_sequences_test_18"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_pale2, pixels_per_base = 30, index_annotation_lines = c(1, 15, 20), index_annotation_full_line = FALSE, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
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
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$ggplot_style, pixels_per_base = 30, index_annotation_lines = c(1, 23, 37), index_annotation_interval = 20, index_annotation_size = 20, index_annotation_colour = "purple", index_annotation_vertical_position = 1/2, index_annotation_full_line = FALSE, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, all", {
    filename <- "visualise_many_sequences_test_22"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, pixels_per_base = 30, index_annotation_lines = c(1:23), index_annotation_interval = 1, index_annotation_size = 20, index_annotation_colour = "purple", sequence_text_colour = "cyan", background_colour = "orange", outline_colour = "red", index_annotation_vertical_position = 5/4, index_annotation_full_line = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with outlines and annnotations, all, below", {
    filename <- "visualise_many_sequences_test_23"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, pixels_per_base = 30, index_annotation_lines = c(1:23), index_annotation_interval = 1, index_annotation_size = 20, index_annotation_colour = "purple", sequence_text_colour = "cyan", background_colour = "orange", outline_colour = "red", index_annotation_vertical_position = 5/4, index_annotation_full_line = FALSE, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
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
    expect_equal(insert_at_indices(c("A", "B", "C", "D", "E"), c(4, 2), insert_before = TRUE, insert = 0),
                 c("A", "0", "B", "C", "0", "D", "E"))
    expect_equal(insert_at_indices(c("A", "B", "C", "D", "E"), c(4, 2), insert_before = FALSE, insert = 0),
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
    bad_param_value_for_pos_int_vec <- list("X", TRUE, NA, NULL, list(1), -1, c(2, 0))
    for (param in bad_param_value_for_pos_int_vec) {
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
