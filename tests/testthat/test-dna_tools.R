## Test reverse complementing
test_that("reverse complementing works when expected to", {
    expect_equal(reverse_complement("ATUCG"), "CGAAT")
    expect_equal(reverse_complement("ATUCG", "RNA"), "CGAAU")
    expect_equal(reverse_complement("atagc", "dNa"), "GCTAT")
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
    expect_error(bad_arg("x", list(x = 1), "is bad lol", "hi"), class = "hi", regexp = "*Argument 'x' is bad lol\nCurrent value: 1*")
    expect_error(bad_arg("x", list(x = 1), "is bad lol", "hi", TRUE), class = "hi", regexp = "*Argument 'x' is bad lol\nCurrent value: 1\nCurrent names: *")
    expect_error(bad_arg("x", list(x = c("item 1" = 1, "item 2" = 7)), "is bad lol", "hi"), class = "hi", regexp = "*Argument 'x' is bad lol\nCurrent value: 1, 7\nCurrent names: item 1, item 2*")
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
    dots <- list(low_color = "orange")
    low_colour <- resolve_alias("low_colour", low_colour, "low_color", dots$low_color, "blue")
    expect_equal(low_colour, "orange")
})

test_that("alias management works, canonical changed", {
    low_colour <- "red"
    dots <- list(low_color = "orange")
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "low_color", dots$low_color, "blue"), class = "alias_conflict")
    expect_equal(low_colour, "red")
})

test_that("alias management works, canonical always wins", {
    low_colour <- "green"
    dots <- list(low_color = "orange", low_col = "purple")
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "low_color", dots$low_color, "blue"), class = "alias_conflict")
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "low_col", dots$low_col, "blue"), class = "alias_conflict")
    expect_equal(low_colour, "green")
})

test_that("alias management works, cascading", {
    low_colour <- "blue"
    dots <- list(low_color = "orange", low_col = "purple")
    low_colour <- resolve_alias("low_colour", low_colour, "low_color", dots$low_color, "blue")
    expect_warning(low_colour <- resolve_alias("low_colour", low_colour, "low_col", dots$low_col, "blue"), class = "alias_conflict")
    expect_equal(low_colour, "orange")
})

test_that("alias management works, cascading", {
    low_colour <- "blue"
    dots <- list(low_col = "purple")
    low_colour <- resolve_alias("low_colour", low_colour, "low_color", dots$low_color, "blue")
    low_colour <- resolve_alias("low_colour", low_colour, "low_col", dots$low_col, "blue")
    expect_equal(low_colour, "purple")
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
                            layer = c(1, 4, 2, 3, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0))
                 )
    expect_equal(create_image_data(c("A", "", "", "", "UG")),
                 data.frame(x = c(0.25, 0.75, 0.25, 0.75, 0.25, 0.75, 0.25, 0.75, 0.25, 0.75),
                            y = c(0.9, 0.9, 0.7, 0.7, 0.5, 0.5, 0.3, 0.3, 0.1, 0.1),
                            layer = c(1, 0, 0, 0, 0, 0, 0, 0, 4, 3))
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
                            layer = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)))

    example_matrix <- matrix(c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"), nrow = 2, ncol = 5, byrow = TRUE)
    expect_equal(rasterise_matrix(example_matrix),
                 data.frame(x = c(0.1, 0.3, 0.5, 0.7, 0.9, 0.1, 0.3, 0.5, 0.7, 0.9),
                            y = c(0.75, 0.75, 0.75, 0.75, 0.75, 0.25, 0.25, 0.25, 0.25, 0.25),
                            layer = c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J")))

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
                            layer = c(0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 2, 3, 3, 2, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1, 4, 1, 0, 0, 0, 0)))
})
