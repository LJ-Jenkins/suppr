test_that("enumerate() pairs indices with values", {
  x <- c(alpha = "a", beta = "b", "c")

  expect_identical(
    enumerate(x),
    list(
      list(idx = 1L, val = "a", name = "alpha"),
      list(idx = 2L, val = "b", name = "beta"),
      list(idx = 3L, val = "c", name = "")
    )
  )
  expect_identical(enumerate(character()), list())
})

test_that("dims() returns dimensions or length and 0", {
  expect_identical(dims(matrix(1:6, nrow = 2)), c(2L, 3L))
  expect_identical(dims(array(1:8, dim = c(2, 2, 2))), c(2L, 2L, 2L))
  expect_identical(dims(1:5), c(5L, 0L))
  expect_identical(dims(list(a = 1, b = 2, c = 3)), c(3L, 0L))
})

test_that("path() combines and normalizes path components", {
  expect_identical(
    path("foo", "bar", mustWork = FALSE),
    normalizePath(file.path("foo", "bar"), mustWork = FALSE)
  )

  expect_identical(
    path("foo", "bar", "baz.txt", mustWork = FALSE),
    normalizePath(file.path("foo", "bar", "baz.txt"), mustWork = FALSE)
  )

  expect_identical(
    path("foo", "bar", mustWork = FALSE),
    normalizePath(file.path("foo", "bar"), mustWork = FALSE)
  )

  expect_identical(
    path("foo", "bar", "baz.txt", mustWork = FALSE),
    normalizePath(file.path("foo", "bar", "baz.txt"), mustWork = FALSE)
  )

  expect_identical(
    path("foo", "bar", "baz.txt", sharedDrive = TRUE, mustWork = FALSE),
    normalizePath(
      file.path(.Platform$file.sep, "foo", "bar", "baz.txt"),
      mustWork = FALSE
    )
  )
})
