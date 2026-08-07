test_that("whichMin() and whichMax() return correct indices", {
  x <- c(3, 1, 4, 1, 5, 9, 2, 6, 5, 9)

  expect_identical(whichMin(x), which.min(x))
  expect_identical(whichMax(x), which.max(x))

  expect_identical(whichMin(x, loc = "last"), 4L)
  expect_identical(whichMax(x, loc = "last"), 10L)

  expect_identical(whichMin(x, loc = "all"), c(2L, 4L))
  expect_identical(whichMax(x, loc = "all"), c(6L, 10L))
})

test_that("empty input or no min/max returns empty logical", {
  for (tst in list(
    numeric(0), integer(0), logical(0), character(0),
    NaN, NA_real_, NA_integer_, NA_character_
  )) {
    expect_identical(whichMin(tst), which.min(tst))
    expect_identical(whichMax(tst), which.max(tst))

    expect_identical(whichMin(tst, loc = "last"), integer(0))
    expect_identical(whichMax(tst, loc = "last"), integer(0))

    expect_identical(whichMin(tst, loc = "all"), integer(0))
    expect_identical(whichMax(tst, loc = "all"), integer(0))
  }
})

test_that("Inf and -Inf are handled correctly", {
  x <- c(3, 1, 4, Inf, 5, 9, -Inf, 6, 5, 9)

  expect_identical(whichMin(x), which.min(x))
  expect_identical(whichMax(x), which.max(x))

  expect_identical(whichMin(x, loc = "last"), 7L)
  expect_identical(whichMax(x, loc = "last"), 4L)

  expect_identical(whichMin(x, loc = "all"), 7L)
  expect_identical(whichMax(x, loc = "all"), 4L)
})

test_that("work on numeric and logical types", {
  for (tst in list(
    1:10, 1L:10, c(TRUE, FALSE, NA)
  )) {
    expect_identical(whichMin(tst), which.min(tst))
    expect_identical(whichMax(tst), which.max(tst))
    expect_no_error(whichMin(tst, loc = "last"))
    expect_no_error(whichMax(tst, loc = "last"))
    expect_no_error(whichMin(tst, loc = "all"))
    expect_no_error(whichMax(tst, loc = "all"))
  }
})

test_that("coerces to numeric where possible", {
  for (tst in list(
    c(1 + 0i, 2 + 0i, NA_complex_), list(1, 2, 3), c("1", "2", "3"),
    data.frame(x = 1, y = 2, z = 3), factor(c("a", "b", "c"))
  )) {
    expect_identical(whichMin(tst), which.min(tst))
    expect_identical(whichMax(tst), which.max(tst))
    expect_no_error(whichMin(tst, loc = "last"))
    expect_no_error(whichMax(tst, loc = "last"))
    expect_no_error(whichMin(tst, loc = "all"))
    expect_no_error(whichMax(tst, loc = "all"))
  }
})

test_that("errors if numeric coercion not possible", {
  for (tst in list(
    environment(), mean, call("mean"), data.frame(x = 1:3),
    list(1:3)
  )) {
    expect_error(whichMin(tst))
    expect_error(whichMax(tst))
    expect_error(whichMin(tst, loc = "last"))
    expect_error(whichMax(tst, loc = "last"))
    expect_error(whichMin(tst, loc = "all"))
    expect_error(whichMax(tst, loc = "all"))
  }
})

test_that("preserves names of input vector", {
  x <- c(a = 3, b = 1, b = 1, c = 4, d = 9, e = 9)
  nms <- names(x)
  expect_identical(names(whichMin(x)), names(which.min(x)))
  expect_identical(names(whichMax(x)), names(which.max(x)))

  expect_identical(names(whichMin(x, loc = "last")), nms[3L])
  expect_identical(names(whichMax(x, loc = "last")), nms[6L])

  expect_identical(names(whichMin(x, loc = "all")), nms[c(2L, 3L)])
  expect_identical(names(whichMax(x, loc = "all")), nms[c(5L, 6L)])
})

test_that("whichMin<- and whichMax<- modify the correct elements", {
  x <- c(3, 1, 4, 1, 5, 9, 2, 6, 5, 9)

  x1 <- x
  whichMin(x1) <- -999
  expect_identical(x1[2], -999)

  x2 <- x
  whichMax(x2) <- -999
  expect_identical(x2[6], -999)

  x3 <- x
  whichMin(x3, loc = "last") <- -999
  expect_identical(x3[4], -999)

  x4 <- x
  whichMax(x4, loc = "last") <- -999
  expect_identical(x4[10], -999)

  x5 <- x
  whichMin(x5, loc = "all") <- c(-999, 999)
  expect_identical(x5[c(2, 4)], c(-999, 999))

  x6 <- x
  whichMax(x6, loc = "all") <- c(-999, 999)
  expect_identical(x6[c(6, 10)], c(-999, 999))
})
