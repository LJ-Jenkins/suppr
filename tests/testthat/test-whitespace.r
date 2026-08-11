test_that("anyZchar() returns the index of the first non-empty string", {
  expect_identical(anyZchar(c("abc", "", "def")), 2L)
  expect_identical(anyZchar(c("", "", "abc")), 1L)
  expect_identical(anyZchar(c("abc", "def")), 0L)
})

test_that("anyZchar() handles empty and NA inputs", {
  expect_identical(anyZchar(character(0)), 0L)
  expect_identical(anyZchar(c(NA_character_, "abc")), 0L)
  expect_identical(anyZchar(c(NA_character_, "", "abc")), 2L)
})

test_that("anyZchar() and anyWS() error on incorrect types", {
  for (tst in list(
    1:10,
    numeric(),
    logical(),
    list(1:10),
    environment(),
    mean,
    data.frame(x = 1),
    factor(c("a", "b", "c")),
    NULL
  )) {
    expect_error(anyZchar(tst))
    expect_error(anyWS(tst))
  }
})


test_that("anyWS() returns the index of the first all-whitespace string", {
  expect_identical(anyWS(c("abc", "   ", "def")), 2L)
  expect_identical(anyWS(c("   ", "abc", "\t")), 1L)
  expect_identical(anyWS(c("abc", "\t\r\n", "def")), 2L)
  expect_identical(anyWS(c("abc", " \t\r\n ", "def")), 2L)
  expect_identical(anyWS(c("abc", "def")), 0L)
})

test_that("anyWS() only matches the trimws() default whitespace characters", {
  expect_identical(anyWS(c("abc", " \t\r\n", "def")), 2L)
  expect_identical(anyWS(c("abc", "foo bar", "def")), 0L)
  expect_identical(anyWS(c("abc", "  foo", "def")), 0L)
  expect_identical(anyWS(c("abc", "foo  ", "def")), 0L)
  expect_identical(anyWS(c("abc", "\u00a0", "def")), 0L)
})

test_that("anyWS() handles empty strings according to empty", {
  expect_identical(anyWS(c("abc", "", "def")), 0L)
  expect_identical(anyWS(c("abc", "", "   ")), 3L)

  expect_identical(anyWS(c("abc", "", "def"), zchar = TRUE), 2L)
  expect_identical(anyWS(c("abc", "", "   "), zchar = TRUE), 2L)
})

test_that("anyWS() handles NA and empty inputs", {
  expect_identical(anyWS(character(0)), 0L)
  expect_identical(anyWS(c(NA_character_, "abc")), 0L)
  expect_identical(anyWS(c(NA_character_, "   ")), 2L)
  expect_identical(anyWS(c(NA_character_, "")), 0L)
  expect_identical(anyWS(c(NA_character_, "")), 0L)
  expect_identical(anyWS(c(NA_character_, ""), zchar = TRUE), 2L)
})

test_that("anyWS() validates the zchar argument", {
  expect_error(anyWS("abc", zchar = NA))
  expect_error(anyWS("abc", zchar = logical()))
  expect_error(anyWS("abc", zchar = c(TRUE, FALSE)))
  expect_error(anyWS("abc", zchar = 1))
  expect_error(anyWS("abc", zchar = "TRUE"))
})

test_that("anyZchar() and anyWS() return 0 for empty input", {
  expect_identical(anyZchar(character(0)), 0L)
  expect_identical(anyWS(character(0)), 0L)
})
