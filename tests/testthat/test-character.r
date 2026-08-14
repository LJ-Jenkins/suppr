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

test_that("grep wrappers match their base equivalents", {
  x <- c("Foo", "foo", "bar", "foo.bar", NA_character_)

  expect_identical(
    grepf("foo", x),
    grep("foo", x, fixed = TRUE)
  )
  expect_identical(
    grepf("foo", x, value = TRUE, invert = TRUE),
    grep("foo", x, fixed = TRUE, value = TRUE, invert = TRUE)
  )

  expect_identical(
    grepi("foo", x),
    grep("foo", x, ignore.case = TRUE)
  )
  expect_identical(
    grepi("f.o", x, perl = TRUE, value = TRUE),
    grep("f.o", x, ignore.case = TRUE, perl = TRUE, value = TRUE)
  )
})

test_that("grepl wrappers match their base equivalents", {
  x <- c("Foo", "foo", "bar", "foo.bar", NA_character_)

  expect_identical(
    greplf("foo", x),
    grepl("foo", x, fixed = TRUE)
  )
  expect_identical(
    grepli("foo", x),
    grepl("foo", x, ignore.case = TRUE)
  )
  expect_identical(
    grepli("f.o", x, perl = TRUE),
    grepl("f.o", x, ignore.case = TRUE, perl = TRUE)
  )
})

test_that("grepv wrappers match their base equivalents", {
  x <- c("Foo", "foo", "bar", "foo.bar", NA_character_)

  expect_identical(
    grepvf("foo", x),
    grep("foo", x, fixed = TRUE, value = TRUE)
  )
  expect_identical(
    grepvi("foo", x),
    grep("foo", x, ignore.case = TRUE, value = TRUE)
  )
})

test_that("sub/gsub wrappers match their base equivalents", {
  x <- c("Foo foo", "bar", "FOO")

  expect_identical(
    subf("foo", "X", x),
    sub("foo", "X", x, fixed = TRUE)
  )
  expect_identical(
    subi("foo", "X", x),
    sub("foo", "X", x, ignore.case = TRUE)
  )
  expect_identical(
    subi("(foo)", "\\1!", x, perl = TRUE),
    sub("(foo)", "\\1!", x, ignore.case = TRUE, perl = TRUE)
  )

  expect_identical(
    gsubf("foo", "X", x),
    gsub("foo", "X", x, fixed = TRUE)
  )
  expect_identical(
    gsubi("foo", "X", x),
    gsub("foo", "X", x, ignore.case = TRUE)
  )
  expect_identical(
    gsubi("(foo)", "\\1!", x, perl = TRUE),
    gsub("(foo)", "\\1!", x, ignore.case = TRUE, perl = TRUE)
  )
})
