#' @title Infix Operator Helpers
#' @description Infix operators for common tasks.
#'
#' `%''%` and `%""%` return the right-hand side if the left-hand side is
#' an empty string (`""`).
#'
#' `%!||%` returns the right-hand side if the left-hand side is not
#' `NULL`.
#'
#' `%0%` returns the right-hand side if the left-hand side has length 0.
#'
#' `%allin%` returns `TRUE` if all elements of the left-hand side are in
#' the right-hand side.
#'
#' `%anyin%` returns `TRUE` if any elements of the left-hand side are in
#' the right-hand side.
#'
#' `%nonein%` returns `TRUE` if none of the elements of the left-hand side
#' are in the right-hand side.
#'
#' `%onein%` returns `TRUE` if exactly one element of the left-hand side is
#' in the right-hand side.
#'
#' `%notin%` returns `TRUE` if none of the elements of the left-hand side
#' are in the right-hand side. This is implemented in the same way as base R
#' and will be replaced by the base version in the R versions that have it.
#' @param lhs left-hand side object.
#' @param rhs right-hand side object.
#' @param x vector or `NULL`: the values to be matched.
#' [Long vectors] are supported.
#' @param table vector or `NULL`: the values to be matched against.
#' [Long vectors] are not supported.
#' @return either the left-hand side or right-hand side, depending on
#' the result of the operator.
#' @details
#' The `%*in%` operators follow the semantics of `%in%` for `NULL`
#' values:
#'
#' * Singular `NULL`'s on the lhs always returns a length 0 logical vector.
#' * `NULL` elements are not considered equal to singular `NULL`'s so will
#' give a `TRUE` for `%nonein%` and `%notin%` and `FALSE` for `%allin%`,
#' `%anyin%` and `%onein%`.
#'
#' See `%in%` semantics:
#' ```{r eval=TRUE}
#' NULL %in% NULL
#' NULL %in% list(1, NULL)
#' list(1, NULL) %in% NULL
#' list(1, NULL) %in% list(1, NULL)
#' ```
#' @name suppr-infix
#' @examples
#' "" %''% "default" # if lhs is "", return rhs
#'
#' NULL %!||% "default" # if lhs is NULL, return *lhs* (NULL)
#' # useful for when using NULL as a default value
#' # or when using elements of a list that may be NULL
#' # e.g.,
#' lst <- list(a = 1, b = 2)
#' x <- lst$nope %!||% mean(lst$nope) # returns NULL
#'
#' integer(0) %0% 5L # if lhs is length 0, return rhs
#'
#' c(1, 2, 3) %allin% c(1, 2, 3, 4) # TRUE
#'
#' c(1, 2, 3) %anyin% c(1, 2, 3, 4) # TRUE
#'
#' c(1, 2, 3) %nonein% c(4, 5, 6) # TRUE
#'
#' c(1, 2, 3) %onein% c(1, 4, 5) # TRUE
#'
#' c(1, 2, 3) %notin% c(4, 5, 6) # TRUE
NULL

#' @rdname suppr-infix
#' @export
`%''%` <- function(lhs, rhs) if (lhs == "") rhs else lhs

#' @rdname suppr-infix
#' @export
`%""%` <- function(lhs, rhs) if (lhs == "") rhs else lhs

#' @rdname suppr-infix
#' @export
`%!||%` <- function(lhs, rhs) if (is.null(lhs)) lhs else rhs

#' @rdname suppr-infix
#' @export
`%0%` <- function(lhs, rhs) if (!length(lhs)) rhs else lhs

#' @rdname suppr-infix
#' @export
`%allin%` <- function(x, table) {
  y <- match(x, table)
  if (!length(y)) {
    logical(0)
  } else {
    !anyNA(y)
  }
}

#' @rdname suppr-infix
#' @export
`%anyin%` <- function(x, table) {
  y <- match(x, table, nomatch = 0L) > 0L
  if (!length(y)) {
    logical(0)
  } else {
    sum(y) >= 1L
  }
}

#' @rdname suppr-infix
#' @export
`%nonein%` <- function(x, table) {
  y <- match(x, table, nomatch = 0L)
  if (!length(y)) {
    logical(0)
  } else {
    sum(y) == 0L
  }
}

#' @rdname suppr-infix
#' @export
`%onein%` <- function(x, table) {
  y <- match(x, table, nomatch = 0L) > 0L
  if (!length(y)) {
    logical(0)
  } else {
    sum(y) == 1L
  }
}

# to match upcoming base R version
#' @rdname suppr-infix
#' @export
`%notin%` <- function(x, table) match(x, table, nomatch = 0L) == 0L

if (exists("%notin%", envir = baseenv())) {
  `%notin%` <- get("%notin%", envir = baseenv())
}
