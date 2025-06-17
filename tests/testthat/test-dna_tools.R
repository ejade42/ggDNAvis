test_that("reverse complementing works when expected to", {
    expect_equal(reverse_complement("ATUCG"), "CGAAT")
    expect_equal(reverse_complement("ATUCG", "RNA"), "CGAAU")
    expect_equal(reverse_complement("atagc", "dNa"), "GCTAT")
})

test_that("reverse complementing fails with expected errors", {
    expect_error(reverse_complement("ATCG", "x"), class = "argument_value_or_type")
    expect_error(reverse_complement("ATCGU", 3), class = "argument_value_or_type")
    expect_error(reverse_complement("X"), class = "argument_value_or_type")
})

