#' @title Where is the min or max?
#' @description
#' Determines the location (i.e., index) of the (first, last, or all)
#' minima or maxima of a numeric (or logical) vector.
#' @param x numeric (logical, integer or double) vector or an **R**
#' object for which the internal coercion to [double] works whose [min]
#' or [max] is searched for.
#' @param loc 'first', 'last' or 'all' to specify which index/indices
#' to return.
#' @return integer of indices.
#' @note
#' For `logical` vectors, `which(x)` is faster than
#' `whichMax(x, loc = "all")`, but `whichMin(x, loc = "all")` can
#' be faster than `which(!x)` for medium to large vectors due to
#' not having the performance cost of negating the vector.
#' @seealso [which], [which.max] and [which.min]
#' @examples
#' x <- c(1:4, 0:5, 11, 1:4, 0:5, 11)
#' whichMin(x)
#' whichMin(x, loc = "last")
#' whichMax(x)
#' whichMax(x, loc = "all")
#'
#' # it *does* work with NA's present, by discarding them:
#' presidents[1:30]
#' whichMin(presidents) # 28
#' whichMax(presidents) #  2
#'
#' # Find the first occurrence, i.e. the first TRUE, if there is at least one:
#' x <- rpois(10000, lambda = 10)
#' x[sample.int(50, 20)] <- NA
#' # where is the first value >= 20 ?
#' whichMax(x >= 20)
#' whichMax(x >= 20, loc = "last")
#' whichMax(x >= 20, loc = "all")
#'
#' # objects are coerced to numeric vectors if possible:
#' whichMin(list(A = 7, pi = pi)) ##  ->  c(pi = 2L)
#'
#' x <- 1:4
#' whichMin(x) <- 999
#' whichMax(x) <- -999
#' x
#' @export
whichMin <- function(x, loc = c("first", "last", "all")) {
  loc <- match.arg(loc, c("first", "last", "all"))
  switch(loc,
    first = which.min(x),
    last = .Call(C_which_last_min_max, x, 0L),
    all = .Call(C_which_all_min_max, x, 0L)
  )
}

#' @rdname whichMin
#' @export
`whichMin<-` <- function(x, value, loc = c("first", "last", "all")) {
  x[whichMin(x, loc = loc)] <- value
  x
}

#' @rdname whichMin
#' @export
whichMax <- function(x, loc = c("first", "last", "all")) {
  loc <- match.arg(loc, c("first", "last", "all"))
  switch(loc,
    first = which.max(x),
    last = .Call(C_which_last_min_max, x, 1L),
    all = .Call(C_which_all_min_max, x, 1L)
  )
}

#' @rdname whichMin
#' @export
`whichMax<-` <- function(x, value, loc = c("first", "last", "all")) {
  x[whichMax(x, loc = loc)] <- value
  x
}

#' @title Which indices are NA?
#' @description
#' Give the indices of `NA` values, allowing for array indices.
#' Use the assignment function `whichNA<-` to replace `NA` values
#' with a given value/s.
#' @param x numeric **R** object. Does not accept `complex` or `raw.`
#' @param value value to replace `NA` values with when using the assignment
#' function.
#' @return If using `whichNA`, integer vector of indices of `NA` values
#' in `x`, or matrix of array indices if `arr.ind` is `TRUE`.
#' If using `whichNA<-`, the modified object with `NA` values replaced by
#' `value`.
#' @details `whichNA<-` follows **R**'s usual recycling rules when
#' replacing `NA` values with `value`. If there are no `NA` values in `x`,
#' no replacement is made.
#' @seealso [is.na], [setNA], [whichMin], [whichMax]
#' @examples
#' x <- c(1, NA, 3, NA, 5)
#' whichNA(x)
#' whichNA(x) <- 0
#' x
#'
#' m <- matrix(c(1, NA, 3, NA, 5, NA), nrow = 2)
#' whichNA(m)
#'
#' y <- c("a" = 1, "b" = NA, "c" = 2, "d" = NA, "e" = NA, "f" = NA)
#' whichNA(y)
#' whichNA(y) <- c(91, 92) # value recycled to number of NA's
#' y
#' @export
whichNA <- function(x) {
  .Call(C_which_na, x)
}

#' @rdname whichNA
#' @export
`whichNA<-` <- function(x, value) {
  x[whichNA(x)] <- value
  x
}
