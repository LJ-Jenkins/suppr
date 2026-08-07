test_that("match.argv() returns an exact matching object", {
  expect_identical(
    match.argv(1:3, list("a", 1:3, TRUE)),
    1:3
  )

  expect_identical(
    match.argv(NULL, list(1:3, NULL)),
    NULL
  )

  expect_identical(
    match.argv(list(a = 1), list(list(a = 1), list(b = 2))),
    list(a = 1)
  )
})

test_that("match.argv() uses strict matching by default", {
  expect_error(
    match.argv(1, list(1L))
  )

  expect_error(
    match.argv(NA, list(NA_real_, NA_integer_, NA_character_))
  )

  expect_identical(
    match.argv(NA_integer_, list(NA_integer_)),
    NA_integer_
  )

  expect_identical(
    match.argv(1L, list(1L)),
    1L
  )
})

test_that("match.argv() ignores function environments", {
  f1 <- function(x) x
  f2 <- local({
    y <- 1
    function(x) x
  })

  expect_identical(
    match.argv(f1, list(f2)),
    f2
  )
})

test_that("match.argv() returns the first matching choice", {
  expect_identical(
    match.argv(
      1,
      list(1, 1, 1),
      match.fn = function(x, y) x == y
    ),
    1
  )
})

test_that("match.argv() supports custom matching functions", {
  expect_identical(
    match.argv(
      "A",
      list("a", "b", "c"),
      match.fn = function(x, y) tolower(x) == y
    ),
    "a"
  )

  expect_identical(
    match.argv(
      5,
      list(1:3, 4:6),
      match.fn = function(x, y) x %in% y
    ),
    4:6
  )
})

test_that("match.argv() validates choices", {
  expect_error(
    match.argv(1, 1:5),
    "'choices' must be a list."
  )
})

test_that("match.argv() validates match.fn", {
  expect_error(
    match.argv(1, list(1), match.fn = 1),
    "'match.fn' must be a function."
  )
})

test_that("match.argv() errors when no match is found", {
  expect_snapshot(error = TRUE, {
    match.argv(4, list(1, 2, 3))
  })
})

test_that(
  "match.argv() uses formal argument defaults when choices is omitted",
  {
    f <- function(x = c("a", "b", "c")) {
      match.argv(x)
    }

    expect_error(f("a"), "'choices' must be a list.")

    f <- function(x = list("a", "b", "c")) {
      match.argv(x)
    }

    expect_identical(
      f("a"),
      "a"
    )

    expect_snapshot(error = TRUE, {
      f("d")
    })
  }
)

test_that("match.argv() works with list defaults", {
  f <- function(x = list(1:3, letters[1:3], NULL)) {
    match.argv(x)
  }

  expect_identical(
    f(NULL),
    NULL
  )

  expect_identical(
    f(1:3),
    1:3
  )
})

test_that("match.argv() returns the choice object", {
  x <- structure(1:3, class = "myclass")

  expect_identical(
    match.argv(x, list(x)),
    x
  )
})
