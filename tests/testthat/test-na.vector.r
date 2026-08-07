test_that("na.vector() tests", {
  types <- c(
    "logical", "integer", "double",
    "numeric", "character", "complex",
    "list"
  )

  for (type in types) {
    out <- na.vector(3L, type)
    expect_length(out, 3L)
    expect_type(out, if (type == "numeric") "double" else type)
    expect_true(all(is.na(out)))
  }
})

test_that("na.vector() errors on unsupported types", {
  expect_error(na.vector(3L, "raw"))
  expect_error(na.vector(3L, "data.frame"))
  expect_error(na.vector(3L, "function"))
})
