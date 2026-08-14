#' @title Is a Number Even or Odd?
#' @description Show where a numeric input is even or odd.
#' @param x numeric (logical, integer or double) vector.
#' @param noparity.na logical, whether values without parity
#' (e.g., `NA`, `NaN`, `Inf`, `-Inf`, and decimal numbers)
#' should return `NA` (when `noparity.na = TRUE`) or `FALSE`
#' (when `noparity.na = FALSE`).
#' @return logical vector the length of `x`.
#' @examples
#' is.even(2)
#' is.odd(1)
#'
#' is.even(-5:5)
#' is.odd(-5:5)
#'
#' m <- matrix(1:4, nrow = 2, ncol = 2)
#' is.even(m)
#' is.odd(m)
#'
#' # inputs without parity can be handled as NA or FALSE:
#' x <- c(2.0, 3.0, 2.2, 3.1, NA, Inf, -Inf, NaN)
#' is.even(x)
#' is.odd(x)
#' is.even(x, noparity.na = TRUE)
#' is.odd(x, noparity.na = TRUE)
#' @export
is.even <- function(x, noparity.na = FALSE) {
  if (isTRUE(noparity.na)) {
    .Call(C_is_even_odd, x, 0L, 1L)
  } else {
    .Call(C_is_even_odd, x, 0L, 0L)
  }
}

#' @export
#' @rdname is.even
is.odd <- function(x, noparity.na = FALSE) {
  if (isTRUE(noparity.na)) {
    .Call(C_is_even_odd, x, 1L, 1L)
  } else {
    .Call(C_is_even_odd, x, 1L, 0L)
  }
}
