test_that("rm.prefix removes a present prefix", {
  x <- c("x_apple", "x_banana", "x_cherry")
  expect_identical(rm.prefix(x, "x_"), c("apple", "banana", "cherry"))
})

test_that("rm.suffix removes a present suffix", {
  x <- c("apple_x", "banana_x", "cherry_x")
  expect_identical(rm.suffix(x, "_x"), c("apple", "banana", "cherry"))
})

test_that("elements without the prefix/suffix are left unchanged", {
  x <- c("x_apple", "banana", "x_cherry")
  expect_identical(rm.prefix(x, "x_"), c("apple", "banana", "cherry"))

  y <- c("apple_x", "banana", "cherry_x")
  expect_identical(rm.suffix(y, "_x"), c("apple", "banana", "cherry"))
})

test_that("no matches returns the input unchanged", {
  x <- c("apple", "banana", "cherry")
  expect_identical(rm.prefix(x, "zzz"), x)
  expect_identical(rm.suffix(x, "zzz"), x)
})

test_that("NA in x gives NA in the output", {
  x <- c("x_apple", NA, "x_cherry")
  expect_identical(rm.prefix(x, "x_"), c("apple", NA, "cherry"))

  y <- c("apple_x", NA, "cherry_x")
  expect_identical(rm.suffix(y, "_x"), c("apple", NA, "cherry"))
})

test_that("NA prefix or suffix is an error", {
  expect_error(rm.prefix("x_apple", NA_character_), "NA")
  expect_error(rm.suffix("apple_x", NA_character_), "NA")
})

test_that("empty x returns empty x", {
  expect_identical(rm.prefix(character(0), "x_"), character(0))
  expect_identical(rm.suffix(character(0), "_x"), character(0))
})

test_that("empty prefix/suffix returns x unchanged", {
  x <- c("apple", "banana", "cherry")
  expect_identical(rm.prefix(x, ""), x)
  expect_identical(rm.suffix(x, ""), x)
})

test_that("exact match leaves an empty string", {
  expect_identical(rm.prefix("abc", "abc"), "")
  expect_identical(rm.suffix("abc", "abc"), "")
})

test_that("prefix/suffix must be length 1", {
  expect_error(rm.prefix(c("a", "b"), c("a", "b")))
  expect_error(rm.suffix(c("a", "b"), c("a", "b")))
  expect_error(rm.prefix("a", character(0)))
  expect_error(rm.suffix("a", character(0)))
})

test_that("non-character input is an error", {
  expect_error(rm.prefix(1:3, "x_"))
  expect_error(rm.suffix(1:3, "_x"))
  expect_error(rm.prefix("x_apple", 1))
  expect_error(rm.suffix("apple_x", 1))
})

test_that("non-ASCII input is handled", {
  expect_identical(rm.prefix("café", "ca"), "fé")
  expect_identical(rm.suffix("café", "é"), "caf")
  expect_identical(rm.prefix("café", "café"), "")
  expect_identical(rm.suffix("café", "café"), "")
  expect_identical(rm.prefix(c("naïve", "café"), "na"), c("ïve", "café"))
})

test_that("UTF-8 prefix/suffix works", {
  expect_identical(rm.prefix("日本語テスト", "日本語"), "テスト")
  expect_identical(rm.suffix("日本語テスト", "テスト"), "日本語")
})

test_that("prefix/suffix longer than the string is a no-op", {
  expect_identical(rm.prefix("ab", "abcdef"), "ab")
  expect_identical(rm.suffix("ab", "abcdef"), "ab")
})

test_that("multiple matches are all removed", {
  x <- c("x_a", "x_b", "x_c")
  expect_identical(rm.prefix(x, "x_"), c("a", "b", "c"))

  y <- c("a_x", "b_x", "c_x")
  expect_identical(rm.suffix(y, "_x"), c("a", "b", "c"))
})

test_that("attributes on x are not preserved", {
  # The C code returns a fresh STRSXP; names etc. are dropped.
  x <- c(a = "x_apple", b = "x_banana")
  expect_null(names(rm.prefix(x, "x_")))
  expect_null(names(rm.suffix(x, "x_")))
})
