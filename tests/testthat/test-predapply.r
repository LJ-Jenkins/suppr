test_that("predapply() returns element-wise logical output", {
  x_list <- list(a = 1, b = 2, c = "z")
  expect_identical(
    predapply(x_list, is.numeric),
    c(a = TRUE, b = TRUE, c = FALSE)
  )

  x_vec <- c(a = 1, b = 2, c = 3)
  expect_identical(
    predapply(x_vec, function(x) x > 1),
    c(a = FALSE, b = TRUE, c = TRUE)
  )
})

test_that("predapply() forwards ... to FUN", {
  x <- list("a", "bb", "ccc")

  expect_identical(
    predapply(x, function(x, n) nchar(x) >= n, n = 2),
    c(FALSE, TRUE, TRUE)
  )
})

test_that("predapply() na.as controls missing values in output", {
  x <- c(1, NA, 2)
  pred <- function(x) x > 0

  expect_identical(predapply(x, pred), c(TRUE, NA, TRUE))
  expect_identical(predapply(x, pred, na.as = FALSE), c(TRUE, FALSE, TRUE))
  expect_identical(predapply(x, pred, na.as = TRUE), c(TRUE, TRUE, TRUE))

  x_all <- c(1, NA)

  expect_identical(predapply(x_all, pred, reduce = "all"), NA)
  expect_identical(predapply(x_all, pred, reduce = "all", na.as = FALSE), FALSE)
  expect_identical(predapply(x_all, pred, reduce = "all", na.as = TRUE), TRUE)

  x_any_none <- c(-1, NA)

  expect_identical(
    predapply(x_any_none, pred, reduce = "any"),
    NA
  )
  expect_identical(
    predapply(x_any_none, pred, reduce = "any", na.as = FALSE),
    FALSE
  )
  expect_identical(
    predapply(x_any_none, pred, reduce = "any", na.as = TRUE), TRUE
  )

  expect_identical(
    predapply(x_any_none, pred, reduce = "none"),
    NA
  )
  expect_identical(
    predapply(x_any_none, pred, reduce = "none", na.as = FALSE),
    TRUE
  )
  expect_identical(
    predapply(x_any_none, pred, reduce = "none", na.as = TRUE),
    FALSE
  )
})

test_that("predapply() reduce supports all/any/none", {
  x <- list(a = 1, b = "x", c = 2)

  expect_identical(predapply(x, is.numeric, reduce = "all"), FALSE)
  expect_identical(predapply(x, is.numeric, reduce = "any"), TRUE)
  expect_identical(predapply(x, is.numeric, reduce = "none"), FALSE)

  y <- list("a", "b")
  expect_identical(predapply(y, is.numeric, reduce = "all"), FALSE)
  expect_identical(predapply(y, is.numeric, reduce = "any"), FALSE)
  expect_identical(predapply(y, is.numeric, reduce = "none"), TRUE)
})


test_that("predapply() validates reduce, na.as and FUN output shape", {
  expect_error(predapply(1:3, is.numeric, reduce = "invalid"))
  expect_error(predapply(1:3, is.numeric, na.as = "FALSE"))
  expect_error(predapply(1:3, is.numeric, na.as = c(TRUE, FALSE)))
  expect_snapshot(error = TRUE, {
    predapply(1:3, is.numeric, reduce = "invalid")
  })

  expect_error(predapply(1:3, function(x) c(TRUE, FALSE)))
  expect_error(predapply(1:3, function(x) 1L))
})
