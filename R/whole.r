#' @title Are vectors whole or integer-like?
#' @description
#' Tests if numeric vectors are whole or integerish  according to a
#' tolerance.
#'
#' `is.whole()` and `is.integerish()` check if the entire vector
#' is whole or integerish, whilst `is.wholenumber()` checks element-wise
#' for wholeness.
#' @param x a logical, numeric, or complex vector.
#' @param tol tolerance for wholeness.
#' @return
#' For `is.whole()` and `is.integerish()` a single `TRUE` or `FALSE`.
#'
#' For `is.wholenumber()`, a logical vector of the same length as `x`.
#' @details
#' `is.integerish()` tests if a vector is integerish by evaluating if the
#' remainder of the  [absolute][abs] value of `x` divided by `1` is equal
#' to `0.0` in the `C` code.
#'
#' `is.whole()` and `is.wholenumber()` test for wholeness by evaluating
#' if the [absolute][abs] value of `x` minus its rounded value is less than
#' the given tolerance.
#'
#' Both `is.integerish()` and `is.whole()` ignore non-finite values (i.e.,
#' treat them as integerish/whole) and only test finite values for
#' integerishness or wholeness. If you do not want this behavior, use
#' [anyNF], e.g., `!anyNF(x) && is.whole(x)`.
#'
#' `is.wholenumber()` returns `NA` for non-finite elements.
#' @seealso [is.integerish]
#' @export
#' @examples
#' is.integerish(1)
#' is.integerish(1.0)
#' is.integerish(1.0000000001)
#' is.integerish(1.0000000000000001)
#'
#' is.wholenumber(1)
#' x <- c(1.0, 1.0000001, 1.0000000001)
#' is.wholenumber(x)
#' is.whole(x)
#'
#'
#' # ignores non-finite values:
#' is.integerish(c(Inf, -Inf, NaN, NA))
#' is.whole(c(Inf, -Inf, NaN, NA))
#'
#' # non-finite values flag as NA:
#' is.wholenumber(c(Inf, -Inf, NaN, NA))
#'
#' # all error on non-numeric vector inputs:
#' try(is.integerish("1"))
#' try(is.whole("1"))
#' try(is.wholenumber("1"))
#' @export
is.whole <- function(x, tol = .Machine$double.eps^0.5) {
  .Call(C_is_whole, x, tol)
}

#' @rdname is.whole
#' @export
is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
  .Call(C_is_wholenumber, x, tol)
}

#' @rdname is.whole
#' @export
is.integerish <- function(x) {
  .Call(C_is_integerish, x)
}
