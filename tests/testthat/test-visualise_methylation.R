## Code to randomly generate methylation probabilities for example data
if (FALSE) {
    e <- example_many_sequences
    set.seed(1234)
    for (i in 1:nrow(e)) {
        locations <- numeric()
        for (j in 1:nchar(e[i, "sequence"])) {
            if (substr(e[i, "sequence"], j, j) == "C") {
                locations <- c(locations, j)
            }
        }
        e[i, "methylation_locations"] <- vector_to_string(locations)
        e[i, "methylation_probabilities"] <- vector_to_string(round(runif(length(locations), min = 0, max = 255)))
    }
}


root <- "test_plot_images/"
reference <- "reference_images/"
acceptable_distortion <- 0.001


test_that("methylation visualisation works as expected, all defaults", {
    filename <- "visualise_methylation_test_01"
    locations     <- extract_and_sort_sequences(example_many_sequences, sequence_variable = "methylation_locations")
    probabilities <- extract_and_sort_sequences(example_many_sequences, sequence_variable = "methylation_probabilities")
    lengths <- as.numeric(extract_and_sort_sequences(example_many_sequences, sequence_variable = "sequence_length")) %>% replace_na(0)
    visualise_methylation(locations, probabilities, lengths, filename = paste0(root, filename, ".png"), pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, ascending sort, via extract_methylation_from_dataframe", {
    filename <- "visualise_methylation_test_02"
    d <- extract_methylation_from_dataframe(example_many_sequences, desc_sort = FALSE)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, wacky colours", {
    filename <- "visualise_methylation_test_03"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = c("individual" = 2), sort_by = NA)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), background_colour = "pink", other_bases_colour = "lightblue", low_colour = "white", high_colour = "black", margin = 1, pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)

    filename <- "visualise_methylation_scalebar_test_03"
    visualise_methylation_colour_scale(background_colour = "pink", low_colour = "white", high_colour = "black")
    ggsave(paste0(root, filename, ".png"), dpi = 200, width = 6, height = 1.5)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works as expected, hard clamping", {
    filename <- "visualise_methylation_test_04"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = NA, sort_by = NA)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), low_clamp = 108, high_clamp = 148, margin = 0, pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)

    filename <- "visualise_methylation_scalebar_test_04"
    visualise_methylation_colour_scale(low_clamp = 108, high_clamp = 148)
    ggsave(paste0(root, filename, ".png"), dpi = 200, width = 6, height = 1.5)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})

test_that("methylation visualisation works with all individuals merged, mild clamping", {
    filename <- "visualise_methylation_test_05"
    d <- extract_methylation_from_dataframe(example_many_sequences, grouping_levels = NA)
    visualise_methylation(d$locations, d$probabilities, d$lengths, filename = paste0(root, filename, ".png"), low_clamp = 50, high_clamp = 200, margin = 1.5, pixels_per_base = 10)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)

    filename <- "visualise_methylation_scalebar_test_05"
    visualise_methylation_colour_scale(low_clamp = 50, high_clamp = 200, precision = 20, x_axis_title = "probability", do_x_ticks = FALSE, do_side_scale = TRUE, side_scale_title = "raw probability")
    ggsave(paste0(root, filename, ".png"), dpi = 200, width = 6, height = 1.5)
    expect_lt(attributes(image_compare(image_read(paste0(root, filename, ".png")),
                                       image_read(paste0(reference, filename, ".png")),
                                       metric = "MAE"))$distortion, acceptable_distortion)
})




