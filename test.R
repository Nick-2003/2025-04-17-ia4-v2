expect_equal(is_leap(1802), FALSE)

expect_type(is_leap(1992), "logical")

expect_error(is_leap(-2000))