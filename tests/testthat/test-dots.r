test_that("dotsNames() returns chr", {
  f <- function(...) dotsNames(...)

  expect_identical(f(), character(0))
  expect_identical(f(, , ), character(3))
  expect_identical(f(1, 2, 3), character(3))
  expect_identical(f(a = 1, b = 2, 3), c("a", "b", ""))
})

test_that("subDots() returns named list", {
  f <- function(...) subDots(...)

  expect_identical(f(), list())
  expect_identical(f(1, 2, 3), list(1, 2, 3))
  expect_identical(f(a = 1, b = 2, 3), list(a = 1, b = 2, 3))
  expect_identical(
    f(1 + 1, x = 10, mean(1:10)),
    list(call("+", 1, 1), x = 10, call("mean", quote(1:10)))
  )
})

test_that("dp1Dots() returns named chr", {
  f <- function(...) dp1Dots(...)

  expect_identical(f(), character(0))
  expect_identical(f(, , ), character(3))
  expect_identical(f(1, 2, 3), c("1", "2", "3"))
  expect_identical(f(a = 1, b = 2, 3), c(a = "1", b = "2", "3"))
  expect_identical(
    f(1 + 1, x = 10, mean(1:10)),
    c("1 + 1", x = "10", "mean(1:10)")
  )
})

test_that("checkDots() warns", {
  f <- function(one, two, ...) checkDots(..., error = FALSE)

  expect_no_warning(f(on = 1, two = 2))
  expect_warning(f(on = 1, twoo = 2))
  expect_no_warning(f(1, 2))
  expect_warning(f(1, 2, 3))
  expect_warning(f(1, 2, x = 1))
  expect_snapshot({
    f(1, 2, 3, x = 1)
  })
})

test_that("checkDots() errors", {
  f <- function(one, two, ...) checkDots(...)

  expect_no_error(f(on = 1, two = 2))
  expect_error(f(on = 1, twoo = 2))
  expect_no_error(f(1, 2))
  expect_error(f(1, 2, 3))
  expect_error(f(1, 2, x = 1))
  expect_snapshot(error = TRUE, {
    f(1, 2, 3, x = 1)
  })
})

test_that("checkDots() ignores allowed named args", {
  f <- function(one, ...) checkDots(..., allowed = letters[1:3])

  expect_no_error(f(1, a = 1))
  expect_error(f(1, 2, b = 3))
  expect_error(f(1, a = 1, b = 2, c = 3, d = 4))
})
