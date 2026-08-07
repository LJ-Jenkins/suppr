test_that("bckQuote() tests", {
  expect_identical(bckQuote(character()), character())
  expect_identical(bckQuote(c("a", "b", "c")), c("`a`", "`b`", "`c`"))
  expect_identical(bckQuote(1:3), c("`1`", "`2`", "`3`"))
})

test_that("cat0() tests", {
  expect_output(cat0("a", "b", "c"), "abc")
  expect_identical(
    capture.output(cat0(1:3)),
    capture.output(cat(1:3, sep = ""))
  )
})

test_that("collapse tests", {
  expect_equal(collapse(character()), "")
  expect_equal(collapse0(character()), "")

  expect_equal(collapse(c("a", "b", "c")), "abc")
  expect_equal(collapse(c("a", "b", "c"), sep = ", "), "a, b, c")

  expect_equal(collapse0(c("a", "b", "c")), "abc")
  expect_equal(collapse0(c("a", "b", "c"), sep = ", "), "a, b, c")

  expect_equal(
    collapse(c("a", "b"), "c"),
    "a cb c"
  )

  expect_equal(
    collapse(c("a", "b"), "c", sep = ", "),
    "a c, b c"
  )

  expect_equal(
    collapse0(c("a", "b"), "c"),
    "acbc"
  )

  expect_equal(
    collapse0(c("a", "b"), "c", sep = ", "),
    "ac, bc"
  )
})

test_that("collapse() recurse = TRUE collapses each argument first", {
  expect_equal(
    collapse(
      c("a", "b"),
      c("c", "d"),
      sep = ", ",
      recurse = TRUE
    ),
    "a, b c, d"
  )

  expect_equal(
    collapse0(
      c("a", "b"),
      c("c", "d"),
      sep = ", ",
      recurse = TRUE
    ),
    "a, bc, d"
  )
})

test_that("listing() tests", {
  expect_equal(listing(character()), character())

  expect_equal(
    listing(c("a", "b", "c")),
    "a, b and c."
  )

  expect_equal(
    listing(c("a", "b"), conjunction = "or", period = FALSE),
    "a or b"
  )

  expect_equal(
    listing(c("a", "b", "c"), quote = "s"),
    paste0(sQuote("a"), ", ", sQuote("b"), " and ", sQuote("c"), ".")
  )

  expect_equal(
    listing(c("a", "b", "c"), quote = "d"),
    "\"a\", \"b\" and \"c\"."
  )

  expect_equal(
    listing(c("a", "b", "c"), quote = "b"),
    "`a`, `b` and `c`."
  )
})
