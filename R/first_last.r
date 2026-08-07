#' @title Remove First or Last N Elements
#' @description
#' Remove the first or last `n` elements of an **R** object.
#' @param x an **R** object with a `[` method, e.g., a vector, matrix, list.
#' @param n integer, number of elements to remove from the beginning or end.
#' @param ... additional arguments passed to methods.
#' @param value integer, same as `n`.
#' @details
#' The default methods operate on atomic
#' vectors and lists, removing `n` elements from the beginning or end of
#' the object.
#'
#' Dimensional objects ([matrix], [data.frame], [array]) are handled by
#' removing `n` entries along the first dimension ('row-wise' for
#' matrices/data.frames and for each slice of higher-dimensional arrays).
#' Remaining dimensions are preserved.
#' @return The modified object with the first or last `n` elements removed.
#' @examples
#' x <- 1:10
#' rm.first(x, 3)
#' rm.last(x, 3)
#'
#' x <- matrix(1:10, nrow = 5)
#' rm.first(x, 2)
#' rm.last(x, 2)
#'
#' x <- list(a = 1, b = 2, c = 3, d = 4)
#' rm.first(x, 2)
#' rm.last(x, 2)
#'
#' x <- 1:10
#' rm.first(x) <- 3
#' rm.last(x) <- 3
#' x
#' @export
rm.first <- function(x, n = 1L, ...) {
  UseMethod("rm.first")
}

#' @rdname rm.first
#' @export
rm.first.default <- function(x, n = 1L, ...) {
  checkDots(...)
  if (!is.atomic(x) && !is.list(x)) {
    stop(
      "The default method for ", sQuote("rm.first"),
      " is only for atomic vectors and lists."
    )
  }
  stopifnot(length(x) >= n, n > 0L, length(n) == 1L)
  x[-seq_len(n)]
}

#' @export
rm.first.matrix <- function(x, n = 1L, ...) {
  checkDots(...)
  nrows <- dim(x)[1]
  stopifnot(nrows >= n, n > 0L, length(n) == 1L)
  x[-seq_len(n), , drop = FALSE]
}

#' @export
rm.first.data.frame <- function(x, n = 1L, ...) {
  checkDots(...)
  nrows <- dim(x)[1]
  stopifnot(nrows >= n, n > 0L, length(n) == 1L)
  x[-seq_len(n), , drop = FALSE]
}

#' @export
rm.first.array <- function(x, n = 1L, ...) {
  checkDots(...)
  nrows <- dim(x)[1]
  stopifnot(nrows >= n, n > 0L, length(n) == 1L)

  do.call(
    "[",
    c(
      list(x, -seq_len(n)),
      rep(list(TRUE), length(dim(x)) - 1L),
      list(drop = FALSE)
    )
  )
}


#' @rdname rm.first
#' @export
`rm.first<-` <- function(x, ..., value) {
  UseMethod("rm.first<-")
}

#' @rdname rm.first
#' @export
`rm.first<-.default` <- function(x, ..., value) {
  rm.first.default(x, n = value, ...)
}

#' @export
`rm.first<-.matrix` <- function(x, ..., value) {
  rm.first.matrix(x, n = value, ...)
}

#' @export
`rm.first<-.data.frame` <- function(x, ..., value) {
  rm.first.data.frame(x, n = value, ...)
}

#' @export
`rm.first<-.array` <- function(x, ..., value) {
  rm.first.array(x, n = value, ...)
}

#' @rdname rm.first
#' @export
rm.last <- function(x, n = 1L, ...) {
  UseMethod("rm.last")
}

#' @rdname rm.first
#' @export
rm.last.default <- function(x, n = 1L, ...) {
  checkDots(...)
  if (!is.atomic(x) && !is.list(x)) {
    stop(
      "The default method for ", sQuote("rm.last"),
      " is only for atomic vectors and lists."
    )
  }

  x_length <- length(x)
  stopifnot(x_length >= n, n > 0L, length(n) == 1L)
  x[-((x_length - n + 1L):x_length)]
}

#' @export
rm.last.matrix <- function(x, n = 1L, ...) {
  checkDots(...)
  nrows <- dim(x)[1]
  stopifnot(nrows >= n, n > 0L, length(n) == 1L)
  x[-((nrows - n + 1L):nrows), , drop = FALSE]
}

#' @export
rm.last.data.frame <- function(x, n = 1L, ...) {
  checkDots(...)
  nrows <- dim(x)[1]
  stopifnot(nrows >= n, n > 0L, length(n) == 1L)
  x[-((nrows - n + 1L):nrows), , drop = FALSE]
}

#' @export
rm.last.array <- function(x, n = 1L, ...) {
  checkDots(...)
  nrows <- dim(x)[1]
  stopifnot(nrows >= n, n > 0L, length(n) == 1L)

  do.call(
    "[",
    c(
      list(x, -((nrows - n + 1L):nrows)),
      rep(list(TRUE), length(dim(x)) - 1L),
      list(drop = FALSE)
    )
  )
}

#' @rdname rm.first
#' @export
`rm.last<-` <- function(x, ..., value) {
  UseMethod("rm.last<-")
}

#' @rdname rm.first
#' @export
`rm.last<-.default` <- function(x, ..., value) {
  rm.last.default(x, n = value, ...)
}

#' @export
`rm.last<-.matrix` <- function(x, ..., value) {
  rm.last.matrix(x, n = value, ...)
}

#' @export
`rm.last<-.data.frame` <- function(x, ..., value) {
  rm.last.data.frame(x, n = value, ...)
}

#' @export
`rm.last<-.array` <- function(x, ..., value) {
  rm.last.array(x, n = value, ...)
}
