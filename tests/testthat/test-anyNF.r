test_that("anyNF() detects non-finite values", {
  expect_identical(anyNF(1:5), 0L)
  expect_identical(anyNF(c(1, 2, NA_real_, Inf, NaN)), 3L)
  expect_identical(anyNF(c(1, 2, -Inf)), 3L)
  expect_identical(anyNF(c(1, 2, 3)), 0L)
  expect_identical(anyNF(c(1 + 0i, NA + 0i)), 2L)
  expect_identical(anyNF(c(1L, NA_integer_)), 2L)
  expect_identical(anyNF(c(TRUE, FALSE, NA)), 3L)
})

test_that("anyNF() returns 0 for empty inputs", {
  expect_identical(anyNF(numeric(0)), 0L)
})

test_that("anyNF() works on logical, numeric and complex types", {
  for (tst in list(
    1:10, 1L:10, c(1 + 0i, 2 + 0i, NA_complex_), c(TRUE, FALSE, NA)
  )) {
    expect_no_error(anyNF(tst))
  }
})

test_that("anyNF() errors on incorrect types", {
  for (tst in list(
    list(1:10), environment(), mean, data.frame(x = 1), call("mean"),
    c("1", "2", "3"), factor(c("a", "b", "c"))
  )) {
    expect_error(anyNF(tst))
  }
})
