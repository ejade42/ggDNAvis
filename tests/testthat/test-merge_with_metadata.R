
test_that("merging methylation and metadata rejects bad arguments", {
    metadata <- read.csv("reference_output_data/example_many_sequences_metadata.csv")
    methylation_data <- read_modified_fastq("reference_output_data/example_many_sequences_altered_modification.fastq")
    merged_data <- merge_methylation_with_metadata(methylation_data, metadata)
    expect_error()
})



test_that("reversing sequences works", {
    expect_equal(reverse_sequence_if_needed(c("GGCGGC", "GCCGCC"), c("forward", "ReVeRSe")),
               c("GGCGGC", "GGCGGC"))
    expect_equal(reverse_sequence_if_needed(c("TAATAA", "GCCGCC"), c("reverse", "forwaRd")),
                 c("TTATTA", "GCCGCC"))
    expect_equal(reverse_sequence_if_needed(c("AuGC", "ATCG", "ATCGU"), c("reverse", "forwaRd", "Forward")),
                 c("GCAT", "ATCG", "ATCGU"))
    expect_equal(reverse_sequence_if_needed(c("AuGC", "AtCg", "ATCG"), c("reverse", "forwaRd", "REVERSE"), "RNA"),
                 c("GCAU", "AtCg", "CGAU"))
    expect_equal(reverse_sequence_if_needed("", "reverse"), "")
})

test_that("reversing sequences fails", {
    bad_param_value_for_char <- list(1, 0, -1, 0.5, TRUE, FALSE, NA, NULL)
    for (param in bad_param_value_for_char) {
        expect_error(reverse_sequence_if_needed(sequence_vector = param, "reverse", "RNA"), class = "argument_value_or_type")
        expect_error(reverse_sequence_if_needed(sequence_vector = param, "reverse", "DNA"), class = "argument_value_or_type")
        expect_error(reverse_sequence_if_needed(sequence_vector = param, "forward", "RNA"), class = "argument_value_or_type")
        expect_error(reverse_sequence_if_needed(sequence_vector = param, "forward", "DNA"), class = "argument_value_or_type")
        expect_error(reverse_sequence_if_needed(sequence_vector = "ATCG", direction_vector = param, "DNA"), class = "argument_value_or_type")
        expect_error(reverse_sequence_if_needed(sequence_vector = "ATCG", "reverse", output_mode = param), class = "argument_value_or_type")
    }

    expect_error(reverse_sequence_if_needed("XXXX", "reverse", "RNA"), class = "argument_value_or_type")
    expect_error(reverse_sequence_if_needed("GGCGGC", "reverse ", "RNA"), class = "argument_value_or_type")
    expect_error(reverse_sequence_if_needed("GGCGGC", "X", "RNA"), class = "argument_value_or_type")
    expect_error(reverse_sequence_if_needed("XXXX", "reverse", "X"), class = "argument_value_or_type")
    expect_error(reverse_sequence_if_needed(c("GGC", "AAG", "GCGC"), c("reverse", "forward")), class = "argument_value_or_type")
})




test_that("reversing locations works", {
    expect_equal(reverse_locations_if_needed("7,10,13,17", "reverse", 19, 1),
                 "2,6,9,12")
    expect_equal(reverse_locations_if_needed("2,6,9,12", "reverse", 19, 1),
                 "7,10,13,17")
    expect_equal(reverse_locations_if_needed("7,10,13,17", "reverse", 19, 0),
                 "3,7,10,13")
    expect_equal(reverse_locations_if_needed("2,6,9,12", "reverse", 19, 0),
                 "8,11,14,18")
    expect_equal(reverse_locations_if_needed("2,6,9,12", "forward", 19, 1),
                 "2,6,9,12")
    expect_equal(reverse_locations_if_needed("7,10,13,17", "forward", 19, 0),
                 "7,10,13,17")
    expect_equal(reverse_locations_if_needed(c("7,10,13,17", "7,10,13,17"), c("forWaRd", "ReversE"), c(19, 19), 0),
                 c("7,10,13,17", "3,7,10,13"))
    expect_equal(reverse_locations_if_needed(c("1,4,7", "1,2"), c("Reverse", "reverse"), c(10, 4), 1),   #GGCGGCGGCG or CGCCGCCGCC
                 c("3,6,9", "2,3"))
    expect_equal(reverse_locations_if_needed("", "reverse", 0), "")
})

test_that("reversing locations fails", {
    bad_param_value_for_char <- list(1, 0, -1, 0.5, TRUE, FALSE, NA, NULL, c(1,2), c(1, NA))
    for (param in bad_param_value_for_char) {
        expect_error(reverse_locations_if_needed(param, "reverse", 20), class = "argument_value_or_type")
        expect_error(reverse_locations_if_needed("3,6,9", param, 20, 1), class = "argument_value_or_type")
    }
    expect_error(reverse_locations_if_needed("3,6,9", "X", 15), class = "argument_value_or_type")
    expect_error(reverse_locations_if_needed("3,6,9", "reverse ", 15), class = "argument_value_or_type")
    expect_warning(expect_error(reverse_locations_if_needed("x", "reverse", 15), class = "argument_value_or_type"))

    bad_param_value_for_lengths <- list(0.5, c(1, -1), c(1, 0.5), TRUE, FALSE, "1", "x", NA, NULL)
    for (param in bad_param_value_for_lengths) {
        expect_error(reverse_locations_if_needed("3,6,9", "reverse", param), class = "argument_value_or_type")
    }

    bad_param_value_for_offset <- list(0.5, "X", c(1, 2), TRUE, FALSE, NA, NULL)
    for (param in bad_param_value_for_offset) {
        expect_error(reverse_locations_if_needed("3,6,9", "reverse", 12, param), class = "argument_value_or_type")
    }

    warn_param_value_for_offset <- list(-1, -2, 2, 3)
    for (param in warn_param_value_for_offset) {
        expect_warning(reverse_locations_if_needed("3,6,9", "reverse", 12, param), class = "parameter_recommendation")
    }

    expect_error(reverse_locations_if_needed(c("3,6,9", "1,2,3"), c("forward", "reverse"), c(10), class = "argument_value_or_type"))
    expect_error(reverse_locations_if_needed(c("3,6,9", "1,2,3"), c("reverse"), c(10, 5), class = "argument_value_or_type"))
    expect_error(reverse_locations_if_needed(c("3,6,9"), c("forward", "reverse"), c(10, 5), class = "argument_value_or_type"))
})






test_that("reversing probabilities works", {
    expect_equal(reverse_probabilities_if_needed(c("256,128,64,2", "100,50,150"), c("reverse", "reverse")),
                 c("2,64,128,256", "150,50,100"))
    expect_equal(reverse_probabilities_if_needed(c("256,128,64,2", "100,50,150"), c("FoRwArD", "ReverSE")),
                 c("256,128,64,2", "150,50,100"))
    expect_equal(reverse_probabilities_if_needed("", "reverse"), "")
})

test_that("reversing probabilities fails", {
    bad_param_value_for_char <- list(1, 0, -1, 0.5, TRUE, FALSE, NA, NULL, c(1,2), c(1, NA))
    for (param in bad_param_value_for_char) {
        expect_error(reverse_probabilities_if_needed("125,230,0,45", param), class = "argument_value_or_type")
        expect_error(reverse_probabilities_if_needed(c("125,230,0,45", "54,65"), param), class = "argument_value_or_type")
        expect_error(reverse_probabilities_if_needed(param, "forward"), class = "argument_value_or_type")
        expect_error(reverse_probabilities_if_needed(param, c("forward", "reverse")), class = "argument_value_or_type")
    }

    expect_warning(expect_error(reverse_probabilities_if_needed("hello", "reverse"), class = "argument_value_or_type"))
    expect_error(reverse_probabilities_if_needed("35,123,40", "reversed"), class = "argument_value_or_type")

    expect_error(reverse_probabilities_if_needed("125,230,0,45", c("forward", "reverse")), class = "argument_value_or_type")
    expect_error(reverse_probabilities_if_needed(c("125,230,0,45", "6,5,230,0,142"), "forward"), class = "argument_value_or_type")
})
