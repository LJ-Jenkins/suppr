test_that("warningifnot() passes all TRUE, empty, or no args", {
  expect_invisible(warningifnot(TRUE))
  expect_invisible(warningifnot(TRUE, c(TRUE, TRUE, TRUE)))
  expect_invisible(warningifnot())
  expect_invisible(warningifnot(TRUE, {
    TRUE
  }))
  expect_invisible(warningifnot(logical()))
})

test_that("warningifnot() warns for FALSE/NA", {
  expect_warning(
    warningifnot(FALSE),
    class = "simpleWarning",
    regexp = "^FALSE is not TRUE$"
  )

  expect_warning(
    warningifnot(c(TRUE, FALSE, TRUE)),
    class = "simpleWarning",
    regexp = "^c\\(TRUE, FALSE, TRUE\\) are not all TRUE$"
  )

  expect_warning(
    warningifnot(NA),
    class = "simpleWarning",
    regexp = "^NA is not TRUE$"
  )

  expect_warning(
    warningifnot(c(TRUE, NA)),
    class = "simpleWarning",
    regexp = "^c\\(TRUE, NA\\) are not all TRUE$"
  )
})

test_that("warningifnot() warns for non-logical values", {
  expect_warning(
    warningifnot(1),
    class = "simpleWarning",
    regexp = "^1 is not TRUE$"
  )

  expect_warning(
    warningifnot(0),
    class = "simpleWarning",
    regexp = "^0 is not TRUE$"
  )

  expect_warning(
    warningifnot("TRUE"),
    class = "simpleWarning",
    regexp = '^"TRUE" is not TRUE$'
  )

  expect_warning(
    warningifnot(NULL),
    class = "simpleWarning",
    regexp = "^NULL is not TRUE$"
  )

  expect_warning(
    warningifnot(list(TRUE)),
    class = "simpleWarning",
    regexp = "^list\\(TRUE\\) is not TRUE$"
  )
})

test_that("named warningifnot() arguments use their names as messages", {
  expect_warning(
    warningifnot("my condition" = FALSE),
    regexp = "^my condition$"
  )
})

test_that("all.equal() failures receive special formatting", {
  expect_warning(
    warningifnot(all.equal(1, 2)),
    regexp = "1 and 2 are not equal:"
  )
})

test_that("call. = FALSE removes the call", {
  warning <- rlang::catch_cnd(
    warningifnot(FALSE, call. = FALSE),
    "warning"
  )

  expect_true(inherits(warning, "simpleWarning"))
  expect_null(conditionCall(warning))
})

test_that("call. = TRUE records the caller", {
  helper <- function() {
    rlang::catch_cnd(
      warningifnot(FALSE, call. = TRUE),
      "warning"
    )
  }

  warning <- helper()

  expect_true(inherits(warning, "simpleWarning"))
  expect_identical(
    conditionCall(warning)[[1]],
    quote(helper)
  )
})

test_that("numeric call. = 1 identifies caller", {
  warning <- tryCatch(
    warningifnot(FALSE, call. = 1),
    warning = function(cnd) cnd
  )

  expect_true(inherits(warning, "simpleWarning"))
  expect_identical(
    conditionCall(warning)[[1]],
    quote(doTryCatch)
  )
})

test_that("negative numeric call. values use absolute value", {
  warning <- tryCatch(
    warningifnot(FALSE, call. = 1),
    warning = function(cnd) cnd
  )

  expect_true(inherits(warning, "simpleWarning"))
  expect_identical(
    conditionCall(warning)[[1]],
    quote(doTryCatch)
  )
})

test_that("numeric call. = 0 identifies warningifnot()", {
  warning <- rlang::catch_cnd(
    warningifnot(FALSE, call. = 0),
    "warning"
  )

  expect_identical(
    conditionCall(warning)[[1]],
    quote(warningifnot)
  )
})

test_that("numeric call. = 2 walks further up the stack", {
  outer <- function() {
    inner()
  }

  inner <- function() {
    rlang::catch_cnd(
      warningifnot(FALSE, call. = 2),
      "warning"
    )
  }

  warning <- outer()

  expect_true(inherits(warning, "simpleWarning"))
  expect_identical(class(conditionCall(warning)), "call")
})

test_that("fractional numeric call. values are coerced to integer", {
  helper <- function() {
    rlang::catch_cnd(
      warningifnot(FALSE, call. = 1.9),
      "warning"
    )
  }

  warning <- helper()

  expect_identical(class(conditionCall(warning)), "call")
})

test_that("large numeric call. values are clamped to available stack", {
  helper <- function() {
    rlang::catch_cnd(
      warningifnot(FALSE, call. = 100000),
      "warning"
    )
  }

  warning <- helper()

  expect_identical(class(conditionCall(warning)), "call")
})

test_that("call. rejects logical vectors", {
  expect_error(
    warningifnot(FALSE, call. = c(TRUE, FALSE)),
    regexp = "^Logical `call\\.` inputs must be TRUE or FALSE$"
  )
})

test_that("call. rejects NA logical", {
  expect_error(
    warningifnot(FALSE, call. = NA),
    regexp = "^Logical `call\\.` inputs must be TRUE or FALSE$"
  )
})

test_that("call. rejects numeric vectors", {
  expect_error(
    warningifnot(FALSE, call. = c(1, 2)),
    regexp = "^Numeric `call\\.` inputs must be scalar non-NA$"
  )
})

test_that("call. rejects numeric NA", {
  expect_error(
    warningifnot(FALSE, call. = NA_real_),
    regexp = "^Numeric `call\\.` inputs must be scalar non-NA$"
  )

  expect_error(
    warningifnot(FALSE, call. = NA_integer_),
    regexp = "^Numeric `call\\.` inputs must be scalar non-NA$"
  )
})

test_that("call. rejects character values", {
  expect_error(
    warningifnot(FALSE, call. = "1"),
    regexp = "^`call\\.` must be either a call, an integer, an environment, or TRUE/FALSE$"
  )
})

test_that("call. rejects NULL", {
  expect_error(
    warningifnot(FALSE, call. = NULL),
    regexp = "^`call\\.` must be either a call, an integer, an environment, or TRUE/FALSE$"
  )
})

test_that("call. rejects lists", {
  expect_error(
    warningifnot(FALSE, call. = list(1)),
    regexp = "^`call\\.` must be either a call, an integer, an environment, or TRUE/FALSE$"
  )
})

test_that("call. accepts an environment", {
  helper <- function() {
    env <- environment()

    rlang::catch_cnd(
      warningifnot(FALSE, call. = env),
      "warning"
    )
  }

  warning <- helper()

  expect_true(inherits(warning, "simpleWarning"))
  expect_identical(class(conditionCall(warning)), "call")
})

test_that("call. can identify a parent environment", {
  outer <- function() {
    inner()
  }

  inner <- function() {
    rlang::catch_cnd(
      warningifnot(FALSE, call. = parent.frame()),
      "warning"
    )
  }

  warning <- outer()

  expect_identical(class(conditionCall(warning)), "call")
})

test_that("call stack can be traversed through three functions", {
  level1 <- function() level2()
  level2 <- function() level3()

  level3 <- function() {
    rlang::catch_cnd(
      warningifnot(FALSE, call. = 3),
      "warning"
    )
  }

  warning <- level1()

  expect_identical(class(conditionCall(warning)), "call")
})

test_that("different call depths return different calls", {
  level1 <- function() level2()
  level2 <- function() level3()

  level3 <- function() {
    get_warning <- function(call.) {
      rlang::catch_cnd(
        warningifnot(FALSE, call. = call.),
        "warning"
      )
    }

    list(
      zero = get_warning(0),
      one = get_warning(1),
      two = get_warning(2)
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

test_that("warningifnot() warns only for the first failure by default", {
  n_warn <- 0

  withCallingHandlers(
    warningifnot(FALSE, FALSE, FALSE),
    warning = function(w) {
      n_warn <<- n_warn + 1
      invokeRestart("muffleWarning")
    }
  )

  expect_identical(as.integer(n_warn), 1L)
})

test_that("warningifnot(warn.all = TRUE) warns for every failure", {
  n_warn <- 0

  withCallingHandlers(
    warningifnot(FALSE, FALSE, FALSE, warn.all = TRUE),
    warning = function(w) {
      n_warn <<- n_warn + 1
      invokeRestart("muffleWarning")
    }
  )

  expect_identical(as.integer(n_warn), 3L)
})

test_that("warningifnot() only enables all warnings for TRUE warn.all", {
  expect_warning(
    warningifnot(FALSE, FALSE, warn.all = 1),
    regexp = "^FALSE is not TRUE$"
  )

  n_warn <- 0

  withCallingHandlers(
    warningifnot(FALSE, FALSE, warn.all = 1),
    warning = function(w) {
      n_warn <<- n_warn + 1
      invokeRestart("muffleWarning")
    }
  )

  expect_identical(as.integer(n_warn), 1L)
})

test_that("warningifnot() snapshot", {
  expect_snapshot({
    warningifnot(all.equal(
      c("a", "b", "c"),
      c("a", "x", "z")
    ))
  })
})

test_that("warningifnot() call information snapshot", {
  helper <- function() {
    warningifnot(
      c(TRUE, FALSE, TRUE),
      call. = TRUE
    )
  }

  expect_snapshot({
    helper()
  })
})
