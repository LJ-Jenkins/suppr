test_that("is.even() and is.odd() classify parity", {
  x <- c(-2L, -1L, 0L, 1L, 2L)

  expect_identical(is.even(x), c(TRUE, FALSE, TRUE, FALSE, TRUE))
  expect_identical(is.odd(x), c(FALSE, TRUE, FALSE, TRUE, FALSE))
})

test_that("noparity.na controls how non-parity values are treated", {
  x <- c(2, 3, 2.2, NA, Inf, -Inf, NaN)

  expect_identical(
    is.even(x),
    c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)
  )

  expect_identical(
    is.odd(x),
    c(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE)
  )

  expect_identical(
    is.even(x, noparity.na = TRUE),
    c(TRUE, FALSE, NA, NA, NA, NA, NA)
  )

  expect_identical(
    is.odd(x, noparity.na = TRUE),
    c(FALSE, TRUE, NA, NA, NA, NA, NA)
  )
})

test_that("is.even() and is.odd() return logical(0) for empty inputs", {
  expect_identical(is.even(numeric(0)), logical(0))
  expect_identical(is.odd(numeric(0)), logical(0))
})

test_that("is.even() and is.odd() work on logical and numeric types", {
  for (tst in list(
    1.5:10.5, 1L:10, c(TRUE, FALSE, NA), matrix(1:10, nrow = 2),
    array(1:10, dim = c(2, 5))
  )) {
    expect_no_error(is.even(tst))
    expect_no_error(is.odd(tst))
  }
})

test_that("is.even() and is.odd() error on incorrect types", {
  for (tst in list(
    list(1:10), environment(), mean, data.frame(x = 1), call("mean"),
    c("1", "2", "3"), factor(c("a", "b", "c")), c(1 + 0i, 2 + 0i, NA_complex_),
    raw(10)
  )) {
    expect_error(is.even(tst))
    expect_error(is.odd(tst))
  }
})

test_that("is.even() and is.odd() preserve names", {
  x <- c(a = 2, b = 3, c = 4)

  expect_named(is.even(x), names(x))
  expect_named(is.odd(x), names(x))
})
