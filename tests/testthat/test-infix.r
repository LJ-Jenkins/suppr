test_that("%''% and %\"\"% tests", {
  expect_identical("" %''% "default", "default")
  expect_identical("value" %''% "default", "value")
  expect_identical("" %""% "default", "default")
  expect_identical("value" %""% "default", "value")
})

test_that("%!||% tests", {
  expect_identical(NULL %!||% "default", NULL)
  expect_identical("value" %!||% "default", "default")
})

test_that("%0% tests", {
  expect_identical(integer(0) %0% 5L, 5L)
  expect_identical(c(1, 2, 3) %0% 5L, c(1, 2, 3))
})

test_that("%allin% tests", {
  expect_true(c(1, 2, 3) %allin% c(1, 2, 3, 4))
  expect_false(c(1, 2, 3) %allin% c(1, 2))
  expect_true(NA %allin% c(1, NA))
  expect_false(c(1, NA) %allin% NA)
})

test_that("%allin% NULL checks", {
  expect_identical(NULL %allin% c(1, 2, 3), logical(0))
  expect_false(c(1, 2, 3) %allin% NULL)
  expect_identical(NULL %allin% NULL, logical(0))
  expect_true(list(1, NULL) %allin% list(1, NULL))
})

test_that("%anyin% tests", {
  expect_true(c(1, 2, 3) %anyin% c(1, 2, 3, 4))
  expect_true(c(1, 2, 3) %anyin% c(1, 2))
  expect_true(NA %anyin% c(1, NA))
  expect_true(c(1, NA) %anyin% NA)
})

test_that("%anyin% NULL checks", {
  expect_identical(NULL %anyin% c(1, 2, 3), logical(0))
  expect_false(c(1, 2, 3) %anyin% NULL)
  expect_identical(NULL %anyin% NULL, logical(0))
  expect_true(list(1, NULL) %anyin% list(NULL, 2))
})

test_that("%nonein% tests", {
  expect_false(c(1, 2, 3) %nonein% c(1, 2, 3, 4))
  expect_false(c(1, 2, 3) %nonein% c(1, 2))
  expect_true(c(6, 7, 8) %nonein% c(1, 2, 3, 4, 5))
  expect_false(NA %nonein% c(1, NA))
  expect_false(c(1, NA) %nonein% NA)
})

test_that("%nonein% NULL checks", {
  expect_identical(NULL %nonein% c(1, 2, 3), logical(0))
  expect_true(c(1, 2, 3) %nonein% NULL)
  expect_identical(NULL %nonein% NULL, logical(0))
  expect_false(list(1, NULL) %nonein% list(NULL, 2))
})

test_that("%onein% tests", {
  expect_false(c(1, 2, 3) %onein% c(1, 2, 3, 4))
  expect_false(c(1, 2, 3) %onein% c(1, 2))
  expect_true(c(5, 6, 7, 8) %onein% c(1, 2, 3, 4, 5))
  expect_true(NA %onein% c(1, NA))
  expect_true(c(1, NA) %onein% NA)
})

test_that("%onein% NULL checks", {
  expect_identical(NULL %onein% c(1, 2, 3), logical(0))
  expect_false(c(1, 2, 3) %onein% NULL)
  expect_identical(NULL %onein% NULL, logical(0))
  expect_true(list(1, NULL) %onein% list(NULL, 2))
})

test_that("%notin% tests", {
  expect_identical(c(1, 2, 3) %notin% c(1, 2, 3, 4), c(FALSE, FALSE, FALSE))
  expect_identical(c(1, 2, 3) %notin% c(1, 2), c(FALSE, FALSE, TRUE))
  expect_identical(c(6, 7, 8) %notin% c(1, 2, 3, 4, 5), c(TRUE, TRUE, TRUE))
  expect_identical(NA %notin% c(1, NA), FALSE)
  expect_identical(c(1, NA) %notin% NA, c(TRUE, FALSE))
})

test_that("%notin% NULL checks", {
  expect_identical(NULL %notin% c(1, 2, 3), logical(0))
  expect_identical(c(1, 2, 3) %notin% NULL, c(TRUE, TRUE, TRUE))
  expect_identical(NULL %notin% NULL, logical(0))
  expect_identical(list(1, NULL) %notin% list(NULL, 2), c(TRUE, FALSE))
})
