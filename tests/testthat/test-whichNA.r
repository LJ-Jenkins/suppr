test_that("whichNA() return correct indices", {
  x <- c(3, 1, 4, NA, 5, 9, NA, 6, 5, 9)
  expect_identical(whichNA(x), which(is.na(x)))
})

test_that("whichNA() also flags NaN's", {
  y <- c(1, Inf, -Inf, NaN, NA, 5)
  expect_identical(whichNA(y), which(is.na(y)))
})

test_that("empty input or no NA returns empty logical", {
  for (tst in list(
    numeric(0), integer(0), logical(0), character(0), list(),
    1:10, 1L:10, c(TRUE, FALSE), c(1.5, 2.5, 3.5), c("a", "b", "c")
  )) {
    expect_identical(whichNA(tst), which(is.na(tst)))
  }
})

test_that("work on numeric, logical, complex, chr, list, pairlist types", {
  # !Rf_isNumber(x) && TYPEOF(x) != STRSXP && TYPEOF(x) != VECSXP && TYPEOF(x) != LISTSXP
  for (tst in list(
    c(1.5, 2.5, NA), c(1L:3L, NA), c(TRUE, FALSE, NA), c("a", "b", NA),
    c(1 + 0i, 2 + 0i, NA), list(1, 2, NA), pairlist(a = 1, b = NA)
  )) {
    expect_identical(whichNA(tst), which(is.na(tst)))
  }
})

test_that("errors if wrong type", {
  for (tst in list(
    environment(), mean, call("mean")
  )) {
    expect_error(whichNA(tst))
  }
})

test_that("preserves names of input vector", {
  x <- c(a = 3, b = 1, b = 1, c = 4, d = 9, e = 9)
  nms <- names(x)
  expect_identical(names(whichNA(x)), names(which(is.na(x))))

  x <- list(a = 1, b = 2, c = NA, d = 4)
  nms <- names(x)
  expect_identical(names(whichNA(x)), names(which(is.na(x))))
})

test_that("whichNA<-() replaces NA values correctly", {
  x <- c(1, NA, 3, NA, 5)
  whichNA(x) <- 0
  expect_identical(x, c(1, 0, 3, 0, 5))

  y <- c("a" = 1, "b" = NA, "c" = 2, "d" = NA, "e" = NA, "f" = NA)
  whichNA(y) <- c(91, 92) # value recycled to number of NA's
  expect_identical(
    y,
    c("a" = 1, "b" = 91, "c" = 2, "d" = 92, "e" = 91, "f" = 92)
  )
})
