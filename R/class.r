#' @title Add a Class to an Object
#' @description
#' Add a class to an object, either appending to, or replacing, the
#' existing class vector.
#' @param x an **R** object.
#' @param class character vector, or object coercible to character,
#' of one or more class names to add.
#' @param prepend logical. If `TRUE` the new class(es) are
#' prepended to the existing class vector. If `FALSE`, the class
#' vector is replaced entirely.
#' @return The input object `x` with its class attribute updated.
#' @details
#' With `prepend = TRUE`, `addClass()` is equivalent to:
#' ```{r, eval=FALSE}
#' class(x) <- c(class, class(x))
#' x
#' ```
#' With `prepend = FALSE`:
#' ```{r, eval=FALSE}
#' class(x) <- class
#' x
#' ```
#' @seealso [class], [inherits], [is].
#' @examples
#' x <- structure(1, class = "base_class")
#' y <- addClass(x, c("new_class", "another_class"))
#' class(y)
#'
#' y <- addClass(x, c("new_class", "another_class"), prepend = FALSE)
#' class(y)
#' @export
addClass <- function(x, class, prepend = TRUE) {
  if (isTRUE(prepend)) {
    class(x) <- c(class, class(x))
  } else {
    class(x) <- class
  }

  x
}

#' @title Check if Any of Given Vector Types
#' @description
#' Wrapper around [is.vector] that allows the `mode` argument to
#' accept a character vector of multiple specific types. `TRUE`
#' is returned if the given object is **any** of the given types.
#' @param x an **R** object.
#' @param mode character string (or chr vector) naming an atomic mode
#' or `"list"` or `"expression"` or `"any"`. When using `"any"`, it
#' must be given on its own.
#' @return `TRUE` or `FALSE`.
#' @details
#' See [is.vector] for full details and for the types that can be
#' checked with `mode`.
#' @seealso [is.vector], [typeof].
#' @examples
#' x <- c(a = 1, b = 2)
#' isVector(x) # default `mode` is "any"
#'
#' # "any" can't be given with other types.
#' try(isVector(x, mode = c("numeric", "any")))
#'
#' # `TRUE` is returned if *any* of the types are matched.
#' isVector(x, mode = c("character", "list", "logical", "numeric"))
#' isVector(x, mode = c("character", "list", "logical"))
#' @export
isVector <- function(x, mode = "any") {
  if (length(mode) > 1L && "any" %in% mode) {
    stop(
      "In argument ", sQuote("mode"),
      ": 'any' cannot be given with other types."
    )
  }

  for (i in seq_along(mode)) {
    if (is.vector(x, mode = mode[i])) {
      return(TRUE)
    }
  }

  FALSE
}

#' @title Is object of a Date type?
#' @description
#' Tests if an object inherits from some/all of **R**'s date types:
#' `Date`, `POSIXt`, `POSIXct` and `POSIXlt`.
#' @param x an **R** object.
#' @return `TRUE` or `FALSE`.
#' @details
#' `is.datetype` checks if the object inherits from either `Date` or `POSIXt`.
#'
#' `is.Date` checks if the object inherits from `Date`.
#'
#' `is.POSIXt` checks if the object inherits from `POSIXt`.
#'
#' `is.POSIXct` checks if the object inherits from `POSIXct`.
#'
#' `is.POSIXlt` checks if the object inherits from `POSIXlt`.
#' @seealso [as.Date], [as.POSIXct], [as.POSIXlt].
#' @examples
#' a <- "2020-01-01"
#' b <- as.Date("2020-01-01")
#' c <- 123
#'
#' is.Date(a)
#' is.Date(b)
#' is.Date(c)
#'
#' is.Date(as.POSIXct(123))
#' is.Date(as.POSIXlt(123))
#'
#' is.datetype(as.POSIXct(123))
#' is.datetype(as.POSIXlt(123))
#' @export
is.datetype <- function(x) {
  inherits(x, c("Date", "POSIXt"))
}

#' @rdname is.datetype
#' @export
is.Date <- function(x) {
  inherits(x, "Date")
}

#' @rdname is.datetype
#' @export
is.POSIXt <- function(x) {
  inherits(x, "POSIXt")
}

#' @rdname is.datetype
#' @export
is.POSIXct <- function(x) {
  inherits(x, "POSIXct")
}

#' @rdname is.datetype
#' @export
is.POSIXlt <- function(x) {
  inherits(x, "POSIXlt")
}

#' @title Value Predicates for Common Object Types
#' @description
#' `is.boolean` checks if an object is a single logical value
#' (`TRUE` or `FALSE`).
#'
#' `is.string` checks if an object is a single (non-NA) character string.
#'
#' `nzstring` checks if an object is a single (non-NA) non-empty character
#' string.
#' @param x an object to be tested.
#' @return
#' `TRUE` or `FALSE`.
#' @details
#' The `string` helpers differ slightly from what you *may* expect
#' from base **R** as `NA_character_` is not considered a string.
#' For example:
#' ```{r, eval=TRUE}
#' nzchar(NA_character_)
#' is.string(NA_character_)
#' nzstring(NA_character_)
#' ```
#' @name suppr-predicates
#' @examples
#' is.boolean(TRUE)
#' is.boolean(NA)
#'
#' is.string("hello")
#' is.string(NA_character_)
#' is.string("")
#'
#' nzstring("")
NULL

#' @rdname suppr-predicates
#' @export
is.boolean <- function(x) is.logical(x) && length(x) == 1L && !is.na(x)

#' @rdname suppr-predicates
#' @export
is.string <- function(x) is.character(x) && length(x) == 1L && !is.na(x)

#' @rdname suppr-predicates
#' @export
nzstring <- function(x) {
  is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
}
