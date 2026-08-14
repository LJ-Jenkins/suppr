test_that("is.nonfinite() detects non-finite values", {
  expect_identical(is.nonfinite(1:5), rep(FALSE, 5))
  expect_identical(
    is.nonfinite(c(1, 2, NA_real_, Inf, NaN)),
    c(FALSE, FALSE, TRUE, TRUE, TRUE)
  )
  expect_identical(is.nonfinite(c(1, 2, -Inf)), c(FALSE, FALSE, TRUE))
  expect_identical(is.nonfinite(c(1, 2, 3)), c(FALSE, FALSE, FALSE))
  expect_identical(is.nonfinite(c(1 + 0i, NA + 0i)), c(FALSE, TRUE))
  expect_identical(is.nonfinite(c(1L, NA_integer_)), c(FALSE, TRUE))
  expect_identical(is.nonfinite(c(TRUE, FALSE, NA)), c(FALSE, FALSE, TRUE))
})

test_that("is.nonfinite() returns 0 for empty inputs", {
  expect_identical(is.nonfinite(numeric(0)), logical(0))
})

test_that("is.nonfinite() works on logical, numeric and complex types", {
  for (tst in list(
    1:10, 1L:10, c(1 + 0i, 2 + 0i, NA_complex_), c(TRUE, FALSE, NA),
    factor(c("a", "b", "c"))
  )) {
    expect_no_error(is.nonfinite(tst))
  }
})

test_that("is.nonfinite() returns all TRUE for chr, raw", {
  for (tst in list(letters, raw(26))) {
    expect_identical(is.nonfinite(tst), rep(TRUE, 26))
  }
})

test_that("is.nonfinite() errors on incorrect types", {
  for (tst in list(
    list(1:10), environment(), mean, data.frame(x = 1), call("mean")
  )) {
    expect_error(is.nonfinite(tst))
  }
})

test_that("is.nonfinite() works on POSIXlt objects", {
  x <- as.POSIXlt(c("2020-01-01", "2020-01-02", NA))
  expect_identical(is.nonfinite(x), c(FALSE, FALSE, TRUE))
})
