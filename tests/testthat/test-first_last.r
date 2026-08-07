test_that("rm.first() dispatches correctly by input class", {
  x <- setNames(1:5, letters[1:5])
  expect_identical(rm.first(x, 2), x[-(1:2)])

  lst <- list(a = 1, b = 2, c = 3, d = 4)
  expect_identical(rm.first(lst, 2), list(c = 3, d = 4))

  m <- matrix(1:6, nrow = 3)
  dimnames(m) <- list(c("r1", "r2", "r3"), c("x", "y"))
  expect_identical(rm.first(m, 1), m[-1, , drop = FALSE])

  arr <- array(1:24, dim = c(4, 2, 3))
  dimnames(arr) <- list(
    c("r1", "r2", "r3", "r4"),
    c("x", "y"),
    c("z1", "z2", "z3")
  )
  expect_identical(rm.first(arr, 2), arr[-(1:2), , , drop = FALSE])

  df <- data.frame(a = 1:3, b = 4:6)
  rownames(df) <- c("r1", "r2", "r3")
  expect_identical(rm.first(df, 1), df[-1, , drop = FALSE])
})

test_that("rm.first() errors for unsupported classes", {
  env <- new.env(parent = emptyenv())
  expect_error(rm.first(env, 1), "atomic vectors and lists")
})

test_that("rm.first<- assignment dispatches correctly by input class", {
  x <- setNames(1:5, letters[1:5])
  x_expected <- x[-(1:2)]
  rm.first(x) <- 2
  expect_identical(x, x_expected)

  lst <- list(a = 1, b = 2, c = 3, d = 4)
  lst_expected <- lst[-(1:2)]
  rm.first(lst) <- 2
  expect_identical(lst, lst_expected)

  m <- matrix(1:6, nrow = 3)
  dimnames(m) <- list(c("r1", "r2", "r3"), c("x", "y"))
  m_expected <- m[-1, , drop = FALSE]
  rm.first(m) <- 1
  expect_identical(m, m_expected)

  arr <- array(1:24, dim = c(4, 2, 3))
  dimnames(arr) <- list(
    c("r1", "r2", "r3", "r4"),
    c("x", "y"),
    c("z1", "z2", "z3")
  )
  arr_expected <- arr[-(1:2), , , drop = FALSE]
  rm.first(arr) <- 2
  expect_identical(arr, arr_expected)

  df <- data.frame(a = 1:3, b = 4:6)
  rownames(df) <- c("r1", "r2", "r3")
  df_expected <- df[-1, , drop = FALSE]
  rm.first(df) <- 1
  expect_identical(df, df_expected)
})

test_that("rm.last() dispatches correctly by input class", {
  x <- setNames(1:5, letters[1:5])
  expect_identical(rm.last(x, 2), x[-(4:5)])

  lst <- list(a = 1, b = 2, c = 3, d = 4)
  expect_identical(rm.last(lst, 2), list(a = 1, b = 2))

  m <- matrix(1:6, nrow = 3)
  dimnames(m) <- list(c("r1", "r2", "r3"), c("x", "y"))
  expect_identical(rm.last(m, 1), m[-3, , drop = FALSE])

  arr <- array(1:24, dim = c(4, 2, 3))
  dimnames(arr) <- list(
    c("r1", "r2", "r3", "r4"),
    c("x", "y"),
    c("z1", "z2", "z3")
  )
  expect_identical(rm.last(arr, 2), arr[-(3:4), , , drop = FALSE])

  df <- data.frame(a = 1:3, b = 4:6)
  rownames(df) <- c("r1", "r2", "r3")
  expect_identical(rm.last(df, 1), df[-3, , drop = FALSE])
})

test_that("rm.last() errors for unsupported classes", {
  env <- new.env(parent = emptyenv())
  expect_error(rm.last(env, 1), "atomic vectors and lists")
})

test_that("rm.last<- assignment dispatches correctly by input class", {
  x <- setNames(1:5, letters[1:5])
  x_expected <- x[-(4:5)]
  rm.last(x) <- 2
  expect_identical(x, x_expected)

  lst <- list(a = 1, b = 2, c = 3, d = 4)
  lst_expected <- lst[-(3:4)]
  rm.last(lst) <- 2
  expect_identical(lst, lst_expected)

  m <- matrix(1:6, nrow = 3)
  dimnames(m) <- list(c("r1", "r2", "r3"), c("x", "y"))
  m_expected <- m[-3, , drop = FALSE]
  rm.last(m) <- 1
  expect_identical(m, m_expected)

  arr <- array(1:24, dim = c(4, 2, 3))
  dimnames(arr) <- list(
    c("r1", "r2", "r3", "r4"),
    c("x", "y"),
    c("z1", "z2", "z3")
  )
  arr_expected <- arr[-(3:4), , , drop = FALSE]
  rm.last(arr) <- 2
  expect_identical(arr, arr_expected)

  df <- data.frame(a = 1:3, b = 4:6)
  rownames(df) <- c("r1", "r2", "r3")
  df_expected <- df[-3, , drop = FALSE]
  rm.last(df) <- 1
  expect_identical(df, df_expected)
})

test_that("array methods use first-dimension slicing for 2D/3D/4D", {
  arr2 <- array(1:12, dim = c(4, 3))
  dimnames(arr2) <- list(paste0("r", 1:4), paste0("c", 1:3))

  arr3 <- array(1:24, dim = c(4, 2, 3))
  dimnames(arr3) <- list(
    paste0("r", 1:4),
    paste0("c", 1:2),
    paste0("z", 1:3)
  )

  arr4 <- array(1:48, dim = c(4, 2, 3, 2))
  dimnames(arr4) <- list(
    paste0("r", 1:4),
    paste0("c", 1:2),
    paste0("z", 1:3),
    paste0("w", 1:2)
  )

  arrs <- list(arr2 = arr2, arr3 = arr3, arr4 = arr4)

  for (arr in arrs) {
    ndim <- length(dim(arr))

    if (ndim == 2L) {
      exp_first <- arr[-(1:2), , drop = FALSE]
      exp_last <- arr[-(3:4), , drop = FALSE]
    } else if (ndim == 3L) {
      exp_first <- arr[-(1:2), , , drop = FALSE]
      exp_last <- arr[-(3:4), , , drop = FALSE]
    } else if (ndim == 4L) {
      exp_first <- arr[-(1:2), , , , drop = FALSE]
      exp_last <- arr[-(3:4), , , , drop = FALSE]
    } else {
      stop("Unexpected dimension in test fixture")
    }

    expect_identical(rm.first(arr, 2), exp_first)
    expect_identical(rm.last(arr, 2), exp_last)
    expect_identical(dim(rm.first(arr, 2))[1], dim(arr)[1] - 2L)
    expect_identical(dim(rm.last(arr, 2))[1], dim(arr)[1] - 2L)
    expect_identical(dimnames(rm.first(arr, 2)), dimnames(exp_first))
    expect_identical(dimnames(rm.last(arr, 2)), dimnames(exp_last))
  }
})

test_that("array replacement methods preserve shape and dimnames by rank", {
  arr2 <- array(1:12, dim = c(4, 3))
  dimnames(arr2) <- list(paste0("r", 1:4), paste0("c", 1:3))

  arr3 <- array(1:24, dim = c(4, 2, 3))
  dimnames(arr3) <- list(
    paste0("r", 1:4),
    paste0("c", 1:2),
    paste0("z", 1:3)
  )

  arr4 <- array(1:48, dim = c(4, 2, 3, 2))
  dimnames(arr4) <- list(
    paste0("r", 1:4),
    paste0("c", 1:2),
    paste0("z", 1:3),
    paste0("w", 1:2)
  )

  arrs <- list(arr2 = arr2, arr3 = arr3, arr4 = arr4)

  for (arr in arrs) {
    ndim <- length(dim(arr))

    if (ndim == 2L) {
      exp_first <- arr[-(1:2), , drop = FALSE]
      exp_last <- arr[-(3:4), , drop = FALSE]
    } else if (ndim == 3L) {
      exp_first <- arr[-(1:2), , , drop = FALSE]
      exp_last <- arr[-(3:4), , , drop = FALSE]
    } else if (ndim == 4L) {
      exp_first <- arr[-(1:2), , , , drop = FALSE]
      exp_last <- arr[-(3:4), , , , drop = FALSE]
    }

    a_first <- arr
    rm.first(a_first) <- 2
    expect_identical(a_first, exp_first)

    a_last <- arr
    rm.last(a_last) <- 2
    expect_identical(a_last, exp_last)
  }
})

test_that("array methods handle first-dimension size 1", {
  arr <- array(1:6, dim = c(1, 2, 3))
  dimnames(arr) <- list("r1", c("c1", "c2"), c("z1", "z2", "z3"))

  exp_empty <- arr[-1, , , drop = FALSE]

  expect_identical(rm.first(arr, 1), exp_empty)
  expect_identical(rm.last(arr, 1), exp_empty)
  expect_identical(dim(rm.first(arr, 1)), c(0L, 2L, 3L))
  expect_identical(dim(rm.last(arr, 1)), c(0L, 2L, 3L))
  expect_identical(dimnames(rm.first(arr, 1)), dimnames(exp_empty))
  expect_identical(dimnames(rm.last(arr, 1)), dimnames(exp_empty))
})

test_that("array replacement methods handle first-dimension size 1", {
  arr <- array(1:6, dim = c(1, 2, 3))
  dimnames(arr) <- list("r1", c("c1", "c2"), c("z1", "z2", "z3"))

  exp_empty <- arr[-1, , , drop = FALSE]

  a_first <- arr
  rm.first(a_first) <- 1
  expect_identical(a_first, exp_empty)

  a_last <- arr
  rm.last(a_last) <- 1
  expect_identical(a_last, exp_empty)
})

test_that("array methods error when n exceeds first dimension", {
  arr <- array(1:6, dim = c(1, 2, 3))

  expect_error(rm.first(arr, 2))
  expect_error(rm.last(arr, 2))

  expect_error({
    a <- arr
    rm.first(a) <- 2
  })
  expect_error({
    a <- arr
    rm.last(a) <- 2
  })
})
