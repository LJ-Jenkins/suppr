test_that("addClass() prepends classes without modifying the input", {
  x <- structure(1, class = "base_class")

  y <- addClass(x, c("new_class", "another_class"))

  expect_identical(class(y), c("new_class", "another_class", "base_class"))
  expect_identical(class(x), "base_class")
})

test_that("addClass() can replace the class vector", {
  x <- structure(1, class = "base_class")

  y <- addClass(x, c("new_class", "another_class"), prepend = FALSE)

  expect_identical(class(y), c("new_class", "another_class"))
  expect_identical(class(x), "base_class")
})

test_that(
  "isVector() accepts multiple modes and rejects any with other types",
  {
    x <- c(a = 1, b = 2)

    expect_true(isVector(x))
    expect_true(isVector(x, mode = c("character", "list", "numeric")))
    expect_true(isVector(list(x), mode = "list"))
    expect_false(isVector(x, mode = c("character", "logical")))
    expect_error(isVector(x, mode = c("numeric", "any")))
  }
)

test_that("date helpers detect inherited classes", {
  d <- as.Date("2020-01-01")
  ct <- as.POSIXct("2020-01-01 00:00:00", tz = "UTC")
  lt <- as.POSIXlt(ct)

  expect_true(is.datetype(d))
  expect_true(is.datetype(ct))
  expect_true(is.datetype(lt))
  expect_false(is.datetype("2020-01-01"))

  expect_true(is.Date(d))
  expect_false(is.Date(ct))
  expect_false(is.Date(lt))

  expect_true(is.POSIXt(ct))
  expect_true(is.POSIXt(lt))
  expect_false(is.POSIXt(d))

  expect_true(is.POSIXct(ct))
  expect_false(is.POSIXct(lt))
  expect_false(is.POSIXct(d))

  expect_true(is.POSIXlt(lt))
  expect_false(is.POSIXlt(ct))
  expect_false(is.POSIXlt(d))
})

test_that("logical and string helpers validate scalar inputs", {
  expect_true(is.boolean(TRUE))
  expect_true(is.boolean(FALSE))
  expect_false(is.boolean(NA))
  expect_false(is.boolean(c(TRUE, FALSE)))
  expect_false(is.boolean(1))

  expect_true(is.string("hello"))
  expect_true(is.string(""))
  expect_false(is.string(NA_character_))
  expect_false(is.string(c("a", "b")))
  expect_false(is.string(1))

  expect_true(nzstring("hello"))
  expect_false(nzstring(""))
  expect_false(nzstring(NA_character_))
  expect_false(nzstring(c("a", "b")))
})
