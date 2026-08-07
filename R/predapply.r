#' @title Apply a predicate function over a list or vector
#' @description
#' Returns a logical of the same length as `X`, each element of which is
#' the result of applying predicate `FUN` to the corresponding element
#' of `X.`
#' @param X a vector (atomic or list) or an expression object.
#' Other objects (including classed objects) will be coerced by
#' [`as.list`].
#' @param FUN a predicate function to be applied to each element of
#' `X` that returns a single logical value.
#' @param ... optional arguments to `FUN`.
#' @param reduce `NULL` or one of `"all"`, `"any"`, or `"none"`. When
#' non-`NULL`, the output logical vector is reduced to a single boolean
#' value using [all], [any] or `"none"` (`all(!logi)`).
#' @param na.as logical value to return for `NA` values in the output logical
#' vector (`NA`, `TRUE` or `FALSE`).
#' @details
#' `na.as` is most meaningful when `reduce` is non-`NULL`, as it allows control
#' flow calls (e.g., `if (predapply(...))`) to proceed without error.
#' See examples.
#' @return logical vector or boolean if `reduce` is non-`NULL`.
#' @seealso [apply], [lapply], [mapply], [all], [any].
#' @examples
#' x <- list(a = 1, b = 2, c = NA)
#' predapply(x, is.numeric)
#' predapply(x, is.numeric, reduce = "any")
#'
#' x <- list(a = 1, b = 2, c = 3)
#' predapply(x, is.numeric, reduce = "all")
#'
#' x <- list(a = "1", b = "2", c = "3")
#' predapply(x, is.numeric, reduce = "none")
#'
#' x <- c(1, 2, NA)
#' predapply(x, function(x) x > 0)
#' predapply(x, function(x) x > 0, reduce = "all")
#' predapply(x, function(x) x > 0, reduce = "all", na.as = TRUE)
#' @export
predapply <- function(X, FUN, ..., reduce = NULL, na.as = NA) {
  logi <- vapply(
    X = X,
    FUN = FUN,
    FUN.VALUE = logical(1),
    ...,
    USE.NAMES = TRUE
  )

  if (!is.na(na.as)) {
    stopifnot(is.logical(na.as), length(na.as) == 1L)
    logi[is.na(logi)] <- na.as
  }

  if (!is.null(reduce)) {
    reduce <- match.arg(reduce, c("all", "any", "none"))

    logi <- switch(reduce,
      all = all(logi),
      any = any(logi),
      none = all(!logi)
    )
  }

  logi
}
