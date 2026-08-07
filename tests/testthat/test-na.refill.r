test_that("na.refill() for vectors", {
  x <- c(1, 2, NA, 4, NA, 6)
  na_x <- na.omit(x)
  out <- na.refill(na_x)

  expect_identical(
    out,
    c(1, 2, NA, 4, NA, 6),
    ignore_attr = "na.action"
  )

  expect_identical(
    unclass(attr(out, "na.action")),
    unclass(attr(na_x, "na.action"))
  )
  expect_s3_class(attr(out, "na.action"), "refilled")

  x_named <- stats::setNames(x, paste0("v", seq_along(x)))
  na_x_named <- na.omit(x_named)
  out_named <- na.refill(na_x_named)

  expect_identical(out_named, x_named, ignore_attr = "na.action")
  expect_identical(names(out_named), names(x_named))

  # no re-naming if names removed after na.omit
  x_named <- stats::setNames(x, paste0("v", seq_along(x)))
  na_x_named <- na.omit(x_named)
  names(na_x_named) <- NULL
  expect_null(names(na.refill(na_x_named)))

  expect_identical(na.refill(1:3), 1:3)
  expect_identical(
    na.refill(list(1, NA, 3)),
    list(1, NA, 3)
  )
})

test_that("na.refill() for matrices", {
  m <- matrix(1:9, 3, 3)
  m[c(1, 3), 1:2] <- NA
  dimnames(m) <- list(c("r1", "r2", "r3"), c("a", "b", "c"))

  na_m <- na.omit(m)
  out <- na.refill(na_m)

  expect_identical(dim(out), dim(m))
  expect_identical(colnames(out), colnames(m))
  expect_identical(rownames(out), rownames(m))
  expect_true(all(is.na(out[c(1, 3), ])))
  expect_identical(out[2, ], m[2, ])
  expect_identical(
    unclass(attr(out, "na.action")),
    unclass(attr(na_m, "na.action"))
  )
  expect_s3_class(attr(out, "na.action"), "refilled")

  m <- matrix(1:9, 3, 3)
  m[c(1, 3), 1] <- NA
  na_m <- na.omit(m)
  out <- na.refill(na_m)

  expect_null(dimnames(out))
  expect_true(all(is.na(out[c(1, 3), ])))

  m <- matrix(1:9, 3, 3)
  m[c(1, 3), 1:2] <- NA
  dimnames(m) <- list(NULL, c("a", "b", "c"))
  na_m <- na.omit(m)
  expect_null(rownames(na.refill(na_m)))

  # no re-naming if names removed after na.omit
  m <- matrix(1:9, 3, 3)
  m[c(1, 3), 1:2] <- NA
  dimnames(m) <- list(c("r1", "r2", "r3"), c("a", "b", "c"))
  na_m <- na.omit(m)
  rownames(na_m) <- NULL
  expect_null(rownames(na.refill(na_m)))

  expect_identical(
    na.refill(matrix(1:4, 2, 2)),
    matrix(1:4, 2, 2)
  )
})

test_that("na.refill() for data.frames", {
  df <- data.frame(
    x = 1:5,
    y = c("a", NA, "c", "d", NA),
    stringsAsFactors = FALSE
  )

  na_df <- na.omit(df)
  out <- na.refill(na_df)

  expect_identical(colnames(out), colnames(df))
  expect_identical(rownames(out), rownames(df))
  expect_identical(out[["x"]], c(1L, NA, 3L, 4L, NA))
  expect_identical(out[["y"]], df[["y"]])
  expect_true(all(is.na(out[c(2, 5), ])))
  expect_identical(
    unclass(attr(out, "na.action")),
    unclass(attr(na_df, "na.action"))
  )
  expect_s3_class(attr(out, "na.action"), "refilled")

  nna_sub <- df[c(1, 3, 4), ]
  nna_sub_refill <- out[c(1, 3, 4), ]
  expect_identical(nna_sub_refill, nna_sub, ignore_attr = "na.action")

  df <- data.frame(a = c(1, NA, 3), b = c("x", NA, "z"))
  rownames(df) <- c("r1", "r2", "r3")
  na_df <- na.omit(df)
  out <- na.refill(na_df)

  expect_identical(out, df, ignore_attr = "na.action")
  expect_identical(rownames(out), rownames(df))

  # error if row.names missing
  df <- data.frame(a = c(1, NA, 3), b = c("x", NA, "z"))
  rownames(df) <- c("r1", "r2", "r3")
  na_df <- na.omit(df)
  attr(na_df, "row.names") <- NULL
  expect_error(na.refill(na_df))

  expect_identical(na.refill(data.frame(a = 1:2)), data.frame(a = 1:2))
})
