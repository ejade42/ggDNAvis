## Test whether the main plotting function works as expected
sone_2019_f1_1_expanded <- "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGCGGCGGCGGCGGC"
root <- "test_plot_images/"
reference <- "reference_images/"
acceptable_distortion <- fetch_acceptable_distortion(verbose = FALSE)


test_that("single sequence visualisation works with standard conditions", {
    filename <- "sone_2019_f1_1_expanded_test_01"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with funky colours", {
    filename <- "sone_2019_f1_1_expanded_test_02"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("pink", "green", "orange", "yellow"), outline_linewidth = 0, background_colour = "magenta", sequence_text_colour = "red", index_annotation_colour = "blue", pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no text, via index_annotation_size", {
    filename <- "sone_2019_f1_1_expanded_test_03"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, sequence_text_size = 0, index_annotation_size = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no text, via index_annotation_interval", {
    filename <- "sone_2019_f1_1_expanded_test_04"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, sequence_text_size = 0, index_annotation_interval = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with atypical interval", {
    filename <- "sone_2019_f1_1_expanded_test_05"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 55, index_annotation_interval = 12, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with giant fonts", {
    filename <- "sone_2019_f1_1_expanded_test_06"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 35, index_annotation_interval = 15, sequence_text_size = 20, index_annotation_size = 5, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with extra spacing", {
    filename <- "sone_2019_f1_1_expanded_test_07"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 5, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".pNg"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".pNg")),
                                       image_read(paste0(reference, filename, ".pNg")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with reduced spacing, and gives warning", {
    filename <- "sone_2019_f1_1_expanded_test_08"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works exporting to jpg", {
    filename <- "sone_2019_f1_1_expanded_test_09"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".jpg"), render_device = ragg::agg_jpeg),
                   class = "filetype_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".jpg")),
                                       image_read(paste0(reference, filename, ".jpg")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})


test_that("single sequence visualisation works with spacing text clash and jpg warnings", {
    filename <- "sone_2019_f1_1_expanded_test_10"
    expect_warning(expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".jpg"), render_device = ragg::agg_jpeg),
                                  class = "filetype_recommendation"), class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".jpg")),
                                       image_read(paste0(reference, filename, ".jpg")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no spacing but annotations off, via index_annotation_interval", {
    filename <- "sone_2019_f1_1_expanded_test_11"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_interval = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".PNG"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".PNG")),
                                       image_read(paste0(reference, filename, ".PNG")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

## This one is fine because seq_length %% line_wrapping < annotation_interval)
test_that("single sequence visualisation works with no spacing but annotations off, via index_annotation_size", {
    filename <- "sone_2019_f1_1_expanded_test_12"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_size = 0, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".PNG")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".PNG")),
                                       image_read(paste0(reference, filename, ".PNG")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation grey bottom bug: working case of spacing off, annotations off via interval", {
    filename <- "sone_2019_f1_1_expanded_test_13"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_interval = 0, line_wrapping = 60, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".PNG"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".PNG")),
                                       image_read(paste0(reference, filename, ".PNG")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

## This only happens when there would be an annotation on the last line (seq_length %% line_wrapping >= annotation_interval)
## But the size is set to 0, and it causes a bug resulting in grey at the bottom
## Decided easiest solution is just to recommend disabling annotations via interval rather than size
## And giving a warning if done the other way.
test_that("single sequence visualisation grey bottom bug: bug case of spacing off, annotations off via size", {
    filename <- "sone_2019_f1_1_expanded_test_14"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_size = 0, line_wrapping = 60, pixels_per_base = 30, index_annotations_above = FALSE, filename = paste0(root, filename, ".PNG")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".PNG")),
                                       image_read(paste0(reference, filename, ".PNG")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with standard conditions, annotations on top", {
    filename <- "sone_2019_f1_1_expanded_test_15"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, index_annotations_above = TRUE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with extra spacing, annotations on top", {
    filename <- "sone_2019_f1_1_expanded_test_16"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, spacing = 3, line_wrapping = 60, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no spacing, annotations on top", {
    filename <- "sone_2019_f1_1_expanded_test_17"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, spacing = 0, index_annotation_interval = 0, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation warns with no spacing/annotations on top/annotations on", {
    filename <- "sone_2019_f1_1_expanded_test_18"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, spacing = 0, filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with annotations halfway through, above", {
    filename <- "sone_2019_f1_1_expanded_test_19"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, line_wrapping = 60, index_annotation_vertical_position = 0.5, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with annotations halfway through, below", {
    filename <- "sone_2019_f1_1_expanded_test_20"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, line_wrapping = 60, index_annotation_vertical_position = 0.5, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no margin", {
    filename <- "sone_2019_f1_1_expanded_test_21"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 0, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 1", {
    filename <- "sone_2019_f1_1_expanded_test_22"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 1, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 2", {
    filename <- "sone_2019_f1_1_expanded_test_23"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 2, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no margin, below", {
    filename <- "sone_2019_f1_1_expanded_test_24"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 0, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 1, below", {
    filename <- "sone_2019_f1_1_expanded_test_25"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 1, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 2, below", {
    filename <- "sone_2019_f1_1_expanded_test_26"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 2, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single_sequence_visualisation works with outlines", {
    filename <- "sone_2019_f1_1_expanded_test_27"
    visualise_single_sequence(sone_2019_f1_1_expanded, line_wrapping = 60, pixels_per_base = 30, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single_sequence_visualisation works with outlines, no spacing", {
    filename <- "sone_2019_f1_1_expanded_test_28"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_colour_palettes$bright_pale, sequence_text_size = 0, margin = 0, line_wrapping = 60, pixels_per_base = 30, spacing = 0, index_annotation_interval = 0, outline_linewidth = 10, filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("extra margin works with bigger vert pos", {
    filename <- "sone_2019_f1_1_expanded_test_29"
    expect_warning(expect_warning(expect_warning(visualise_single_sequence(
        sone_2019_f1_1_expanded,
        filename = paste0(root, filename, ".png"),
        sequence_colours = c("green", "red", "yellow", "blue"),
        sequence_text_colour = "magenta",
        outline_colour = "orange",
        outline_linewidth = 10,
        outline_join = "round",
        background_colour = "white",
        spacing = 3,
        margin = 0,
        line_wrapping = 60,
        index_annotation_interval = 20,
        index_annotation_colour = "purple",
        index_annotation_vertical_position = 2,
        index_annotation_size = 20,
        pixels_per_base = 30
    ))))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})


## Test fail cases/invalid arguments to main single sequence visualisation function
test_that("single sequence visualisation fails when arguments are invalid", {
    bad_param_value_for_non_negative_num <- list("hi", -1, TRUE, c(1, 2), NA, NULL)
    for (param in bad_param_value_for_non_negative_num) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_text_size = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, index_annotation_size = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, margin = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, outline_linewidth = param), class = "argument_value_or_type")
    }

    bad_param_value_for_non_negative_int <- list("hi", -1, TRUE, c(1, 2), NA, 1.5, sqrt(5), NULL)
    for (param in bad_param_value_for_non_negative_int) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, index_annotation_interval = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, spacing = param), class = "argument_value_or_type")
    }

    bad_param_value_for_positive_int <- list("hi", -1, TRUE, c(1, 2), NA, 1.5, sqrt(5), 0, NULL)
    for (param in bad_param_value_for_positive_int) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, line_wrapping = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, pixels_per_base = param), class = "argument_value_or_type")
    }

    bad_param_value_for_num <- list("hi", TRUE, c(1, 2), NA, NULL)
    for (param in bad_param_value_for_num) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, index_annotation_vertical_position = param), class = "argument_value_or_type")
    }

    bad_param_value_for_logical <- list(1, 1.5, -1, "hi", c(TRUE, FALSE), NA, NULL)
    for (param in bad_param_value_for_logical) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, index_annotations_above = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, return = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_character <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), NA, c(NA, NA), NULL)
    for (param in bad_param_value_for_single_character) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, sequence = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, background_colour = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_text_colour = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, index_annotation_colour = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, outline_join = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, outline_colour = param), class = "argument_value_or_type")
    }

    bad_param_value_for_sequence_colours <- list("orange", 1, c("orange", "pink", "red", NA), NA, -1, 0, TRUE, FALSE, c("orange", "red", "green", "blue", "white"), NULL)
    for (param in bad_param_value_for_sequence_colours) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = param), class = "argument_value_or_type")
    }

    bad_param_value_for_filename <- list(c("hi", "bye"), 1, TRUE, -1, 0, 1.5, -1.5, c("A", "B", "C", "D"), c(NA, NA), NULL)
    for (param in bad_param_value_for_filename) {
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, filename = param), class = "argument_value_or_type")
    }
})




## Test helper functions
## convert_input_seq_to_sequence_list()
test_that("converting single sequence to sequences list works", {
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 1, FALSE, TRUE), c("GGCGGC", "", "GGC", ""))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, end_spaces = TRUE, start_spaces = FALSE), c("GGCGGC", "", "GGC", ""))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 0, FALSE, FALSE), c("GGCGGC", "GGC"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 0, TRUE, TRUE), c("GGCGGC", "GGC"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 3, FALSE, TRUE), c("GGCGGC", "", "", "", "GGC", "", "", ""))
    expect_equal(convert_input_seq_to_sequence_list("GGC", 6, 0, FALSE, FALSE), "GGC")
    expect_equal(convert_input_seq_to_sequence_list("GGC", 1, 0, TRUE, TRUE), c("G", "G", "C"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 2, TRUE, FALSE), c("", "", "GGCGGC", "", "", "GGC"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 0), c("GGCGGC", "GGC"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 0, TRUE, TRUE), c("GGC", "GGC", "GGC"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 1, TRUE, FALSE), c("", "GGC", "", "GGC", "", "GGC"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 2, TRUE, FALSE), c("", "", "GGC", "", "", "GGC", "", "", "GGC"))
    expect_equal(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 2, TRUE, TRUE), c("", "", "GGC", "", "", "GGC", "", "", "GGC", "", ""))

})

test_that("converting single sequence to sequences list fails when expected to", {
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 1.5), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, -1), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 0), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 1.5), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", -1), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list(1, 6), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list(c("GGC", "ATT"), 6), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", c(6, 3)), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 1, c(6, 3)), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 1, c(TRUE, FALSE)), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 1, TRUE, c(TRUE, FALSE)), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, "x"), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", "x", 1), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 1, "x"), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 1, TRUE, "X"), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 6, 1.5, 1), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list(NULL, 3, 2, TRUE), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", NULL, 2, TRUE), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, NULL, TRUE), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 2, NULL), class = "argument_value_or_type")
    expect_error(convert_input_seq_to_sequence_list("GGCGGCGGC", 3, 2, TRUE, NULL), class = "argument_value_or_type")

})


## convert_sequences_to_annotations()
test_that("converting sequences to annotation dataframe works", {
    expect_equal(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, FALSE),
                 data.frame(x_position = c(0.0625, 0.1875, 0.3125, 0.4375, 0.4375, 0.5625, 0.6875, 0.8125, 0.9375, 0.9375, 0.0625, 0.1875, 0.3125, 0.4375, 0.4375),
                            y_position = c(0.875, 0.875, 0.875, 0.875, 0.666666666666667, 0.875, 0.875, 0.875, 0.875, 0.666666666666667, 0.375, 0.375, 0.375, 0.375, 0.166666666666667),
                            annotation = c("G", "G", "C", "G", "4", "G", "C", "A", "A", "8", "G", "G", "C", "A", "12"),
                            type = c("Sequence", "Sequence", "Sequence", "Sequence", "Number", "Sequence", "Sequence", "Sequence", "Sequence", "Number", "Sequence", "Sequence", "Sequence", "Sequence", "Number")))

    expect_equal(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 0, FALSE),
                 data.frame(x_position = c(0.0625, 0.1875, 0.3125, 0.4375, 0.5625, 0.6875, 0.8125, 0.9375, 0.0625, 0.1875, 0.3125, 0.4375),
                            y_position = c(0.875, 0.875, 0.875, 0.875, 0.875, 0.875, 0.875, 0.875, 0.375, 0.375, 0.375, 0.375),
                            annotation = c("G", "G", "C", "G", "G", "C", "A", "A", "G", "G", "C", "A"),
                            type = c("Sequence", "Sequence", "Sequence", "Sequence", "Sequence", "Sequence", "Sequence", "Sequence", "Sequence", "Sequence", "Sequence", "Sequence")))

    expect_equal(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, TRUE, 0.5),
                 data.frame(x_position = c(0.0625, 0.1875, 0.3125, 0.4375, 0.4375, 0.5625, 0.6875, 0.8125, 0.9375, 0.9375, 0.0625, 0.1875, 0.3125, 0.4375, 0.4375),
                            y_position = c(0.875, 0.875, 0.875, 0.875, 1.125, 0.875, 0.875, 0.875, 0.875, 1.125, 0.375, 0.375, 0.375, 0.375, 0.625),
                            annotation = c("G", "G", "C", "G", "4", "G", "C", "A", "A", "8", "G", "G", "C", "A", "12"),
                            type = c("Sequence", "Sequence", "Sequence", "Sequence", "Number", "Sequence", "Sequence", "Sequence", "Sequence", "Number", "Sequence", "Sequence", "Sequence", "Sequence", "Number")))
})

test_that("converting sequences to annotation dataframe fails when expected to", {
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 0, 4), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), c(2, 3), 4), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 4, c(2, 3)), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 1, -1), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(1, 8, 0), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, "x"), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, "x"), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), "x", 4), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, c(TRUE, FALSE)), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, FALSE, "x"), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, FALSE, c(0.5, 0.3)), class = "argument_value_or_type")
    expect_warning(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, FALSE, 1.5),
                   class = "parameter_recommendation")
    expect_warning(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 4, FALSE, -1),
                   class = "parameter_recommendation")
    expect_error(convert_sequences_to_annotations(NULL, 8, 0, FALSE), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), NULL, 0, FALSE), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, NULL, FALSE), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 0, NULL), class = "argument_value_or_type")
    expect_error(convert_sequences_to_annotations(c("GGCGGCAA", "", "GGCA", ""), 8, 0, FALSE, NULL), class = "argument_value_or_type")
})



## Not testing plotting single sequence separately as that only really makes sense
## in the context of being called in the main plotting function
