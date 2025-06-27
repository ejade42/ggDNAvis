## Test whether the main plotting function works as expected
root <- "test_plot_images/"
reference <- "reference_images/"
acceptable_distortion <- 0.001
sequence_vector_1 <- c("GGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGC",
                       "GGCGGCGGCGGCGGTGGUGGCGGCGGTGGTGGCGGC",
                       "",
                       "GGCGGCGGCGGCGGAGGC",
                       "GGCGGCGGCGGCGGCGGC")

test_that("main plotting function works in basic case", {
    filename <- "visualise_many_sequences_test_01"
    expect_doppelganger(filename, visualise_many_sequences(sequence_vector_1, margin = 0, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with margin", {
    filename <- "visualise_many_sequences_test_02"
    expect_doppelganger(filename, visualise_many_sequences(sequence_vector_1, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with double margin", {
    filename <- "visualise_many_sequences_test_03"
    expect_doppelganger(filename, visualise_many_sequences(sequence_vector_1, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), margin = 2, sequence_text_size = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with text turned on", {
    filename <- "visualise_many_sequences_test_04"
    expect_doppelganger(filename, visualise_many_sequences(sequence_vector_1, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), pixels_per_base = 30, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with family data, unsorted/unseparated, no margin + text off", {
    filename <- "visualise_many_sequences_test_05"
    expect_doppelganger(filename, visualise_many_sequences(example_many_sequences$sequence, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), pixels_per_base = 10, margin = 0, sequence_text_size = 0, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with family data, unsorted/unseparated, 0.5 margin + text on", {
    filename <- "visualise_many_sequences_test_06"
    expect_doppelganger(filename, visualise_many_sequences(example_many_sequences$sequence, sequence_colours = sequence_colour_palettes$bright_pale, pixels_per_base = 30, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only", {
    filename <- "visualise_many_sequences_test_07"
    sequences <- extract_and_sort_sequences(example_many_sequences)
    expect_doppelganger(filename, visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, ascending", {
    filename <- "visualise_many_sequences_test_08"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 7, "individual" = 2), desc_sort = FALSE)
    expect_doppelganger(filename, visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes & text", {
    filename <- "visualise_many_sequences_test_09"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 1, "individual" = 0))
    expect_doppelganger(filename, visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), margin = 0.5, pixels_per_base = 30, sequence_text_colour = "pink", background_colour = "black", filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no grouping", {
    filename <- "visualise_many_sequences_test_10"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA)
    expect_doppelganger(filename, visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting", {
    filename <- "visualise_many_sequences_test_11"
    sequences <- extract_and_sort_sequences(example_many_sequences, sort_by = NA)
    expect_doppelganger(filename, visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes only, no sorting or grouping", {
    filename <- "visualise_many_sequences_test_12"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = NA, sort_by = NA)
    expect_doppelganger(filename, visualise_many_sequences(sequences, sequence_colours = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"), sequence_text_size = 0, margin = 0, pixels_per_base = 10, filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("main plotting function works with grouped family data, boxes & text", {
    filename <- "visualise_many_sequences_test_13"
    sequences <- extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 4))
    expect_doppelganger(filename, visualise_many_sequences(sequences, sequence_colours = sequence_colour_palettes$bright_deep, margin = 0.5, pixels_per_base = 30, sequence_text_colour = "brown", filename = paste0(root, filename, ".png")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})


## Test fail cases/invalid arguments to main multiple sequence visualisation function
test_that("single sequence visualisation fails when arguments are invalid", {
    bad_param_value_for_non_negative_num <- list("hi", -1, TRUE, c(1, 2), NA)
    for (param in bad_param_value_for_non_negative_num) {
        expect_error(visualise_many_sequences(sequence_vector_1, sequence_text_size = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, margin = param), class = "argument_value_or_type")
    }

    bad_param_value_for_positive_int <- list("hi", -1, TRUE, c(1, 2), NA, 1.5, sqrt(5), 0)
    for (param in bad_param_value_for_positive_int) {
        expect_error(visualise_many_sequences(sequence_vector_1, pixels_per_base = param), class = "argument_value_or_type")
    }

    bad_param_value_for_logical <- list(1, 1.5, -1, "hi", c(TRUE, FALSE), NA)
    for (param in bad_param_value_for_logical) {
        expect_error(visualise_many_sequences(sequence_vector_1, return = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_character <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), NA, c(NA, NA))
    for (param in bad_param_value_for_single_character) {
        expect_error(visualise_many_sequences(sequence_vector_1, background_colour = param), class = "argument_value_or_type")
        expect_error(visualise_many_sequences(sequence_vector_1, sequence_text_colour = param), class = "argument_value_or_type")
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
    expect_equal(extract_and_sort_sequences(example_many_sequences), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGC", "", "", "", "", "", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "", "", "", "", "", "", "", "", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "", "", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGC", "", "", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGC"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 3), desc_sort = FALSE), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, sequence_variable = "read", grouping_levels = c("individual" = 4, "family" = 1)), c("F1-1a", "F1-1e", "F1-1c", "F1-1d", "F1-1b", "", "", "", "", "F1-2b", "F1-2a", "", "", "", "", "F1-3a", "F1-3c", "F1-3b", "", "", "", "", "F2-1a", "", "", "", "", "F2-2c", "F2-2b", "F2-2a", "", "", "", "", "F3-1a", "F3-1b", "", "", "", "", "F3-2a", "F3-2b", "F3-2c", "", "", "", "", "F3-3a", "", "", "", "", "F3-4a", "F3-4c", "F3-4b"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, grouping_levels = c("family" = 5, "individual" = 1), sort_by = NA), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGC", "", "", "", "", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "", "", "", "", "", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGC", "", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGC"))
    expect_equal(extract_and_sort_sequences(example_many_sequences, grouping_levels = NA), c("GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGAGGAGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGTGGTGGCGGCGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGCGGCGGCGGAGGAGGCGGC", "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGC"))
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

    bad_param_value_for_logical <- list(1, 1.5, -1, "hi", c(TRUE, FALSE), NA)
    for (param in bad_param_value_for_logical) {
        expect_error(extract_and_sort_sequences(example_many_sequences, desc_sort = param), class = "argument_value_or_type")
    }
})
