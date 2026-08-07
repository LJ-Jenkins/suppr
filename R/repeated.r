#' @title Determine Repeated Elements
#' @description
#' Return a mask, indices, or values of repeated elements
#' in a vector.
#' @details
#' The `repeated` functions determine which elements of a vector
#' or data frame are duplicates of elements with smaller subscripts.
#' They are very similar in functionality to [duplicated] but
#' instead mark **all** duplicates (not just those after the
#' first/last occurrence), and do not have an `incomparables`
#' argument.
#'
#' These are generic functions with methods for vectors
#' (including lists and expressions), data frames and arrays
#' (including matrices).
#'
#' The array method calculates for each element of the sub-array
#' specified by `MARGIN` if the dimensions are identical
#' to those for an earlier or later element (in row-major order).
#' This would most commonly be used to find repeated rows
#' (the default) or columns (with `MARGIN = 2`). Note that
#' `MARGIN = 0` returns an array of the same dimensionality
#' attributes as `x`.
#'
#' `non.unique()` is an alias for `repeats()`.
#' @param x a vector, a data frame, an array, or `NULL`.
#' @param ... additional arguments passed to methods.
#' @param MARGIN the array margin to be held fixed: see [apply],
#' and note that `MARGIN = 0` may be useful.
#' @return
#' `repeated()`: For a vector input, a logical vector of the
#' same length as `x`. For a data frame, a logical vector
#' with one element for each row. For a matrix or array, and
#' when `MARGIN = 0`, a logical array with the same dimensions
#' and dimnames.
#'
#' `whichRepeated()`: For a vector input, an integer vector
#' giving the indices of the repeated values. For a data frame,
#' an integer vector giving the indices of the repeated rows.
#' For a matrix or array, an integer vector giving the indices
#' of the repeated elements across the margin specified.
#'
#' `repeats()` and its alias `non.unique()`: an object of
#' the same type as `x`, containing the repeated values
#' (vector input), rows (data frame input), or elements across
#' the margin (matrix/array input).
#' @seealso [duplicated] and [unique].
#' @examples
#' # Repeated values in a vector
#' x <- c(1, 2, 3, 2, 1)
#'
#' repeated(x)
#' whichRepeated(x)
#' repeats(x)
#'
#' # Repeated rows in a data frame
#' df <- data.frame(
#'   x = c(1, 2, 1),
#'   y = c("a", "b", "a")
#' )
#'
#' repeated(df)
#' repeats(df)
#'
#' # Repeated rows/columns in a matrix
#' m <- cbind(
#'   c(1, 2),
#'   c(3, 4),
#'   c(1, 2)
#' )
#'
#' repeated(m)
#' repeated(m, MARGIN = 2)
#' repeats(m, MARGIN = 2)
#'
#' # non.unique() is an alias for repeats()
#' identical(repeats(x), non.unique(x))
#' @export
repeated <- function(x, ...) {
  UseMethod("repeated")
}

# handle same cases as base::duplicated, in the same way
#' @export
repeated.default <- function(x, ...) {
  .Call(C_repeated, x)
}

#' @export
repeated.data.frame <- function(x, ...) {
  n <- length(x)
  if (!n) {
    !logical(nrow(x))
  } else if (n == 1L) {
    repeated(x[[1L]], ...)
  } else {
    x <- .prep_repeat_df(x)
    repeated(
      do.call(Map, `names<-`(c(list, x), NULL))
    )
  }
}

#' @rdname repeated
#' @export
repeated.array <- function(x, MARGIN = 1L, ...) {
  .repeated_array_matrix(x, MARGIN, ...)
}

#' @rdname repeated
#' @export
repeated.matrix <- function(x, MARGIN = 1L, ...) {
  .repeated_array_matrix(x, MARGIN, ...)
}

.repeated_array_matrix <- function(x, MARGIN = 1L, ...) {
  dx <- dim(x)
  ndim <- length(dx)
  y <- .prep_repeat_array(x, MARGIN, dx, ndim)

  res <- repeated.default(y, ...)

  dim(res) <- dim(y)
  dimnames(res) <- dimnames(y)

  res
}

#' @rdname repeated
#' @export
whichRepeated <- function(x, ...) {
  UseMethod("whichRepeated")
}

#' @export
whichRepeated.default <- function(x, ...) {
  .Call(C_repeated_indices, x)
}

#' @export
whichRepeated.data.frame <- function(x, ...) {
  n <- length(x)

  if (!n) {
    integer(0L)
  } else if (n == 1L) {
    whichRepeated(x[[1L]], ...)
  } else {
    x <- .prep_repeat_df(x)
    whichRepeated(
      do.call(Map, `names<-`(c(list, x), NULL))
    )
  }
}

#' @rdname repeated
#' @export
whichRepeated.array <- function(x, MARGIN = 1L, ...) {
  .whichRepeated_array_matrix(x, MARGIN, ...)
}

#' @rdname repeated
#' @export
whichRepeated.matrix <- function(x, MARGIN = 1L, ...) {
  .whichRepeated_array_matrix(x, MARGIN, ...)
}

.whichRepeated_array_matrix <- function(x, MARGIN = 1L, ...) {
  dx <- dim(x)
  ndim <- length(dx)
  y <- .prep_repeat_array(x, MARGIN, dx, ndim)

  whichRepeated.default(y, ...)
}

#' @rdname repeated
#' @export
repeats <- function(x, ...) {
  UseMethod("repeats")
}

# handle same cases as base::unique, in the same way
#' @export
repeats.default <- function(x, ...) {
  if (!is.object(x)) {
    return(.Call(C_repeats, x))
  }

  if (is.factor(x)) {
    return(
      factor(
        .Call(C_repeats, x),
        levels = seq_len(nlevels(x)),
        labels = levels(x),
        ordered = is.ordered(x)
      )
    )
  }

  res <- .Call(C_repeats, x)

  if (inherits(x, "POSIXct")) {
    .POSIXct(res, attr(x, "tzone"), class(x))
  } else if (inherits(x, "Date")) {
    .Date(res, class(x))
  } else if (inherits(x, "difftime")) {
    .difftime(res, attr(x, "units"), class(x))
  } else {
    res
  }
}

#' @export
repeats.data.frame <- function(x, ...) {
  x[repeated.data.frame(x, ...), , drop = FALSE]
}

#' @rdname repeated
#' @export
repeats.array <- function(x, MARGIN = 1L, ...) {
  .repeats_array_matrix(x, MARGIN, ...)
}

#' @rdname repeated
#' @export
repeats.matrix <- function(x, MARGIN = 1L, ...) {
  .repeats_array_matrix(x, MARGIN, ...)
}

.repeats_array_matrix <- function(x, MARGIN = 1L, ...) {
  dx <- dim(x)
  ndim <- length(dx)
  temp <- .prep_repeat_array(x, MARGIN, dx, ndim, msize = 1L)

  args <- rep(alist(a = ), ndim)
  names(args) <- NULL

  args[[MARGIN]] <- repeated.default(temp, ...)
  do.call(`[`, c(list(x), args, list(drop = FALSE)))
}

#' @rdname repeated
#' @export
non.unique <- function(x, ...) {
  repeats(x, ...)
}

.prep_repeat_df <- function(x) {
  if (any(i <- vapply(x, is.factor, NA))) {
    x[i] <- lapply(x[i], as.numeric)
  }

  if (any(i <- lengths(lapply(x, dim)) == 2L)) {
    x[i] <- lapply(x[i], split.data.frame, seq_len(nrow(x)))
  }

  x
}

.prep_repeat_array <- function(x, MARGIN, dx, ndim, msize = NULL) {
  i <- if (!is.null(msize)) {
    length(MARGIN) != msize || (MARGIN > ndim)
  } else {
    any(MARGIN > ndim)
  }

  if (i) {
    stop(
      gettextf(
        "MARGIN = %s is invalid for dim = %s",
        paste(MARGIN, collapse = ","),
        paste(dx, collapse = ",")
      ),
      domain = NA
    )
  }

  if ((ndim > 1L) && (prod(dx[-MARGIN]) > 1L)) {
    asplit(x, MARGIN, TRUE)
  } else {
    x
  }
}
