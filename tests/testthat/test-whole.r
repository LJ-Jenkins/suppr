test_that("is.integerish() recognizes integer-like inputs", {
  expect_true(is.integerish(1L))
  expect_true(is.integerish(c(1L, 2L, NA_integer_)))
  expect_true(is.integerish(c(1, 2, NA_real_, Inf, -Inf, NaN)))
  expect_false(is.integerish(c(1.5, 2)))
})

test_that("is.whole() returns a scalar whole-number status", {
  expect_true(is.whole(1:5))
  expect_true(is.whole(c(1, 2, NA_real_, Inf, NaN)))
  expect_false(is.whole(c(1, 2.5)))
})

test_that("is.wholenumber() works element-wise", {
  x <- c(1, 2.5, NA_real_, Inf, NaN)

  expect_identical(is.wholenumber(x), c(TRUE, FALSE, NA, NA, NA))
  expect_identical(is.wholenumber(1:3), c(TRUE, TRUE, TRUE))
  expect_identical(is.wholenumber(NA_real_), NA)
})

test_that("anyNF() detects non-finite values", {
  expect_false(anyNF(1:5))
  expect_true(anyNF(c(1, 2, NA_real_, Inf, NaN)))
  expect_true(anyNF(c(1, 2, -Inf)))
  expect_false(anyNF(c(1, 2, 3)))
})

test_that("is.integerish() and is.whole() treat non-finite values as TRUE", {
  expect_true(is.integerish(c(Inf, -Inf, NaN, NA)))
  expect_true(is.whole(c(Inf, -Inf, NaN, NA)))
})

test_that("is.wholenumber() returns NA for non-finite values", {
  expect_identical(
    is.wholenumber(c(Inf, -Inf, NaN, NA)), c(NA, NA, NA, NA)
  )
})

test_that(
  "is.integerish(), is.whole() and anyNF() return bool for empty inputs",
  {
    expect_true(is.integerish(numeric(0)))
    expect_true(is.whole(numeric(0)))
    expect_false(anyNF(numeric(0)))
  }
)

test_that("is.wholenumber() returns logical(0) for empty inputs", {
  expect_identical(is.wholenumber(numeric(0)), logical(0))
})

test_that("whole functions work on logical, numeric and complex types", {
  for (tst in list(
    1:10, 1L:10, c(1 + 0i, 2 + 0i, NA_complex_), c(TRUE, FALSE, NA)
  )) {
    expect_no_error(is.integerish(tst))
    expect_no_error(is.whole(tst))
    expect_no_error(is.wholenumber(tst))
    expect_no_error(anyNF(tst))
  }
})

test_that("whole functions error on incorrect types", {
  for (tst in list(
    list(1:10), environment(), mean, data.frame(x = 1), call("mean"),
    c("1", "2", "3"), factor(c("a", "b", "c"))
  )) {
    expect_error(is.integerish(tst))
    expect_error(is.whole(tst))
    expect_error(is.wholenumber(tst))
    expect_error(anyNF(tst))
  }
})

test_that("is.wholenumber() preserves names", {
  x <- c(a = 1, b = 2.5, c = NA_real_, d = Inf, e = NaN)

  expect_named(is.wholenumber(x), names(x))
})
