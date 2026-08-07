test_that("setNA() tests", {
  expect_identical(
    setNA(1:5, c(2, 4)),
    c(1L, NA_integer_, 3L, NA_integer_, 5L)
  )

  m <- matrix(1:9, nrow = 3, ncol = 3)
  expect_equal(
    setNA(m, c(1, 5, 9)),
    matrix(c(NA, 2, 3, 4, NA, 6, 7, 8, NA), nrow = 3, ncol = 3)
  )

  x <- letters[1:4]
  setNA(x) <- c(1, 3)
  expect_identical(x, c(NA_character_, "b", NA_character_, "d"))

  lst <- list(1, 2, 3)
  expect_identical(setNA(lst, 2), list(1, NA, 3))
})

test_that("setNA() works for vector types", {
  expect_identical(setNA(1:5, 2), c(1L, NA_integer_, 3L, 4L, 5L))
  expect_identical(setNA(c(TRUE, FALSE), 1), c(NA, FALSE))
  expect_identical(setNA(c(1.5, 2.5), 2), c(1.5, NA_real_))
  expect_identical(setNA(c("a", "b"), 1), c(NA_character_, "b"))
  expect_identical(setNA(c(1 + 0i, 2 + 0i), 2), c(1 + 0i, NA_complex_))
})

test_that("setNA() works for types with dims", {
  m <- matrix(1:4, nrow = 2, ncol = 2)
  expect_identical(
    setNA(m, c(1, 4)),
    matrix(c(NA_integer_, 2L, 3L, NA_integer_), nrow = 2, ncol = 2)
  )

  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  expect_identical(
    setNA(df, c(2, 5)),
    data.frame(x = c(1L, NA, 3L), y = c("a", NA_character_, "c"))
  )

  arr <- array(1:8, dim = c(2, 2, 2))
  expect_identical(
    setNA(arr, 3),
    array(c(1L, 2L, NA, 4L, 5L, 6L, 7L, 8L), dim = c(2, 2, 2))
  )
})

test_that("setNA<-() works for vector types", {
  x <- 1:5
  setNA(x) <- c(2, 4)
  expect_identical(x, c(1L, NA_integer_, 3L, NA_integer_, 5L))

  y <- c(TRUE, FALSE)
  setNA(y) <- 1
  expect_identical(y, c(NA, FALSE))

  z <- c("a", "b")
  setNA(z) <- 2
  expect_identical(z, c("a", NA_character_))
})

test_that("setNA<-() works for types with dims", {
  m <- matrix(1:4, nrow = 2, ncol = 2)
  setNA(m) <- c(1, 4)
  expect_identical(
    m,
    matrix(c(NA_integer_, 2L, 3L, NA_integer_), nrow = 2, ncol = 2)
  )

  df <- data.frame(x = 1:3, y = c("a", "b", "c"))
  setNA(df) <- c(2, 5)
  expect_identical(
    df,
    data.frame(x = c(1L, NA, 3L), y = c("a", NA_character_, "c"))
  )

  arr <- array(1:8, dim = c(2, 2, 2))
  setNA(arr) <- 3
  expect_identical(
    arr,
    array(c(1L, 2L, NA, 4L, 5L, 6L, 7L, 8L), dim = c(2, 2, 2))
  )
})
