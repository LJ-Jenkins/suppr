vectors <- list(
  empty_integer = integer(),
  empty_character = character(),
  empty_logical = logical(),
  integer_unique = 1:10,
  integer_repeated = c(1, 2, 3, 2, 4, 1, 5, 1),
  double = c(1, 2, 2, 3.5, 1, 5.5),
  logical = c(TRUE, FALSE, TRUE, TRUE, FALSE),
  character = c("a", "b", "a", "c", "b", "d"),
  factor = factor(c("a", "b", "a", "c", "b")),
  raw = as.raw(c(1, 2, 3, 2, 1)),
  complex = c(1 + 1i, 2 + 2i, 1 + 1i, 3 + 0i),
  integer_na = c(1L, NA, 2L, NA, 1L),
  double_na = c(1, NA_real_, NaN, NaN, 1, NA_real_),
  character_na = c("a", NA, "b", NA, "a"),
  logical_na = c(TRUE, NA, FALSE, NA, TRUE),
  all_same = rep(42L, 10),
  alternating = rep(1:2, 5),
  singleton = 1L
)

br_repeated <- function(x) {
  duplicated(x, fromLast = FALSE) | duplicated(x, fromLast = TRUE)
}

br_whichRepeated <- function(x) {
  which(br_repeated(x))
}

br_repeats <- function(x) {
  x[br_repeated(x)]
}

test_that("basic API works", {
  x <- c(1, 2, 3, 2, 1)

  expect_identical(
    repeated(x),
    c(TRUE, TRUE, FALSE, TRUE, TRUE)
  )

  expect_identical(
    whichRepeated(x),
    c(1L, 2L, 4L, 5L)
  )

  expect_identical(
    repeats(x),
    c(1, 2, 2, 1)
  )
})

test_that("all unique values", {
  x <- 1:5

  expect_false(any(repeated(x)))
  expect_length(whichRepeated(x), 0)
  expect_length(repeats(x), 0)
})

test_that("all duplicated values", {
  x <- rep(1L, 5)

  expect_true(all(repeated(x)))
  expect_identical(whichRepeated(x), 1:5)
  expect_identical(repeats(x), x)
})

test_that("repeated matches reference implementation", {
  for (nm in names(vectors)) {
    x <- vectors[[nm]]

    expect_identical(
      repeated(x),
      br_repeated(x),
      info = nm
    )

    expect_identical(
      whichRepeated(x),
      br_whichRepeated(x),
      info = nm
    )

    expect_identical(
      repeats(x),
      br_repeats(x),
      info = nm
    )
  }
})

test_that("random integer vectors agree with reference", {
  set.seed(1)

  for (i in seq_len(100)) {
    x <- sample(1:20, size = 200, replace = TRUE)

    expect_identical(repeated(x), br_repeated(x))
    expect_identical(whichRepeated(x), br_whichRepeated(x))
    expect_identical(repeats(x), br_repeats(x))
  }
})

test_that("Date vectors", {
  x <- as.Date(c(
    "2020-01-01",
    "2020-01-02",
    "2020-01-01",
    "2020-01-03",
    "2020-01-02"
  ))

  expect_identical(repeated(x), br_repeated(x))
  expect_identical(whichRepeated(x), br_whichRepeated(x))
  expect_identical(repeats(x), br_repeats(x))
})

test_that("POSIXct vectors", {
  x <- as.POSIXct(c(
    "2020-01-01 00:00:00",
    "2020-01-01 01:00:00",
    "2020-01-01 00:00:00",
    "2020-01-01 02:00:00"
  ), tz = "UTC")

  expect_identical(repeated(x), br_repeated(x))
  expect_identical(whichRepeated(x), br_whichRepeated(x))
  expect_identical(repeats(x), br_repeats(x))
})

test_that("difftime vectors", {
  x <- as.difftime(c(1, 2, 1, 3, 2), units = "hours")

  expect_identical(repeated(x), br_repeated(x))
  expect_identical(whichRepeated(x), br_whichRepeated(x))
  expect_identical(repeats(x), br_repeats(x))
})

test_that("ordered factors", {
  x <- ordered(c("low", "med", "low", "high", "med"))

  expect_identical(repeated(x), br_repeated(x))
  expect_identical(whichRepeated(x), br_whichRepeated(x))
  expect_identical(repeats(x), br_repeats(x))
})

test_that("expression vectors", {
  x <- expression(x, y, x, z, y)

  expect_identical(repeated(x), br_repeated(x))
  expect_identical(whichRepeated(x), br_whichRepeated(x))
  expect_identical(repeats(x), br_repeats(x))
})

test_that("named vectors preserve names", {
  x <- c(a = 1, b = 2, c = 1, d = 3, e = 2)

  expect_equal(
    repeated(x),
    br_repeated(x),
    ignore_attr = TRUE
  )
  expect_named(repeated(x), names(x))

  expect_equal(
    whichRepeated(x),
    br_whichRepeated(x),
    ignore_attr = TRUE
  )
  expect_named(whichRepeated(x), c("a", "b", "c", "e"))

  expect_equal(
    repeats(x),
    br_repeats(x),
    ignore_attr = TRUE
  )
  expect_named(repeats(x), c("a", "b", "c", "e"))
})

test_that("zero-length vectors of many types", {
  xs <- list(
    integer(),
    double(),
    logical(),
    character(),
    complex(),
    raw(),
    factor(character()),
    as.Date(character()),
    as.POSIXct(character(), tz = "UTC")
  )

  for (x in xs) {
    expect_identical(repeated(x), br_repeated(x))
    expect_identical(whichRepeated(x), br_whichRepeated(x))
    expect_identical(repeats(x), br_repeats(x))
  }
})

test_that("list vectors", {
  x <- list(
    1,
    "a",
    1,
    TRUE,
    "a",
    TRUE
  )

  expect_identical(repeated(x), br_repeated(x))
  expect_identical(whichRepeated(x), br_whichRepeated(x))
  expect_identical(repeats(x), br_repeats(x))
})

test_that("lists containing objects", {
  x <- list(
    1:3,
    letters[1:2],
    1:3,
    data.frame(x = 1:2),
    data.frame(x = 1:2)
  )

  expect_identical(repeated(x), br_repeated(x))
  expect_identical(whichRepeated(x), br_whichRepeated(x))
  expect_identical(repeats(x), br_repeats(x))
})

test_that("matrix repeated defaults to repeated rows", {
  x <- rbind(
    c(1, 2),
    c(1, 2),
    c(3, 4),
    c(3, 4)
  )

  expect_identical(
    repeated(x),
    structure(c(TRUE, TRUE, TRUE, TRUE), dim = 4L)
  )

  expect_identical(
    whichRepeated(x),
    1:4
  )

  expect_identical(
    repeats(x),
    x
  )
})

test_that("matrix repeated finds repeated columns with MARGIN = 2", {
  x <- cbind(
    c(1, 2),
    c(3, 4),
    c(1, 2)
  )

  expect_identical(
    repeated(x, MARGIN = 2),
    structure(c(TRUE, FALSE, TRUE), dim = 3L)
  )

  expect_identical(
    whichRepeated(x, MARGIN = 2),
    c(1L, 3L)
  )

  expect_identical(
    repeats(x, MARGIN = 2),
    x[, c(1, 3), drop = FALSE]
  )
})

test_that("matrix MARGIN = 0 returns element-wise result", {
  x <- matrix(
    c(
      1, 2,
      1, 2
    ),
    nrow = 2
  )

  expect_identical(
    dim(repeated(x, MARGIN = 0)),
    dim(x)
  )

  expect_identical(
    repeated(x, MARGIN = 0),
    matrix(
      c(TRUE, TRUE, TRUE, TRUE),
      nrow = 2
    )
  )

  expect_identical(
    whichRepeated(x, MARGIN = 0),
    1:4
  )
})

test_that("matrix repeated has one value per row", {
  x <- matrix(
    1:9,
    nrow = 3,
    dimnames = list(
      c("a", "b", "c"),
      c("x", "y", "z")
    )
  )

  res <- repeated(x)

  expect_identical(dim(res), 3L)
  expect_identical(dimnames(res), list(c("a", "b", "c")))
})

test_that("3 dimensional arrays repeat slices by MARGIN", {
  x <- array(0, c(2, 2, 3))

  x[, , 1] <- matrix(c(
    1, 2,
    3, 4
  ), 2)

  x[, , 2] <- matrix(c(
    5, 6,
    7, 8
  ), 2)

  x[, , 3] <- matrix(c(
    1, 2,
    3, 4
  ), 2)

  expect_identical(
    repeated(x, MARGIN = 3),
    structure(c(TRUE, FALSE, TRUE), dim = 3L)
  )

  expect_identical(
    whichRepeated(x, MARGIN = 3),
    c(1L, 3L)
  )

  expect_identical(
    repeats(x, MARGIN = 3),
    x[, , c(1, 3), drop = FALSE]
  )
})

test_that("3 dimensional arrays repeat rows", {
  x <- array(0, c(2, 2, 2))

  x[1, , ] <- 1
  x[2, , ] <- 1

  expect_identical(
    repeated(x, MARGIN = 1),
    structure(c(TRUE, TRUE), dim = 2L)
  )

  expect_identical(
    whichRepeated(x, MARGIN = 1),
    c(1L, 2L)
  )
})

test_that("3 dimensional arrays with MARGIN = 0 operate element-wise", {
  x <- array(
    c(
      1, 2,
      1, 2,
      3, 4
    ),
    dim = c(3, 2, 1)
  )

  res <- repeated(x, MARGIN = 0)

  expect_identical(
    dim(res),
    dim(x)
  )

  expect_true(all(res[1:4]))
})

test_that(
  "matrix and array methods agree with vectorised behaviour for MARGIN = 0",
  {
    x <- matrix(
      c(1, 2, 1, 2),
      nrow = 2
    )

    expect_identical(
      whichRepeated(x, MARGIN = 0),
      whichRepeated(as.vector(x))
    )

    expect_identical(
      repeated(x, MARGIN = 0),
      matrix(
        repeated(as.vector(x)),
        nrow = 2
      )
    )
  }
)

test_that("invalid MARGIN is rejected", {
  x <- matrix(1:4, 2)

  expect_error(repeated(x, MARGIN = 3))
  expect_error(whichRepeated(x, MARGIN = 3))
  expect_error(repeats(x, MARGIN = 3))
})

test_that("repeated() matches duplicated() dimensions and dimnames", {
  x <- array(
    seq_len(24),
    dim = c(2, 3, 4),
    dimnames = list(
      c("r1", "r2"),
      c("c1", "c2", "c3"),
      c("s1", "s2", "s3", "s4")
    )
  )

  for (m in 0:3) {
    expect_identical(
      dim(repeated(x, MARGIN = m)),
      dim(duplicated(x, MARGIN = m)),
      info = paste("MARGIN =", m)
    )

    expect_identical(
      dimnames(repeated(x, MARGIN = m)),
      dimnames(duplicated(x, MARGIN = m)),
      info = paste("MARGIN =", m)
    )
  }
})
