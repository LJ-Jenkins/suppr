#' @title Are any non-finite values present?
#' @description
#' Tests if a vector contains any non-finite values
#' (`Inf`, `-Inf`, `NaN`, or `NA`).
#' @details
#' `anyNF()` only does one pass of the input and
#' returns `FALSE` immediately when encountering
#' a non-finite value, and thus can be much faster
#' than `!all(is.finite(x))`.
#' @param x a logical, numeric, or complex vector.
#' @return
#' a single `TRUE` or `FALSE`.
#' @note
#' `anyNF()` will throw an error if the input is not a numeric vector.
#' For character vectors use [anyNA].
#' @seealso [is.finite], [is.whole]
#' @export
#' @examples
#' anyNF(1:10)
#' anyNF(c(1, 2, NA, 4))
#' anyNF(c(1, 2, NaN, 4))
#' anyNF(c(1, 2, Inf, 4))
#' anyNF(c(1, 2, -Inf, 4))
#'
#' try(anyNF("1"))
#' @export
anyNF <- function(x) {
  .Call(C_anyNF, x)
}

#' @title Set given indices as NA
#' @description For given `indices`, set those indices of an object as `NA`.
#' @param x an **R** object.
#' @param indices integer vector of indices to set as `NA`.
#' @param value integer vector of indices to set as `NA` for the replacement
#' function.
#' @return the modified object with given indices set to `NA`.
#' @details
#' This function is a S3 generic. The default method sets indices
#' to `NA` using `[<-`, passing the indices first to [`arrayInd`]
#' if the input has a non-`NULL` `dim` attribute.
#'
#' The `setNA<-` function is meant to be a direct replacement for `is.na<-`
#' with (in my opinion) a clearer naming convention. The base methods are
#' implemented verbatim (for [factor] and [numeric_version] objects),
#' whereas the default method differs by using `arrayInd` (see above),
#' whereas `is.na<-` is implemented just as `x[value] <- NA`.
#' @seealso [`is.na<-`], [whichNA]
#' @examples
#' setNA(1:5, c(1, 4))
#' setNA(c("hi", "hello", "bye", "goodbye"), c(1, 4))
#' setNA(matrix(1:4, 2, 2), c(1, 4))
#' setNA(list(1, 2, 3, list(1, 2)), c(1, 4))
#'
#' x <- 1:10
#' setNA(x) <- c(1, 7, 9)
#' x
#' @export
setNA <- function(x, indices) {
  UseMethod("setNA")
}

#' @export
setNA.default <- function(x, indices) {
  if (!is.null(dm <- dim(x))) {
    x[arrayInd(indices, dm)] <- NA
  } else {
    x[indices] <- NA
  }

  x
}

#' @rdname setNA
#' @export
`setNA<-` <- function(x, value) {
  UseMethod("setNA<-")
}

#' @export
`setNA<-.default` <- function(x, value) {
  if (!is.null(dm <- dim(x))) {
    x[arrayInd(value, dm)] <- NA
  } else {
    x[value] <- NA
  }

  x
}

#' @export
`setNA<-.factor` <- function(x, value) {
  lx <- levels(x)
  cx <- oldClass(x)
  class(x) <- NULL
  x[value] <- NA
  structure(x, levels = lx, class = cx)
}

#' @export
`setNA<-.numeric_version` <- function(x, value) {
  x[value] <- list(integer())
  x
}

#' @title Create a vector of NA's
#' @description For a given atomic mode and length, create a vector of NA's.
#' @param length integer, length of the output vector.
#' @param type character string naming an atomic type that has an
#' equivalent NA value (i.e., not [raw]).
#' @details This function also offers a `"list"` type, which gives a list
#' of single (logical) `NA` values. To initialize an empty list of a given
#' length, use [empty.list] instead.
#' @return vector of given mode and length filled with NA values.
#' @seealso [vector], [whichNA], [setNA]
#' @examples
#' na.vector(5L)
#' x <- na.vector(3L, "character")
#' class(x)
#'
#' x <- complex(1:5, 6:10)
#' y <- na.vector(type = typeof(x), length = length(x))
#' class(y)
#' length(y)
#' @export
na.vector <- function(
  length = 1L,
  type = c(
    "logical", "integer", "double",
    "character", "complex", "numeric",
    "list"
  )
) {
  type <- match.arg(
    type,
    c(
      "logical", "integer", "double",
      "character", "complex", "numeric",
      "list"
    )
  )

  if (type != "list") {
    x <- switch(type,
      logical = NA,
      integer = NA_integer_,
      double = NA_real_,
      character = NA_character_,
      complex = NA_complex_,
      numeric = NA_real_
    )

    rep.int(x, length)
  } else {
    as.list(rep.int(NA, length))
  }
}

#' @title Refill the NAs for a 'na.action' Object
#' @description
#' For a [na.action] object, use the indices of where `NA`s were removed
#' to refill the object back to its original size with `NA`s in the
#' appropriate positions.
#' @param object a [na.action] object (atomic vector, matrix or data.frame).
#' @param ... further arguments special methods could require.
#' @details For objects where [na.omit] removes whole rows (e.g., matrices,
#' data.frames), the information about that row is lost, so `na.refill`
#' will refill those **entire rows** with `NA`s.
#' @return vector, matrix or data.frame with the indices from `na.action`
#' refilled with `NA`s. [rownames] and [colnames] are preserved.
#'
#' If the object given is not of those types, or not a `na.action` object,
#' it is returned unchanged.
#' @seealso [na.action], [na.omit]
#' @examples
#' x <- c(1, 2, NA, 4, NA, 6)
#' na_x <- na.omit(x)
#' na_x
#' na.refill(na_x)
#'
#' m <- matrix(1:9, 3, 3)
#' m[c(1, 3), 1:2] <- NA
#' dimnames(m) <- list(c("r1", "r2", "r3"), c("a", "b", "c"))
#' na_m <- na.omit(m)
#' na_m
#' na.refill(na_m) # previous data in NA row is lost
#'
#' df <- data.frame(x = 1:5, y = c("a", NA, "c", "d", NA))
#' na_df <- na.omit(df)
#' na_df
#' na.refill(na_df)
#' @export
na.refill <- function(object, ...) {
  UseMethod("na.refill")
}

#' @export
na.refill.default <- function(object, ...) {
  chkDots(...)
  # only handle atomic vectors with na.action class
  if (!is.atomic(object)) {
    return(object)
  }
  na_locs <- stats::na.action(object) %||% return(object)
  le <- length(object) + length(na_locs)
  out <- rep(NA, le)
  out[-na_locs] <- object

  curr_nms <- names(object)
  # only redo names if they still exist
  if (!is.null(curr_nms)) {
    na_names <- names(na_locs)
    nms <- character(le)
    nms[na_locs] <- na_names
    nms[-na_locs] <- curr_nms
    names(out) <- nms
  }

  attr(out, "na.action") <- attr(object, "na.action")
  class(attr(out, "na.action")) <- "refilled"
  out
}

#' @export
na.refill.matrix <- function(object, ...) {
  chkDots(...)
  na_locs <- stats::na.action(object) %||% return(object)
  n <- nrow(object) + length(na_locs)

  out <- matrix(
    na.vector(1L, typeof(object)),
    nrow = n,
    ncol = ncol(object)
  )
  out[-na_locs, ] <- object

  dmn <- dimnames(object)
  # only redo names if they still exist
  if (!is.null(dmn)) {
    # only need to do row names as only these could have been dropped by na.omit
    if (!is.null(dmn[[1]])) {
      rn <- character(n)
      rn[na_locs] <- names(na_locs)
      rn[-na_locs] <- rownames(object)
      dimnames(out) <- list(rn, colnames(object))
    }
  }

  attr(out, "na.action") <- attr(object, "na.action")
  class(attr(out, "na.action")) <- "refilled"
  out
}

#' @export
na.refill.data.frame <- function(object, ...) {
  chkDots(...)
  na_locs <- stats::na.action(object) %||% return(object)

  curr_rn <- attr(object, "row.names")
  # row.names should always exist
  if (is.null(curr_rn)) {
    stop("data.frame should have row.names attribute")
  }

  nr <- nrow(object)
  n <- nr + length(na_locs)

  # this [ indexing keeps attr so we don't need to add,
  # just rename the na.action class
  out <- object[NA, , drop = FALSE]
  out[n, ] <- NA
  out[-na_locs, ] <- object

  na_names <- names(na_locs)
  rn <- if (i <- is.character(curr_rn)) character(n) else integer(n)
  rn[na_locs] <- if (i) na_names else as.integer(na_names)
  # attr for integer rownames
  rn[-na_locs] <- curr_rn
  row.names(out) <- rn

  class(attr(out, "na.action")) <- "refilled"
  out
}
