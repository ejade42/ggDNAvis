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

