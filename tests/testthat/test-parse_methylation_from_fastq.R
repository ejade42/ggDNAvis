root <- "test_output_data/"
reference <- "reference_output_data/"


## READING FROM FASTQ
## -------------------------------------------------------------------------------------
test_that("reading modification information from FASTQ works", {
    filename <- "example_many_sequences.fastq"
    test_01  <- read_modified_fastq(paste0(reference, filename))
    expect_equal(colnames(test_01), c("read", "sequence", "sequence_length", "quality", "modification_types", "C+h?_locations", "C+h?_probabilities", "C+m?_locations", "C+m?_probabilities"))
    expect_equal(nrow(test_01), 23)

    write_modified_fastq(test_01, paste0(root, filename), locations_colnames = c("C+h?_locations", "C+m?_locations"), probabilities_colnames = c("C+h?_probabilities", "C+m?_probabilities"))
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))
})

test_that("reading modification information from FASTQ works with altered types", {
    filename <- "example_many_sequences_altered_modification.fastq"
    test_02  <- read_modified_fastq(paste0(reference, filename))
    expect_equal(colnames(test_02), c("read", "sequence", "sequence_length", "quality", "modification_types", "C+h?_locations", "C+h?_probabilities", "C+m?_locations", "C+m?_probabilities", "C+x?_locations", "C+x?_probabilities", "C+y?_locations", "C+y?_probabilities"))
    expect_equal(nrow(test_02), 23)

    write_modified_fastq(test_02, paste0(root, filename), locations_colnames = c("C+h?_locations", "C+m?_locations", "C+x?_locations", "C+y?_locations"), probabilities_colnames = c("C+h?_probabilities", "C+m?_probabilities", "C+x?_probabilities", "C+y?_probabilities"), modification_prefixes = c("C+h?", "C+m?", "C+x?", "C+y?"), include_blank_tags = FALSE)
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))
})

test_that("reading modification information from FASTQ works with blank tags", {
    filename <- "example_many_sequences_altered_with_blank_tags.fastq"
    test_03 <- read_modified_fastq(paste0(reference, filename))
    expect_equal(colnames(test_03), c("read", "sequence", "sequence_length", "quality", "modification_types", "C+h?_locations", "C+h?_probabilities", "C+m?_locations", "C+m?_probabilities", "C+x?_locations", "C+x?_probabilities", "C+y?_locations", "C+y?_probabilities"))
    expect_equal(nrow(test_03), 23)

    write_modified_fastq(test_03, paste0(root, filename), locations_colnames = c("C+h?_locations", "C+m?_locations", "C+x?_locations", "C+y?_locations"), probabilities_colnames = c("C+h?_probabilities", "C+m?_probabilities", "C+x?_probabilities", "C+y?_probabilities"), modification_prefixes = c("C+h?", "C+m?", "C+x?", "C+y?"), include_blank_tags = TRUE)
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))
})

test_that("reading modification information from FASTQ works when tags are different lengths", {
    filename <- "example_many_sequences_c+m_no_question.fastq"
    test_04 <- read_modified_fastq(paste0(reference, filename), debug = TRUE)
    expect_equal(colnames(test_04), c("read", "sequence", "sequence_length", "quality", "modification_types", "MM_tags", "ML_tags", "MM_raw", "ML_raw", "C+h?_locations", "C+h?_probabilities", "C+m_locations", "C+m_probabilities"))
    expect_equal(nrow(test_04), 23)

    write_modified_fastq(test_04, paste0(root, filename), locations_colnames = c("C+h?_locations", "C+m_locations"), probabilities_colnames = c("C+h?_probabilities", "C+m_probabilities"), modification_prefixes = c("C+h?", "C+m"))
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))
})

test_that("reading sequence from FASTQ works", {
    filename <- "example_many_sequences_unmodified.fastq"
    test_05 <- read_fastq(paste0(reference, filename))
    expect_equal(colnames(test_05), c("read", "sequence", "quality", "sequence_length"))
    expect_equal(nrow(test_05), 23)

    write_fastq(test_05, paste0(root, filename))
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))

    filename <- "example_many_sequences_unmodified_no_quality.fastq"
    test_06 <- read_fastq(paste0(reference, filename), calculate_length = F)
    expect_equal(colnames(test_06), c("read", "sequence", "quality"))
    expect_equal(nrow(test_06), 23)

    write_fastq(test_06, paste0(root, filename))
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))
})


test_that("reading modification information fails", {
    bad_param_value_for_filename <- list(c("x", "y"), NA, NULL, TRUE, FALSE, 1, -1, 0.5)
    for (param in bad_param_value_for_filename) {
        expect_error(read_modified_fastq(param), class = "argument_value_or_type")
        expect_error(read_fastq(param), class = "argument_value_or_type")
    }

    bad_param_value_for_logical <- list("X", c(TRUE, FALSE), NA, NULL, 1, -1, 0.5)
    for (param in bad_param_value_for_logical) {
        expect_error(read_modified_fastq(filename = paste0(reference, "example_many_sequences.fastq"), debug = param),
                     class = "argument_value_or_type")
        expect_error(read_fastq(filename = paste0(reference, "example_many_sequences.fastq"), calculate_length = param),
                     class = "argument_value_or_type")
    }
})




test_that("helper function for interpreting MM vector works", {
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 0, 1), "C"),
                 c(3, 6, 12))
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 1, 0), "C"),
                 c(3, 9, 12))
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 0, 0, 0), "C"),
                 c(3, 6, 9, 12))
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 0, 0, 0, 0, 0, 0, 0), "G"),
                 c(1, 2, 4, 5, 7, 8, 10, 11))
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", numeric(), "A"),
                 numeric())
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", numeric(), "C"),
                 numeric())
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", NA, "C"),
                 numeric())
    expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", NULL, "C"),
                 numeric())
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 0, 0, 0, 0, 0, 0, 0), "Q"),
                                as.numeric(c(NA, NA, NA, NA, NA, NA, NA, NA))), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 0, 0, 0, 0, 0, 0, 0), "A"),
                                as.numeric(c(NA, NA, NA, NA, NA, NA, NA, NA))), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0), "A"),
                                as.numeric(c(NA))), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 0, 0, 0, 0), "C"),
                                c(3, 6, 9, 12, NA)), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGCGGCGGC", c(0, 2, 0), "C"),
                                c(3, 12, NA)), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGC", c(0, 0, 0), "C"),
                                c(3, 6, NA)), class = "will_produce_NA")
    expect_equal(convert_MM_vector_to_locations("GGCGGC", c(0, 0, 0), "G"),
                 c(1, 2, 4))
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGC", c(0, 0, 0), "C"),
                                c(3, NA, NA)), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGC", c(0, 0, 0), "A"),
                                as.numeric(c(NA, NA, NA))), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGC", c(0, 0, 0), "G"),
                                c(1, 2, NA)), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGCGGC", c(5), "C"),
                                as.numeric(c(NA))), class = "will_produce_NA")
    expect_warning(expect_equal(convert_MM_vector_to_locations("GGCGGCGGC", c(5, 0), "C"),
                                as.numeric(c(NA, NA))), class = "will_produce_NA")
})

test_that("helper function for interpreting MM vector fails", {
    bad_param_value_for_single_char <- list(1, -1, 0, 0.5, TRUE, FALSE, NA, NULL, c("x", "y"))
    for (param in bad_param_value_for_single_char) {
        expect_error(convert_MM_vector_to_locations(param, c(1, 4, 7, 10), "C"), class = "argument_value_or_type")
        expect_error(convert_MM_vector_to_locations("CGGCGGCGGC", c(1, 4, 7, 10), param), class = "argument_value_or_type")
    }

    ## 3 and 9 are bad values only because there isn't a "C" at those indices.
    bad_param_value_for_skips <- list("x", TRUE, FALSE, c("x", "y"), -1, 1.5, 0.5)
    for (param in bad_param_value_for_skips) {
        expect_error(convert_MM_vector_to_locations("CGGCGGCGGC", param, "C"), class = "argument_value_or_type")
    }
})


## -------------------------------------------------------------------------------------







## WRITING TO FASTQ
## -------------------------------------------------------------------------------------
test_that("writing modification info to fastq works", {
    filename <- "example_many_sequences.fastq"
    write_modified_fastq(example_many_sequences, paste0(root, filename))
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))

    filename <- "example_many_sequences_no_quality.fastq"
    write_modified_fastq(example_many_sequences, paste0(root, filename), quality_colname = NA)
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))


    filename <- "example_many_sequences_unmodified.fastq"
    write_fastq(example_many_sequences, paste0(root, filename))
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))

    filename <- "example_many_sequences_unmodified_no_quality.fastq"
    write_fastq(example_many_sequences, paste0(root, filename), quality_colname = NA)
    expect_equal(readLines(paste0(root, filename)), readLines(paste0(reference, filename)))
})


test_that("writing modification info or sequence info to fastq rejects bad arguments", {
    # "x" is a bad value because there isn't a colname called that
    bad_param_value_for_single_colname <- list(NULL, NA, c("sequence", "read"), 1, TRUE, -1, 0, 2.5, "x", character())
    for (param in bad_param_value_for_single_colname) {
        expect_error(write_modified_fastq(example_many_sequences, read_id_colname = param), class = "argument_value_or_type")
        expect_error(write_modified_fastq(example_many_sequences, sequence_colname = param), class = "argument_value_or_type")
        expect_error(write_fastq(example_many_sequences, read_id_colname = param), class = "argument_value_or_type")
        expect_error(write_fastq(example_many_sequences, sequence_colname = param), class = "argument_value_or_type")
    }

    bad_param_value_for_single_colname_NA_allowed <- list(NULL, c("sequence", "read"), 1, TRUE, -1, 0, 2.5, "x", character())
    for (param in bad_param_value_for_single_colname_NA_allowed) {
        expect_error(write_modified_fastq(example_many_sequences, quality_colname = param), class = "argument_value_or_type")
        expect_error(write_fastq(example_many_sequences, quality_colname = param), class = "argument_value_or_type")
    }

    bad_param_value_for_multiple_colname <- list(NULL, NA, c("y", "read"), 1, TRUE, -1, 0, 2.5, "x", character(), c(1, 0))
    for (param in bad_param_value_for_multiple_colname) {
        expect_error(write_modified_fastq(example_many_sequences, locations_colnames = param), class = "argument_value_or_type")
        expect_error(write_modified_fastq(example_many_sequences, probabilities_colnames = param), class = "argument_value_or_type")
    }

    bad_param_value_for_multiple_char <- list(NULL, NA, 1, TRUE, -1, 0, 2.5, c(1, 0), character())
    for (param in bad_param_value_for_multiple_char) {
        expect_error(write_modified_fastq(example_many_sequences, modification_prefixes = param), class = "argument_value_or_type")
    }

    bad_param_value_for_filename <- list(NULL, 1, TRUE, -1, 0, 2.5, c(1, 0), character())
    for (param in bad_param_value_for_filename) {
        expect_error(write_modified_fastq(example_many_sequences, filename = param), class = "argument_value_or_type")
        expect_error(write_fastq(example_many_sequences, filename = param), class = "argument_value_or_type")
    }

    bad_param_value_for_logical <- list("X", c(TRUE, FALSE), NA, NULL, 1, -1, 0.5)
    for (param in bad_param_value_for_logical) {
        expect_error(write_modified_fastq(example_many_sequences, return = param), class = "argument_value_or_type")
        expect_error(write_fastq(example_many_sequences, return = param), class = "argument_value_or_type")
        expect_error(write_modified_fastq(example_many_sequences, include_blank_tags = param), class = "argument_value_or_type")
    }

    expect_error(write_modified_fastq(example_many_sequences,
                                      locations_colnames = c("methylation_locations"),
                                      probabilities_colnames = c("methylation_probabilities"),
                                      modification_prefixes = c("C+h?", "C+m?")),
                 class = "argument_value_or_type")
})





test_that("helper function for constructing MM vector works", {
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", c(6,9), "C"),
                 c(1, 0))
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", c(9), "C"),
                 c(2))
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", numeric(), "C"),
                 numeric())
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", NA, "C"),
                 numeric())
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", NULL, "C"),
                 numeric())
    expect_equal(convert_locations_to_MM_vector("CGGCGGCGGC", c(1,10), "C"),
                 c(0, 2))
    expect_equal(convert_locations_to_MM_vector("CGGCGGCGGC", c(1,7,10), "C"),
                 c(0, 1, 0))
    expect_equal(convert_locations_to_MM_vector("CGGCGGCGGC", c(1, 4, 7, 10), "C"),
                 c(0, 0, 0, 0))
})


test_that("helper function for constructing MM vector fails", {
    bad_param_value_for_single_char <- list(1, -1, 0, 0.5, TRUE, FALSE, NA, NULL, c("x", "y"))
    for (param in bad_param_value_for_single_char) {
        expect_error(convert_locations_to_MM_vector(param, c(1, 4, 7, 10), "C"), class = "argument_value_or_type")
        expect_error(convert_locations_to_MM_vector("CGGCGGCGGC", c(1, 4, 7, 10), param), class = "argument_value_or_type")
    }

    ## 3 and 9 are bad values only because there isn't a "C" at those indices.
    bad_param_value_for_locations <- list("x", TRUE, FALSE, 0, 0.5, -1, c(3, 9), 3, 9)
    for (param in bad_param_value_for_locations) {
        expect_error(convert_locations_to_MM_vector("CGGCGGCGGC", param, "C"), class = "argument_value_or_type")
    }
})
## -------------------------------------------------------------------------------------
