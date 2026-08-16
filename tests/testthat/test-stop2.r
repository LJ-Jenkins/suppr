test_that("stop2() creates simpleError conditions", {
  err <- rlang::catch_cnd(
    stop2("hello"),
    "error"
  )

  expect_true(inherits(err, "simpleError"))
  expect_identical(conditionMessage(err), "hello")
})


test_that("warning2() creates simpleWarning conditions", {
  warn <- rlang::catch_cnd(
    warning2("hello"),
    "warning"
  )

  expect_true(inherits(warn, "simpleWarning"))
  expect_identical(conditionMessage(warn), "hello")
})

test_that("multiple arguments are pasted together", {
  err <- rlang::catch_cnd(
    stop2("hello", " ", "world"),
    "error"
  )

  expect_identical(
    conditionMessage(err),
    "hello world"
  )

  warn <- rlang::catch_cnd(
    warning2("hello", " ", "world"),
    "warning"
  )

  expect_identical(
    conditionMessage(warn),
    "hello world"
  )
})


test_that("call. = FALSE removes calls", {
  err <- rlang::catch_cnd(
    stop2("failure", call. = FALSE),
    "error"
  )

  warn <- rlang::catch_cnd(
    warning2("failure", call. = FALSE),
    "warning"
  )

  expect_null(conditionCall(err))
  expect_null(conditionCall(warn))
})


test_that("call. = TRUE captures the caller", {
  helper_error <- function() {
    rlang::catch_cnd(
      stop2("failure", call. = TRUE),
      "error"
    )
  }

  helper_warning <- function() {
    rlang::catch_cnd(
      warning2("failure", call. = TRUE),
      "warning"
    )
  }

  err <- helper_error()
  warn <- helper_warning()

  expect_identical(conditionCall(err)[[1]], quote(helper_error))
  expect_identical(conditionCall(warn)[[1]], quote(helper_warning))
})


test_that("numeric call. = 0 identifies the wrapper", {
  err <- rlang::catch_cnd(
    stop2("failure", call. = 0),
    "error"
  )

  warn <- rlang::catch_cnd(
    warning2("failure", call. = 0),
    "warning"
  )

  expect_identical(conditionCall(err)[[1]], quote(stop2))
  expect_identical(conditionCall(warn)[[1]], quote(warning2))
})


test_that("numeric call. = 1 identifies caller", {
  err <- tryCatch(stop2(call. = 1), error = function(x) x)
  warn <- tryCatch(warning2(call. = 1), warning = function(x) x)

  expect_identical(conditionCall(err)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(warn)[[1]], quote(doTryCatch))
})


test_that("negative numeric call values use absolute value", {
  err <- tryCatch(stop2(call. = -1), error = function(x) x)
  warn <- tryCatch(warning2(call. = -1), warning = function(x) x)

  expect_identical(conditionCall(err)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(warn)[[1]], quote(doTryCatch))
})


test_that("fractional numeric call values are coerced", {
  # 1.5 -> as.integer() -> 1
  err <- tryCatch(stop2(call. = 1.5), error = function(x) x)
  warn <- tryCatch(warning2(call. = 1.5), warning = function(x) x)

  expect_identical(conditionCall(err)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(warn)[[1]], quote(doTryCatch))
})


test_that("large numeric call values are clamped", {
  err <- rlang::catch_cnd(
    stop2("failure", call. = 100000),
    "error"
  )

  expect_true(inherits(err, "simpleError"))
  expect_identical(class(conditionCall(err)), "call")
})


test_that("explicit calls are accepted", {
  err <- rlang::catch_cnd(
    stop2("failure", call. = quote(foo())),
    "error"
  )

  warn <- rlang::catch_cnd(
    warning2("failure", call. = quote(bar())),
    "warning"
  )

  expect_identical(conditionCall(err), quote(foo()))
  expect_identical(conditionCall(warn), quote(bar()))
})


test_that("call. accepts environments", {
  helper <- function() {
    env <- environment()

    rlang::catch_cnd(
      stop2("failure", call. = env),
      "error"
    )
  }

  err <- helper()

  expect_true(inherits(err, "simpleError"))
  expect_identical(class(conditionCall(err)), "call")
})


test_that("invalid call. inputs error", {
  expect_error(
    stop2("failure", call. = c(TRUE, FALSE)),
    regexp = "Logical `call\\.` inputs must be TRUE or FALSE"
  )

  expect_error(
    warning2("failure", call. = c(1, 2)),
    regexp = "Numeric `call\\.` inputs must be scalar non-NA"
  )
})


test_that("condition objects are passed through", {
  err <- simpleError("existing error")

  expect_error(
    stop2(err),
    regexp = "existing error"
  )


  warn <- simpleWarning("existing warning")

  expect_warning(
    expect_warning(warning2(warn)),
    regexp = "existing warning"
  )
})


test_that("condition object ignores additional arguments", {
  err <- simpleError("existing error")

  expect_error(
    stop2(err, "ignored"),
    regexp = "existing error"
  )

  warn <- simpleWarning("existing warning")

  expect_warning(
    warning2(warn, "ignored"),
    regexp = "existing warning"
  )
})

test_that("stop2 call information snapshot", {
  helper <- function() {
    stop2(
      "failure",
      call. = TRUE
    )
  }

  expect_snapshot(error = TRUE, {
    helper()
  })
})


test_that("warning2 call information snapshot", {
  helper <- function() {
    warning2(
      "failure",
      call. = TRUE
    )
  }

  expect_snapshot({
    helper()
  })
})
