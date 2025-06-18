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

