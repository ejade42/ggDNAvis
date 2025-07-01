test_that("helper function for constructing MM vector works", {
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", c(6,9), "C"),
                 c(1, 0))
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", c(9), "C"),
                 c(2))
    expect_equal(convert_locations_to_MM_vector("GGCGGCGGC", numeric(), "C"),
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

    bad_param_value_for_locations <- list("x", character(), NULL, NA, 0, 0.5, -1, c(3, 9), 3, 9)
    for (param in bad_param_value_for_locations) {
        expect_error(convert_locations_to_MM_vector("CGGCGGCGGC", param, "C"), class = "argument_value_or_type")
    }


})
