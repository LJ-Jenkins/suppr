test_that("stopifnot2() passes all TRUE, empty, or no args", {
  expect_invisible(stopifnot2(TRUE))
  expect_invisible(stopifnot2(TRUE, c(TRUE, TRUE, TRUE)))
  expect_invisible(stopifnot2())
  expect_invisible(stopifnot2(TRUE, {
    TRUE
  }))
  expect_invisible(stopifnot2(logical()))
})

test_that("stopifnot2() stops for FALSE/NA", {
  expect_error(
    stopifnot2(FALSE),
    class = "simpleError",
    regexp = "^FALSE is not TRUE$"
  )

  expect_error(
    stopifnot2(c(TRUE, FALSE, TRUE)),
    class = "simpleError",
    regexp = "^c\\(TRUE, FALSE, TRUE\\) are not all TRUE$"
  )

  expect_error(
    stopifnot2(NA),
    class = "simpleError",
    regexp = "^NA is not TRUE$"
  )

  expect_error(
    stopifnot2(c(TRUE, NA)),
    class = "simpleError",
    regexp = "^c\\(TRUE, NA\\) are not all TRUE$"
  )
})

test_that("stopifnot2() stops for non-logical values", {
  expect_error(
    stopifnot2(1),
    class = "simpleError",
    regexp = "^1 is not TRUE$"
  )

  expect_error(
    stopifnot2(0),
    class = "simpleError",
    regexp = "^0 is not TRUE$"
  )

  expect_error(
    stopifnot2("TRUE"),
    class = "simpleError",
    regexp = '^"TRUE" is not TRUE$'
  )

  expect_error(
    stopifnot2(NULL),
    class = "simpleError",
    regexp = "^NULL is not TRUE$"
  )

  expect_error(
    stopifnot2(list(TRUE)),
    class = "simpleError",
    regexp = "^list\\(TRUE\\) is not TRUE$"
  )
})

test_that("stopifnot2() stops at the first failing expression", {
  expect_error(
    stopifnot2(FALSE, stop("this must not be evaluated")),
    regexp = "^FALSE is not TRUE$"
  )
})

test_that("named stopifnot2() arguments use their names as messages", {
  expect_error(
    stopifnot2("my condition" = FALSE),
    regexp = "^my condition$"
  )
})

test_that("all.equal() failures receive special formatting", {
  expect_error(
    stopifnot2(all.equal(1, 2)),
    regexp = "1 and 2 are not equal:"
  )
})

test_that("call. = FALSE removes the call", {
  err <- tryCatch(
    stopifnot2(FALSE, call. = FALSE),
    error = identity
  )

  expect_true(inherits(err, "simpleError"))
  expect_null(conditionCall(err))
})

test_that("call. = TRUE records the caller", {
  helper <- function() {
    stopifnot2(FALSE, call. = TRUE)
  }

  err <- tryCatch(helper(), error = identity)

  expect_true(inherits(err, "simpleError"))
  expect_identical(class(conditionCall(err)), "call")
  expect_identical(conditionCall(err)[[1]], quote(helper))

  outer <- function() {
    inner()
  }

  inner <- function() {
    stopifnot2(FALSE, call. = TRUE)
  }

  err <- tryCatch(outer(), error = identity)

  expect_true(inherits(err, "simpleError"))
  expect_identical(conditionCall(err)[[1]], quote(inner))
})

test_that("numeric call. = 0 identifies stopifnot2()", {
  err <- tryCatch(
    stopifnot2(FALSE, call. = 0),
    error = identity
  )

  expect_identical(conditionCall(err)[[1]], quote(stopifnot2))
})

test_that("numeric call. = 1 identifies caller", {
  helper <- function() {
    stopifnot2(FALSE, call. = 1)
  }

  err <- tryCatch(helper(), error = identity)

  expect_identical(conditionCall(err)[[1]], quote(helper))
})

test_that("numeric call. = 2 walks further up the stack", {
  outer <- function() {
    inner()
  }

  inner <- function() {
    stopifnot2(FALSE, call. = 2)
  }

  err <- tryCatch(outer(), error = identity)

  expect_identical(class(conditionCall(err)), "call")
})

test_that("negative numeric call. values use absolute value", {
  helper <- function() {
    stopifnot2(FALSE, call. = -1)
  }

  err <- tryCatch(helper(), error = identity)

  expect_identical(conditionCall(err)[[1]], quote(helper))
})

test_that("fractional numeric call. values are coerced to integer", {
  helper <- function() {
    stopifnot2(FALSE, call. = 1.9)
  }

  err <- tryCatch(helper(), error = identity)

  expect_identical(class(conditionCall(err)), "call")
})

test_that("large numeric call. values are clamped to available stack", {
  helper <- function() {
    stopifnot2(FALSE, call. = 100000)
  }

  err <- tryCatch(helper(), error = identity)

  expect_identical(class(conditionCall(err)), "call")
})

test_that("call. rejects logical vectors", {
  expect_error(
    stopifnot2(FALSE, call. = c(TRUE, FALSE)),
    regexp = "^Logical `call\\.` inputs must be TRUE or FALSE$"
  )
})

test_that("call. rejects NA logical", {
  expect_error(
    stopifnot2(FALSE, call. = NA),
    regexp = "^Logical `call\\.` inputs must be TRUE or FALSE$"
  )
})

test_that("call. rejects numeric vectors", {
  expect_error(
    stopifnot2(FALSE, call. = c(1, 2)),
    regexp = "^Numeric `call\\.` inputs must be scalar non-NA$"
  )
})

test_that("call. rejects numeric NA", {
  expect_error(
    stopifnot2(FALSE, call. = NA_real_),
    regexp = "^Numeric `call\\.` inputs must be scalar non-NA$"
  )

  expect_error(
    stopifnot2(FALSE, call. = NA_integer_),
    regexp = "^Numeric `call\\.` inputs must be scalar non-NA$"
  )
})

test_that("call. rejects character values", {
  expect_error(
    stopifnot2(FALSE, call. = "1"),
    regexp = "^`call\\.` must be either a call, an integer, an environment, or TRUE/FALSE$"
  )
})

test_that("call. rejects NULL", {
  expect_error(
    stopifnot2(FALSE, call. = NULL),
    regexp = "^`call\\.` must be either a call, an integer, an environment, or TRUE/FALSE$"
  )
})

test_that("call. rejects lists", {
  expect_error(
    stopifnot2(FALSE, call. = list(1)),
    regexp = "^`call\\.` must be either a call, an integer, an environment, or TRUE/FALSE$"
  )
})

test_that("call. accepts an environment", {
  helper <- function() {
    env <- environment()
    stopifnot2(FALSE, call. = env)
  }

  err <- tryCatch(helper(), error = identity)

  expect_true(inherits(err, "simpleError"))
  expect_identical(class(conditionCall(err)), "call")
})

test_that("call. can identify a parent environment", {
  outer <- function() {
    inner()
  }

  inner <- function() {
    stopifnot2(FALSE, call. = parent.frame())
  }

  err <- tryCatch(outer(), error = identity)

  expect_identical(class(conditionCall(err)), "call")
})

test_that("call stack can be traversed through three functions", {
  level1 <- function() level2()
  level2 <- function() level3()
  level3 <- function() stopifnot2(FALSE, call. = 3)

  err <- tryCatch(level1(), error = identity)

  expect_identical(class(conditionCall(err)), "call")
})

test_that("different call depths return different calls", {
  level1 <- function() level2()
  level2 <- function() level3()
  level3 <- function() {
    list(
      zero = tryCatch(
        stopifnot2(FALSE, call. = 0),
        error = identity
      ),
      one = tryCatch(
        stopifnot2(FALSE, call. = 1),
        error = identity
      ),
      two = tryCatch(
        stopifnot2(FALSE, call. = 2),
        error = identity
      )
    )
  }

  x <- level1()

  expect_false(identical(
    conditionCall(x$zero),
    conditionCall(x$one)
  ))

  expect_false(identical(
    conditionCall(x$one),
    conditionCall(x$two)
  ))
})

test_that("stopifnot2() snapshot", {
  expect_snapshot(error = TRUE, {
    stopifnot2(all.equal(
      c("a", "b", "c"),
      c("a", "x", "z")
    ))
  })
})

test_that("stopifnot2() call information snapshot", {
  helper <- function() {
    stopifnot2(
      c(TRUE, FALSE, TRUE),
      call. = TRUE
    )
  }

  expect_snapshot(error = TRUE, {
    helper()
  })
})
