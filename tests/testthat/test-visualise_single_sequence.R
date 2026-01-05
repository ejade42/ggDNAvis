## Test whether the main plotting function works as expected
sone_2019_f1_1_expanded <- "GGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGCGGAGGAGGAGGCGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGAGGAGGAGGCGGCGGCGGCGGCGGCGGC"
root <- "test_plot_images/"
reference <- "reference_images/"
acceptable_distortion <- fetch_acceptable_distortion(verbose = FALSE)


test_that("single sequence visualisation works with standard conditions", {
    filename <- "sone_2019_f1_1_expanded_test_01"
    visualize_single_sequence(sone_2019_f1_1_expanded, sequence_cols = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with funky colours", {
    filename <- "sone_2019_f1_1_expanded_test_02"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colors = c("pink", "green", "orange", "yellow"), outline_linewidth = 0, background_color = "magenta", sequence_text_col = "red", index_annotation_colour = "blue", pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no text, via index_annotation_size", {
    filename <- "sone_2019_f1_1_expanded_test_03"
    expect_warning(expect_message(expect_message(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, sequence_text_size = 0, index_annotation_size = 0, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png")))),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no text, via index_annotation_interval", {
    filename <- "sone_2019_f1_1_expanded_test_04"
    expect_warning(expect_message(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, sequence_text_size = 0, index_annotation_interval = 0, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with atypical interval", {
    filename <- "sone_2019_f1_1_expanded_test_05"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_cols = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 55, index_annotation_interval = 12, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with giant fonts", {
    filename <- "sone_2019_f1_1_expanded_test_06"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 35, index_annotation_interval = 15, sequence_text_size = 20, index_annotation_size = 5, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with extra spacing", {
    filename <- "sone_2019_f1_1_expanded_test_07"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 5, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".pNg"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".pNg")),
                                       image_read(paste0(reference, filename, ".pNg")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with reduced spacing, and gives warning", {
    filename <- "sone_2019_f1_1_expanded_test_08"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works exporting to jpg", {
    filename <- "sone_2019_f1_1_expanded_test_09"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 15, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".jpg"), render_device = ragg::agg_jpeg),
                   class = "filetype_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".jpg")),
                                       image_read(paste0(reference, filename, ".jpg")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})


test_that("single sequence visualisation works with spacing text clash and jpg warnings", {
    filename <- "sone_2019_f1_1_expanded_test_10"
    expect_warning(expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, pixels_per_base = 15, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".jpg"), render_device = ragg::agg_jpeg),
                                  class = "filetype_recommendation"), class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".jpg")),
                                       image_read(paste0(reference, filename, ".jpg")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no spacing but annotations off, via index_annotation_interval", {
    filename <- "sone_2019_f1_1_expanded_test_11"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_interval = 0, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".PNG"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".PNG")),
                                       image_read(paste0(reference, filename, ".PNG")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

## This one is fine because seq_length %% line_wrapping < annotation_interval)
test_that("single sequence visualisation works with no spacing but annotations off, via index_annotation_size", {
    filename <- "sone_2019_f1_1_expanded_test_12"
    expect_message(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_size = 0, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".PNG")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".PNG")),
                                       image_read(paste0(reference, filename, ".PNG")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation grey bottom bug: working case of spacing off, annotations off via interval", {
    filename <- "sone_2019_f1_1_expanded_test_13"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_interval = 0, line_wrapping = 60, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".PNG"))
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
    expect_message(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, spacing = 0, index_annotation_size = 0, line_wrapping = 60, pixels_per_base = 30, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".PNG")))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".PNG")),
                                       image_read(paste0(reference, filename, ".PNG")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with standard conditions, annotations on top", {
    filename <- "sone_2019_f1_1_expanded_test_15"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, index_annotations_above = TRUE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with extra spacing, annotations on top", {
    filename <- "sone_2019_f1_1_expanded_test_16"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, spacing = 3, line_wrapping = 60, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no spacing, annotations on top", {
    filename <- "sone_2019_f1_1_expanded_test_17"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, spacing = 0, index_annotation_interval = 0, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation warns with no spacing/annotations on top/annotations on", {
    filename <- "sone_2019_f1_1_expanded_test_18"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, spacing = 0, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with annotations halfway through, above", {
    filename <- "sone_2019_f1_1_expanded_test_19"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, line_wrapping = 60, index_annotation_vertical_position = 0.5, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with annotations halfway through, below", {
    filename <- "sone_2019_f1_1_expanded_test_20"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, pixels_per_base = 30, line_wrapping = 60, index_annotation_vertical_position = 0.5, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no margin", {
    filename <- "sone_2019_f1_1_expanded_test_21"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 0, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 1", {
    filename <- "sone_2019_f1_1_expanded_test_22"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 1, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 2", {
    filename <- "sone_2019_f1_1_expanded_test_23"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 2, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with no margin, below", {
    filename <- "sone_2019_f1_1_expanded_test_24"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 0, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 1, below", {
    filename <- "sone_2019_f1_1_expanded_test_25"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 1, index_annotations_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single sequence visualisation works with margin 2, below", {
    filename <- "sone_2019_f1_1_expanded_test_26"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"), outline_linewidth = 0, line_wrapping = 60, pixels_per_base = 30, margin = 2, index_annotation_above = FALSE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single_sequence_visualisation works with outlines", {
    filename <- "sone_2019_f1_1_expanded_test_27"
    visualise_single_sequence(sone_2019_f1_1_expanded, line_wrapping = 60, pixels_per_base = 30, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png"))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("single_sequence_visualisation works with outlines, no spacing", {
    filename <- "sone_2019_f1_1_expanded_test_28"
    expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_colour_palettes$bright_pale, sequence_text_size = 0, margin = 0, line_wrapping = 60, pixels_per_base = 30, spacing = 0, index_annotation_interval = 0, outline_linewidth = 10, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png")),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("extra margin works with bigger vert pos", {
    filename <- "sone_2019_f1_1_expanded_test_29"
    expect_warning(expect_warning(visualise_single_sequence(
        sone_2019_f1_1_expanded,
        filename = paste0(root, filename, ".png"),
        sequence_colours = c("green", "red", "yellow", "blue"),
        sequence_text_color = "magenta",
        outline_col = "orange",
        outline_linewidth = 10,
        outline_join = "round",
        background_color = "white",
        spacing = 3,
        margin = 0,
        line_wrapping = 60,
        index_annotation_interval = 20,
        index_annotation_colour = "purple",
        index_annotation_vertical_position = 2,
        index_annotation_size = 20,
        pixels_per_base = 30,
        index_annotation_always_first_base = FALSE,
        index_annotation_always_last_base = FALSE
    )))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing raster works", {
    filename <- "sone_2019_f1_1_expanded_test_30"
    expect_warning(expect_warning(visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_colour_palettes$bright_deep, margin = 10, line_wrapping = 55, pixels_per_base = 10, spacing = 0, force_raster = TRUE, index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, filename = paste0(root, filename, ".png")),
                   class = "raster_is_forced"), class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("logic for large spaces underneath works", {
    filename <- "sone_2019_f1_1_expanded_test_31"
    visualise_single_sequence(sone_2019_f1_1_expanded, spacing = 3, line_wrapping = 60, index_annotations_above = FALSE, filename = paste0(root, filename, ".png"), index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, pixels_per_base = 25)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("very short sequences visualise correctly", {
    filename <- "sone_2019_f1_1_expanded_test_32"
    expect_message(visualise_single_sequence("ACGT", sequence_colours = sequence_col_palettes$bright_pale2, filename = paste0(root, filename, ".png"), index_annotation_always_first_base = FALSE, index_annotation_always_last_base = FALSE, pixels_per_base = 25))
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing annotation on first bases works", {
    filename <- "sone_2019_f1_1_expanded_test_33"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_col_palettes$bright_pale2, filename = paste0(root, filename, ".png"), pixels_per_base = 30, index_annotation_always_first_base = TRUE, index_annotation_always_last_base = FALSE)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing annotation on first bases works, interval 1, spacing 2", {
    filename <- "sone_2019_f1_1_expanded_test_34"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_col_palettes$bright_pale2, spacing = 2, filename = paste0(root, filename, ".png"), index_annotation_interval = 1, index_annotation_above = F, pixels_per_base = 30, index_annotation_colour = alpha("purple", 0.3), index_annotation_always_first_base = TRUE, index_annotation_always_last_base = FALSE)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("very short sequences visualise correctly, and warn about overriding first base", {
    filename <- "sone_2019_f1_1_expanded_test_35"
    expect_warning(visualise_single_sequence("ACGT", sequence_colours = sequence_col_palettes$bright_pale2, filename = paste0(root, filename, ".png"), pixels_per_base = 25, index_annotation_interval = 0, index_annotation_always_first_base = TRUE, index_annotation_always_last_base = FALSE),
                   class = "parameter_recommendation")
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("very short sequences visualise correctly with first annotation forced, below", {
    filename <- "sone_2019_f1_1_expanded_test_36"
    visualise_single_sequence("ACGT", sequence_colours = sequence_col_palettes$sanger, sequence_text_color = "white", filename = paste0(root, filename, ".png"), pixels_per_base = 25, index_annotations_above = FALSE, index_annotation_always_first_base = TRUE, index_annotation_always_last_base = FALSE)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forced first base annotation on last line that wouldn't normally get one with annotations under doesn't accidentally double the margin", {
    filename <- "sone_2019_f1_1_expanded_test_37"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_col_palettes$bright_pale2, spacing = 3, filename = paste0(root, filename, ".png"), index_annotation_above = FALSE, pixels_per_base = 20, index_annotations_always_first_base = TRUE, index_annotation_always_last_base = FALSE)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("forcing annotation on first and last bases works, interval 1, spacing 2", {
    filename <- "sone_2019_f1_1_expanded_test_38"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_col_palettes$bright_pale2, spacing = 2, filename = paste0(root, filename, ".png"), index_annotation_interval = 1, index_annotation_above = F, pixels_per_base = 30, index_annotation_colour = alpha("purple", 0.3), index_annotations_always_first_base = TRUE, index_annotation_always_last_base = TRUE)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})
test_that("forcing annotation on first and last bases works, interval 10", {
    filename <- "sone_2019_f1_1_expanded_test_39"
    visualise_single_sequence(sone_2019_f1_1_expanded, sequence_colours = sequence_col_palettes$bright_pale2, filename = paste0(root, filename, ".png"), index_annotation_interval = 10, index_annotation_above = F, pixels_per_base = 30, index_annotation_colour = alpha("purple", 0.3), index_annotation_always_first_base = TRUE, index_annotations_always_last_base = TRUE)
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
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, index_annotation_always_first_base = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, index_annotation_always_last_base = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, return = param), class = "argument_value_or_type")
        expect_error(visualise_single_sequence(sone_2019_f1_1_expanded, force_raster = param), class = "argument_value_or_type")
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





## Helpers have been removed
