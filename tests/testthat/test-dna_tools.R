## Test reverse complementing
test_that("reverse complementing works when expected to", {
    expect_equal(reverse_complement("ATUCG"), "CGAAT")
    expect_equal(reverse_complement("ATUCG", "RNA"), "CGAAU")
    expect_equal(reverse_complement("atagc", "dNa"), "GCTAT")
    expect_equal(reverse_complement("atAgcUX5", "rEverSe_oNly"), "5XUCGATA")
})

test_that("reverse complementing fails with expected errors", {
    expect_error(reverse_complement("ATCG", "x"), class = "argument_value_or_type")
    expect_error(reverse_complement("ATCGU", 3), class = "argument_value_or_type")
    expect_error(reverse_complement("X"), class = "argument_value_or_type")
    expect_error(reverse_complement(c("A", "T")), class = "argument_length")
    expect_error(reverse_complement("ATCG", c("DNA", "RNA")), class = "argument_length")
})


## Test error reporting
test_that("error reporting works", {
    expect_error(bad_arg("x", list(x = 1), "is bad lol", "hi"), class = "hi", regexp = "*Argument 'x' is bad lol\nCurrent class: numeric\nCurrent value: 1*")
    expect_error(bad_arg("x", list(x = 1), "is bad lol", "hi", TRUE), class = "hi", regexp = "*Argument 'x' is bad lol\nCurrent class: numeric\nCurrent value: 1\nCurrent names: *")
    expect_error(bad_arg("x", list(x = c("item 1" = 1, "item 2" = 7)), "is bad lol", "hi"), class = "hi", regexp = "*Argument 'x' is bad lol\nCurrent class: numeric\nCurrent value: 1, 7\nCurrent names: item 1, item 2*")
})

test_that("error reporting recursively rejects bad arguments", {
    bad_value_for_single_char <- list(NULL, NA, c("x", "y"), TRUE, -1, 0, 1, 1.5)
    for (param in bad_value_for_single_char) {
        expect_error(bad_arg(param, list(x = 1), "is bad", class = "not the usual class"), class = "argument_value_or_type")
        expect_error(bad_arg("x", list(x = 1), param, class = "not the usual class"), class = "argument_value_or_type")
        expect_error(bad_arg("x", list(x = 1), "is bad", class = param), class = "argument_value_or_type")
    }
    expect_error(bad_arg("x", list(y = 1), "is bad", class = "not the usual class"), class = "argument_value_or_type")
})


## Test alias management
test_that("alias management works", {
    low_colour <- "blue"
    dots_env <- list2env(list(low_color = "orange"))
    low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env)
    expect_equal(low_colour, "orange")
})

test_that("alias management works, canonical changed", {
    low_colour <- "red"
    dots_env <- list2env(list(low_color = "orange"))
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env), class = "alias_conflict")
    expect_equal(low_colour, "red")
})

test_that("alias management works, canonical always wins", {
    low_colour <- "green"
    dots_env <- list2env(list(low_color = "orange", low_col = "purple"))
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env), class = "alias_conflict")
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_col", dots_env), class = "alias_conflict")
    expect_equal(low_colour, "green")
})

test_that("alias management works, cascading", {
    low_colour <- "blue"
    dots_env <- list2env(list(low_color = "orange", low_col = "purple"))
    low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env)
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_col", dots_env), class = "alias_conflict")
    expect_equal(low_colour, "orange")
})

test_that("alias management works, cascading", {
    low_colour <- "blue"
    dots_env <- list2env(list(low_col = "purple"))
    low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env)
    low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_col", dots_env)
    expect_equal(low_colour, "purple")
})

test_that("alias management works, documentation example", {
    low_colour <- "blue" ## e.g. default value from function call
    dots_env <- list2env(list(low_color = "pink")) ## presumes low_color = "pink" was set in function call
    low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env)
    expect_equal(low_colour, "pink")
})

test_that("alias management works, alias map documentation example", {
    ## Alias map (from within function code)
    alias_map <- list(
        low_colour = list(default = "blue", aliases = c("low_color", "low_col")),
        high_colour = list(default = "red", aliases = c("high_color", "high_col"))
    )

    ## Default values (would come from formal arguments)
    low_colour = "blue" ## default
    high_colour = "green" ## changed from default

    ## Extra arguments provided by name
    dots_env <- list2env(list("low_col" = "black", "low_color" = "white", "high_color" = "orange"))

    ## Process
    expect_warning(expect_warning(
        resolve_alias_map(alias_map, dots_env),
        class = "alias_conflict"), class = "alias_conflict"
    )

    ## See values
    expect_equal(low_colour, "white")
    expect_equal(high_colour, "green")
})

## Test converting base to number
test_that("converting base to number works when expected to", {
    expect_equal(convert_base_to_number("A"), 1)
    expect_equal(convert_base_to_number("u"), 4)
})

test_that("converting base to number fails with expected errors", {
    expect_error(convert_base_to_number("x"), class = "argument_value_or_type")
    expect_error(convert_base_to_number(""), class = "argument_value_or_type")
    expect_error(convert_base_to_number(3), class = "argument_value_or_type")
    expect_error(convert_base_to_number(c("T", "A")), class = "argument_length")
})



## Test converting whole sequence to numbers
test_that("converting sequence to numbers works when expected to", {
    expect_equal(convert_sequence_to_numbers("ATACG"), c(1, 4, 1, 2, 3))
    expect_equal(convert_sequence_to_numbers("ATU", 5), c(1, 4, 4, 0, 0))
    expect_equal(convert_sequence_to_numbers("uagCGAGc", 3), c(4, 1, 3))
    expect_equal(convert_sequence_to_numbers("uagCGAGc", 3L), c(4, 1, 3))
    expect_equal(convert_sequence_to_numbers("uagCGAGc", 0), numeric(0))
    expect_equal(convert_sequence_to_numbers("uagCGAGc", NA), c(4, 1, 3, 2, 3, 1, 3, 2))
    expect_equal(convert_sequence_to_numbers(""), numeric(0))
})

test_that("converting sequence to numbers fails with expected errors", {
    expect_error(convert_sequence_to_numbers("uagCGAGc", 3.5), class = "argument_value_or_type")
    expect_error(convert_sequence_to_numbers("uagCGAGc", -1), class = "argument_value_or_type")
    expect_error(convert_sequence_to_numbers("uagCGAGc", c(1, 2)), class = "argument_length")
    expect_error(convert_sequence_to_numbers("uagCGAGc", -1.5), class = "argument_value_or_type")
    expect_error(convert_sequence_to_numbers("AGGCAC", "x"), class = "argument_value_or_type")
    expect_error(convert_sequence_to_numbers("ATACGx"), class = "argument_value_or_type")
    expect_error(convert_sequence_to_numbers(c("ATCG", "GGGG")), class = "argument_length")
})




## Test creating image data from sequences vector
test_that("creating image data from sequences vector works", {
    expect_equal(create_image_data(c("ATCG", "", "GGGG", "")),
                 data.frame(x = c(0.125, 0.375, 0.625, 0.875, 0.125, 0.375, 0.625, 0.875, 0.125, 0.375, 0.625, 0.875, 0.125, 0.375, 0.625, 0.875),
                            y = c(0.875, 0.875, 0.875, 0.875, 0.625, 0.625, 0.625, 0.625, 0.375, 0.375, 0.375, 0.375, 0.125, 0.125, 0.125, 0.125),
                            value = c(1, 4, 2, 3, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0))
                 )
    expect_equal(create_image_data(c("A", "", "", "", "UG")),
                 data.frame(x = c(0.25, 0.75, 0.25, 0.75, 0.25, 0.75, 0.25, 0.75, 0.25, 0.75),
                            y = c(0.9, 0.9, 0.7, 0.7, 0.5, 0.5, 0.3, 0.3, 0.1, 0.1),
                            value = c(1, 0, 0, 0, 0, 0, 0, 0, 4, 3))
                 )
})

test_that("creating image data from sequences vector with expected errors", {
    expect_error(create_image_data(c(1, 2, 3)), class = "argument_value_or_type")
})


## Test rasterising matrices
test_that("rasterising matrices works", {
    example_matrix <- matrix(1:16, ncol = 4, nrow = 4, byrow = TRUE)
    expect_equal(rasterise_matrix(example_matrix),
                 data.frame(x = c(0.125, 0.375, 0.625, 0.875, 0.125, 0.375, 0.625, 0.875, 0.125, 0.375, 0.625, 0.875, 0.125, 0.375, 0.625, 0.875),
                            y = c(0.875, 0.875, 0.875, 0.875, 0.625, 0.625, 0.625, 0.625, 0.375, 0.375, 0.375, 0.375, 0.125, 0.125, 0.125, 0.125),
                            value = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)))

    example_matrix <- matrix(c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"), nrow = 2, ncol = 5, byrow = TRUE)
    expect_equal(rasterise_matrix(example_matrix),
                 data.frame(x = c(0.1, 0.3, 0.5, 0.7, 0.9, 0.1, 0.3, 0.5, 0.7, 0.9),
                            y = c(0.75, 0.75, 0.75, 0.75, 0.75, 0.25, 0.25, 0.25, 0.25, 0.25),
                            value = c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J")))

    dna_matrix <- matrix(
        c(0, 0, 0, 0, 0, 0, 0, 0,
          3, 3, 2, 3, 3, 2, 4, 4,
          0, 0, 0, 0, 0, 0, 0, 0,
          4, 1, 4, 1, 0, 0, 0, 0),
        nrow = 4, ncol = 8, byrow = TRUE
    )
    expect_equal(rasterise_matrix(dna_matrix),
                 data.frame(x = c(0.0625, 0.1875, 0.3125, 0.4375, 0.5625, 0.6875, 0.8125, 0.9375, 0.0625, 0.1875, 0.3125, 0.4375, 0.5625, 0.6875, 0.8125, 0.9375, 0.0625, 0.1875, 0.3125, 0.4375, 0.5625, 0.6875, 0.8125, 0.9375, 0.0625, 0.1875, 0.3125, 0.4375, 0.5625, 0.6875, 0.8125, 0.9375),
                            y = c(0.875, 0.875, 0.875, 0.875, 0.875, 0.875, 0.875, 0.875, 0.625, 0.625, 0.625, 0.625, 0.625, 0.625, 0.625, 0.625, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.375, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125),
                            value = c(0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 2, 3, 3, 2, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 4, 1, 0, 0, 0, 0)))
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


test_that("creating sequence matrix works", {
    expect_equal(convert_sequences_to_matrix(c("GGCGGC", "", "ACGT", "")),
                 matrix(c("G", "G", "C", "G", "G", "C",
                          NA, NA, NA, NA, NA, NA,
                          "A", "C", "G", "T", NA, NA,
                          NA, NA, NA, NA, NA, NA),
                        nrow = 4, ncol = 6, byrow = TRUE))

    expect_equal(convert_sequences_to_matrix(c("GGCGGC", "", "ACGT", ""), 8, "X"),
                 matrix(c("G", "G", "C", "G", "G", "C", "X", "X",
                          "X", "X", "X", "X", "X", "X", "X", "X",
                          "A", "C", "G", "T", "X", "X", "X", "X",
                          "X", "X", "X", "X", "X", "X", "X", "X"),
                        nrow = 4, ncol = 8, byrow = TRUE))
})

test_that("creating sequence matrix rejects bad arguments", {
    bad_param_value_for_char <- list(list("x"), TRUE, NA, NULL, c(NA, "X"), 1, 0.5, -1)
    for (param in bad_param_value_for_char) {
        expect_error(convert_sequences_to_matrix(param), class = "argument_value_or_type")
    }

    bad_param_value_for_pos_int_na_allowed <- list(list(1), 0, 0.5, -1, c(1, 2), TRUE)
    for (param in bad_param_value_for_pos_int_na_allowed) {
        expect_error(convert_sequences_to_matrix("GGC", param))
    }

    bad_param_value_for_single <- list(c(1, 2), c("x", "y"))
    for (param in bad_param_value_for_single) {
        expect_error(convert_sequences_to_matrix("GGC", blank_value = param))
    }
})

test_that("rasterising index annotations, full example", {
    ## Set up arguments (e.g. from visualise_many_sequences() call)
    sequences_data <- example_many_sequences
    index_annotation_lines <- c(1, 23, 37)
    index_annotation_interval <- 10
    index_annotations_above <- TRUE
    index_annotation_full_line <- FALSE
    index_annotation_always_first_base <- FALSE
    index_annotation_always_last_base <- FALSE
    index_index_annotation_vertical_position <- 1/3

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
        vert = index_index_annotation_vertical_position
    )

    ## Create annnotation dataframe
    d <- rasterise_index_annotations(
        new_sequences_vector = new_sequences,
        original_sequences_vector = sequences,
        index_annotation_lines= index_annotation_lines,
        index_annotation_interval = 10,
        index_annotation_full_line = index_annotation_full_line,
        index_annotations_above = index_annotations_above,
        index_annotation_vertical_position = index_index_annotation_vertical_position,
        index_annotation_always_first_base = index_annotation_always_first_base,
        index_annotation_always_last_base = index_annotation_always_last_base
    )

    ## Test
    expect_equal(d, data.frame(
        x = c(0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157),
        y = c(0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.987654320987654, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.561728395061728, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951, 0.283950617283951),
        value = c("10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "10", "20", "30", "40", "50", "60", "70", "80", "90", "10", "20", "30", "40", "50", "60", "70", "80", "90")
    ))


    ## Extra tests for returning blank dataframe
    blank_data <- data.frame("x" = numeric(), "y" = numeric(), "value" = character())
    expect_equal(rasterise_index_annotations(new_sequences, sequences, index_annotation_interval = 0, index_annotation_lines= numeric()), blank_data)
    expect_equal(rasterise_index_annotations(new_sequences, sequences, index_annotation_interval = 10, index_annotation_lines= numeric()), blank_data)
    expect_equal(rasterise_index_annotations(new_sequences, sequences, index_annotation_interval = 0, index_annotation_lines= c(1, 2, 3)), blank_data)
})


test_that("rasterising index annotations works, offset and spacing", {
    ## Set up arguments (e.g. from visualise_many_sequences() call)
    sequences_data <- example_many_sequences
    index_annotation_lines <- c(1, 23, 37)
    index_annotation_interval <- 10
    index_annotations_above <- TRUE
    index_annotation_full_line <- FALSE
    index_annotation_always_first_base <- FALSE
    index_annotation_always_last_base <- FALSE
    index_index_annotation_vertical_position <- 1/3
    offset <- 1
    spacing <- 2

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
        vert = spacing
    )

    ## Offset start by 1
    new_sequences <- tail(new_sequences, -offset)

    ## Create annnotation dataframe
    d <- rasterise_index_annotations(
        new_sequences_vector = new_sequences,
        original_sequences_vector = sequences,
        index_annotation_lines= index_annotation_lines,
        index_annotation_interval = 10,
        index_annotation_full_line = index_annotation_full_line,
        index_annotations_above = index_annotations_above,
        index_annotation_vertical_position = index_index_annotation_vertical_position,
        sum_indices = TRUE,
        spacing = 2,
        offset_start = 1,
        index_annotation_always_first_base = index_annotation_always_first_base,
        index_annotation_always_last_base = index_annotation_always_last_base
    )

    expect_equal(d, data.frame(
        x = c(0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157),
        y = c(0.988095238095238, 0.988095238095238, 0.988095238095238, 0.988095238095238, 0.988095238095238, 0.988095238095238, 0.988095238095238, 0.988095238095238, 0.988095238095238, 0.988095238095238, 0.55952380952381, 0.55952380952381, 0.55952380952381, 0.55952380952381, 0.55952380952381, 0.55952380952381, 0.55952380952381, 0.55952380952381, 0.55952380952381, 0.273809523809524, 0.273809523809524, 0.273809523809524, 0.273809523809524, 0.273809523809524, 0.273809523809524, 0.273809523809524, 0.273809523809524, 0.273809523809524),
        value = c("10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "112", "122", "132", "142", "152", "162", "172", "182", "192", "205", "215", "225", "235", "245", "255", "265", "275", "285")
    ))
})

test_that("rasterising index annotations works, below", {
    ## Set up arguments (e.g. from visualise_many_sequences() call)
    sequences_data <- example_many_sequences
    index_annotation_lines <- c(1, 23, 37)
    index_annotation_interval <- 10
    index_annotations_above <- FALSE
    index_annotation_full_line <- TRUE
    index_annotation_always_first_base <- FALSE
    index_annotation_always_last_base <- FALSE
    index_index_annotation_vertical_position <- 1/3

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
        vert = index_index_annotation_vertical_position
    )

    ## Create annnotation dataframe
    d <- rasterise_index_annotations(
        new_sequences_vector = new_sequences,
        original_sequences_vector = sequences,
        index_annotation_lines = index_annotation_lines,
        index_annotation_interval = 10,
        index_annotation_full_line = index_annotation_full_line,
        index_annotations_above = index_annotations_above,
        index_annotation_vertical_position = index_index_annotation_vertical_position,
        index_annotation_always_first_base = index_annotation_always_first_base,
        index_annotation_always_last_base = index_annotation_always_last_base
    )

    ## Test
    expect_equal(d, data.frame(
        x = c(0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431),
        y = c(0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605),
        value = c("10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100")
    ))
})

test_that("rasterising index annotations works, forcing first and last", {
    ## Set up arguments (e.g. from visualise_many_sequences() call)
    sequences_data <- example_many_sequences
    index_annotation_lines <- c(1, 23, 37)
    index_annotation_interval <- 10
    index_annotations_above <- FALSE
    index_annotation_full_line <- FALSE
    index_annotation_always_first_base <- TRUE
    index_annotation_always_last_base <- TRUE
    index_index_annotation_vertical_position <- 1/3

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
        vert = index_index_annotation_vertical_position
    )

    ## Create annnotation dataframe
    d <- rasterise_index_annotations(
        new_sequences_vector = new_sequences,
        original_sequences_vector = sequences,
        index_annotation_lines = index_annotation_lines,
        index_annotation_interval = 10,
        index_annotation_full_line = index_annotation_full_line,
        index_annotations_above = index_annotations_above,
        index_annotation_vertical_position = index_index_annotation_vertical_position,
        index_annotation_always_first_base = index_annotation_always_first_base,
        index_annotation_always_last_base = index_annotation_always_last_base
    )

    ## Test
    expect_equal(d, data.frame(
        x = c(0.00490196078431373, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.975490196078431, 0.995098039215686, 0.00490196078431373, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.906862745098039, 0.00490196078431373, 0.0931372549019608, 0.191176470588235, 0.28921568627451, 0.387254901960784, 0.485294117647059, 0.583333333333333, 0.681372549019608, 0.779411764705882, 0.877450980392157, 0.936274509803922),
        y = c(0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.975308641975309, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.549382716049383, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605, 0.271604938271605),
        value = c("1", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100", "102", "1", "10", "20", "30", "40", "50", "60", "70", "80", "90", "93", "1", "10", "20", "30", "40", "50", "60", "70", "80", "90", "96")
    ))
})


test_that("rasterising index annotations fails when needed", {
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
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_lines = param, index_annotation_interval = 1), class = "argument_value_or_type")
    }

    bad_param_value_for_bool <- list("X", 1, c(TRUE, FALSE), list(TRUE, FALSE), NA, NULL, -1)
    for (param in bad_param_value_for_bool) {
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_full_line = param, index_annotation_lines = 1, index_annotation_interval = 1), class = "argument_value_or_type")
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotations_above = param, index_annotation_lines = 1, index_annotation_interval = 1), class = "argument_value_or_type")
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_always_first_base = param, index_annotation_lines= 1, index_annotation_interval = 1), class = "argument_value_or_type")
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_always_last_base = param, index_annotation_lines= 1, index_annotation_interval = 1), class = "argument_value_or_type")
        expect_error(rasterise_index_annotations(sequences, new_sequences, sum_indices = param, index_annotation_lines= 1, index_annotation_interval = 1), class = "argument_value_or_type")
    }

    bad_param_value_for_non_neg_int <- list("X", TRUE, NA, list(1), -1, c(2, 0), c(2, 1), c(1, 1, 2), 0.5, NULL)
    for (param in bad_param_value_for_non_neg_int) {
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_lines = 1, index_annotation_interval = param), class = "argument_value_or_type")
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_lines = 1, offset_start = param), class = "argument_value_or_type")
    }

    bad_param_value_for_non_neg_int_na_allowed <- list("X", TRUE, list(1), -1, c(2, 0), c(2, 1), c(1, 1, 2), 0.5, NULL)
    for (param in bad_param_value_for_non_neg_int_na_allowed) {
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_lines = 1, spacing = param), class = "argument_value_or_type")
    }

    bad_param_value_for_non_neg_num <- list("X", TRUE, NA, list(1), -1, c(2, 0), c(2, 1), c(1, 1, 2))
    for (param in bad_param_value_for_non_neg_num) {
        expect_error(rasterise_index_annotations(sequences, new_sequences, index_annotation_vertical_position = param, index_annotation_lines = 1, index_annotation_interval = 1), class = "argument_value_or_type")
    }
})
