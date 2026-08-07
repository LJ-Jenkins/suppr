test_that("stop2() creates simpleError conditions", {
  err <- catch_cnd(
    stop2("hello"),
    "error"
  )

  expect_true(inherits(err, "simpleError"))
  expect_identical(conditionMessage(err), "hello")
})


test_that("warning2() creates simpleWarning conditions", {
  warn <- catch_cnd(
    warning2("hello"),
    "warning"
  )

  expect_true(inherits(warn, "simpleWarning"))
  expect_identical(conditionMessage(warn), "hello")
})


test_that("message2() creates simpleMessage conditions", {
  msg <- catch_cnd(
    message2("hello"),
    "message"
  )

  expect_true(inherits(msg, "simpleMessage"))
  expect_identical(conditionMessage(msg), "hello\n")

  msg <- catch_cnd(
    message2("hello", appendLF = FALSE),
    "message"
  )

  expect_identical(conditionMessage(msg), "hello")
})


test_that("multiple arguments are pasted together", {
  err <- catch_cnd(
    stop2("hello", " ", "world"),
    "error"
  )

  expect_identical(
    conditionMessage(err),
    "hello world"
  )

  warn <- catch_cnd(
    warning2("hello", " ", "world"),
    "warning"
  )

  expect_identical(
    conditionMessage(warn),
    "hello world"
  )
})


test_that("call. = FALSE removes calls", {
  err <- catch_cnd(
    stop2("failure", call. = FALSE),
    "error"
  )

  warn <- catch_cnd(
    warning2("failure", call. = FALSE),
    "warning"
  )

  msg <- catch_cnd(
    message2("failure", call. = FALSE),
    "message"
  )

  expect_null(conditionCall(err))
  expect_null(conditionCall(warn))
  expect_null(conditionCall(msg))
})


test_that("call. = TRUE captures the caller", {
  helper_error <- function() {
    catch_cnd(
      stop2("failure", call. = TRUE),
      "error"
    )
  }

  helper_warning <- function() {
    catch_cnd(
      warning2("failure", call. = TRUE),
      "warning"
    )
  }

  helper_message <- function() {
    catch_cnd(
      message2("failure", call. = TRUE),
      "message"
    )
  }

  err <- helper_error()
  warn <- helper_warning()
  msg <- helper_message()

  expect_identical(conditionCall(err)[[1]], quote(helper_error))
  expect_identical(conditionCall(warn)[[1]], quote(helper_warning))
  expect_identical(conditionCall(msg)[[1]], quote(helper_message))
})


test_that("numeric call. = 0 identifies the wrapper", {
  err <- catch_cnd(
    stop2("failure", call. = 0),
    "error"
  )

  warn <- catch_cnd(
    warning2("failure", call. = 0),
    "warning"
  )

  msg <- catch_cnd(
    message2("failure", call. = 0),
    "message"
  )

  expect_identical(conditionCall(err)[[1]], quote(stop2))
  expect_identical(conditionCall(warn)[[1]], quote(warning2))
  expect_identical(conditionCall(msg)[[1]], quote(message2))
})


test_that("numeric call. = 1 identifies caller", {
  err <- tryCatch(stop2(call. = 1), error = function(x) x)
  warn <- tryCatch(warning2(call. = 1), warning = function(x) x)
  msg <- tryCatch(message2(call. = 1), message = function(x) x)

  expect_identical(conditionCall(err)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(warn)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(msg)[[1]], quote(doTryCatch))
})


test_that("negative numeric call values use absolute value", {
  err <- tryCatch(stop2(call. = -1), error = function(x) x)
  warn <- tryCatch(warning2(call. = -1), warning = function(x) x)
  msg <- tryCatch(message2(call. = -1), message = function(x) x)

  expect_identical(conditionCall(err)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(warn)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(msg)[[1]], quote(doTryCatch))
})


test_that("fractional numeric call values are coerced", {
  # 1.5 -> as.integer() -> 1
  err <- tryCatch(stop2(call. = 1.5), error = function(x) x)
  warn <- tryCatch(warning2(call. = 1.5), warning = function(x) x)
  msg <- tryCatch(message2(call. = 1.5), message = function(x) x)

  expect_identical(conditionCall(err)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(warn)[[1]], quote(doTryCatch))
  expect_identical(conditionCall(msg)[[1]], quote(doTryCatch))
})


test_that("large numeric call values are clamped", {
  err <- catch_cnd(
    stop2("failure", call. = 100000),
    "error"
  )

  expect_true(inherits(err, "simpleError"))
  expect_identical(class(conditionCall(err)), "call")
})


test_that("explicit calls are accepted", {
  err <- catch_cnd(
    stop2("failure", call. = quote(foo())),
    "error"
  )

  warn <- catch_cnd(
    warning2("failure", call. = quote(bar())),
    "warning"
  )

  msg <- catch_cnd(
    message2("failure", call. = quote(baz())),
    "message"
  )

  expect_identical(conditionCall(err), quote(foo()))
  expect_identical(conditionCall(warn), quote(bar()))
  expect_identical(conditionCall(msg), quote(baz()))
})


test_that("call. accepts environments", {
  helper <- function() {
    env <- environment()

    catch_cnd(
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

  expect_error(
    message2("failure", call. = "wrong"),
    regexp = "`call\\.` must be either a call, an integer, an environment, or TRUE/FALSE"
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


  msg <- simpleMessage("existing message")

  expect_message(
    expect_message(message2(msg)),
    regexp = "existing message"
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

  msg <- simpleMessage("existing message")

  expect_message(
    message2(msg, "ignored"),
    regexp = "existing message"
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
