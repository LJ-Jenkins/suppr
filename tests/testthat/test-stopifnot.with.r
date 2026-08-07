test_that("stopifnot.with() passes for TRUE", {
  expect_invisible(
    stopifnot.with(
      list(x = 1, y = 2),
      x == 1,
      y == 2
    )
  )

  expect_invisible(
    stopifnot.with(
      list(x = 10),
      x == 10
    )
  )

  dat <- data.frame(
    x = 1:3,
    y = 5:7
  )

  expect_invisible(
    stopifnot.with(
      dat,
      x < y
    )
  )

  e <- new.env()
  e$x <- 10

  expect_invisible(
    stopifnot.with(e, x == 10)
  )
})

test_that("stopifnot.with() reports failing expression", {
  expect_error(
    stopifnot.with(
      list(x = 1),
      x == 2
    ),
    regexp = "^with list\\(x = 1\\) : x == 2 is not TRUE$"
  )

  expect_error(
    stopifnot.with(
      list(x = c(TRUE, FALSE, TRUE)),
      x
    ),
    regexp = "^with list\\(x = c\\(TRUE, FALSE, TRUE\\)\\) : x are not all TRUE$"
  )

  expect_error(
    stopifnot.with(
      list(x = 1),
      "x must equal two" = x == 2
    ),
    regexp = "^x must equal two$"
  )
})

test_that("stopifnot.with() stops at first failure", {
  expect_error(
    stopifnot.with(
      list(x = 1),
      x == 2,
      stop("must not evaluate")
    ),
    regexp = "^with list\\(x = 1\\) : x == 2 is not TRUE$"
  )
})

test_that("stopifnot.with() handles NA", {
  expect_error(
    stopifnot.with(
      list(x = NA),
      x
    ),
    regexp = "is not TRUE"
  )
})

test_that("stopifnot.with() handles non-logical values", {
  expect_error(
    stopifnot.with(
      list(x = 1),
      x
    ),
    regexp = "is not TRUE"
  )
})

test_that("stopifnot.with() call. = FALSE suppresses call", {
  err <- tryCatch(
    stopifnot.with(
      list(x = 1),
      x == 2,
      call. = FALSE
    ),
    error = identity
  )

  expect_null(conditionCall(err))
})

test_that("stopifnot.with() call. = TRUE includes caller", {
  helper <- function() {
    stopifnot.with(
      list(x = 1),
      x == 2,
      call. = TRUE
    )
  }

  err <- tryCatch(helper(), error = identity)

  expect_identical(class(conditionCall(err)), "call")
  expect_identical(conditionCall(err)[[1]], quote(helper))
})

test_that("stopifnot.with() supports numeric call.", {
  helper <- function() {
    stopifnot.with(
      list(x = 1),
      x == 2,
      call. = 1
    )
  }

  err <- tryCatch(helper(), error = identity)

  expect_identical(conditionCall(err)[[1]], quote(helper))
})

test_that("stopifnot.with() formats all.equal() specially", {
  expect_error(
    stopifnot.with(
      list(x = 1, y = 2),
      all.equal(x, y)
    ),
    regexp = "with list\\(x = 1, y = 2\\) : x and y are not equal:"
  )
})

test_that("stopifnot.with() snapshot", {
  expect_snapshot(error = TRUE, {
    dat <- data.frame(
      expected = c(1, 2, 3),
      actual = c(1, 4, 5)
    )

    stopifnot.with(
      dat,
      all.equal(expected, actual)
    )
  })
})

test_that("stopifnot.with() finds variables in data", {
  dat <- list(x = 1)

  expect_invisible(
    stopifnot.with(
      dat,
      x == 1
    )
  )
})

test_that("stopifnot.with() prefers variables in data over caller", {
  x <- 2

  dat <- list(x = 1)

  expect_invisible(
    stopifnot.with(
      dat,
      x == 1
    )
  )

  expect_error(
    stopifnot.with(
      dat,
      x == 2
    ),
    regexp = "^with dat : x == 2 is not TRUE$"
  )
})

test_that("stopifnot.with() falls back to caller when variable is absent from data", {
  x <- 1

  dat <- list(y = 2)

  expect_invisible(
    stopifnot.with(
      dat,
      x == 1
    )
  )
})

test_that("stopifnot.with() can combine data variables and caller variables", {
  x <- 1

  dat <- list(y = 2)

  expect_invisible(
    stopifnot.with(
      dat,
      x == 1,
      y == 2,
      x + y == 3
    )
  )
})

test_that("stopifnot.with() uses data before parent frame", {
  x <- 100

  check <- function() {
    dat <- list(x = 1)

    stopifnot.with(
      dat,
      x == 1
    )
  }

  expect_invisible(check())
})

test_that("stopifnot.with() falls through multiple enclosing environments", {
  x <- 1

  outer <- function() {
    middle <- function() {
      inner <- function() {
        dat <- list(y = 2)

        stopifnot.with(
          dat,
          x == 1,
          y == 2
        )
      }

      inner()
    }

    middle()
  }

  expect_invisible(outer())
})

test_that("stopifnot.with() uses the nearest enclosing binding", {
  x <- 1

  outer <- function() {
    x <- 2

    inner <- function() {
      dat <- list(y = 3)

      stopifnot.with(
        dat,
        x == 2,
        y == 3
      )
    }

    inner()
  }

  expect_invisible(outer())
})

test_that("data binding shadows a variable in the caller", {
  x <- 1

  check <- function() {
    dat <- list(x = 2)

    stopifnot.with(
      dat,
      x == 2
    )
  }

  expect_invisible(check())
})

test_that("data binding shadows a variable several frames above", {
  x <- 1

  outer <- function() {
    middle <- function() {
      dat <- list(x = 2)

      stopifnot.with(
        dat,
        x == 2
      )
    }

    middle()
  }

  expect_invisible(outer())
})

test_that("missing variables produce an error rather than silently using unrelated data", {
  dat <- list(y = 2)

  expect_error(
    stopifnot.with(
      dat,
      x == 1
    ),
    class = "simpleError"
  )
})

test_that("data frame columns are preferred over caller variables", {
  x <- 100

  dat <- data.frame(
    x = 1:3
  )

  expect_invisible(
    stopifnot.with(
      dat,
      all(x == 1:3)
    )
  )
})

test_that("a local binding takes precedence over a binding farther up", {
  x <- 1

  outer <- function() {
    x <- 2

    inner <- function() {
      x <- 3

      dat <- list(y = 4)

      stopifnot.with(
        dat,
        x == 3
      )
    }

    inner()
  }

  expect_invisible(outer())
})
