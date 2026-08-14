#' @title Process the `...` arguments of a function.
#' @description
#' `dotsNames` returns the names of the `...` arguments, or a character
#' vector of empty strings if they are unnamed (without evaluating
#' `...`).
#'
#' `subDots` returns the `...` arguments as a list of expressions.
#'
#' `dp1Dots` returns the `...` arguments as a character vector of deparsed
#' expressions.
#'
#' `checkDots` errors or warns about extraneous arguments in the `...`
#' of its caller.
#' @param ... "the dots", as passed from the caller.
#' @param collapse a string, passed to [paste].
#' @param width.cutoff integer in `[20, 500]` determining the cutoff
#' (in bytes) at which line-breaking is tried.
#' @param error a logical value indicating whether to throw an error (`TRUE`)
#' or a warning (`FALSE`) for extraneous arguments.
#' @param which.call passed to [sys.call]. A caller may use `-2` if the
#' message should mention its caller.
#' @param allowed character vector of named elements in `...` which are
#' "allowed" and hence do not cause an error or warning.
#' @return
#' For `dotsNames`, a character vector of the names of the `...` arguments.
#'
#' For `subDots`, a list of expressions.
#'
#' For `dp1Dots`, a character vector of deparsed expressions.
#'
#' For `checkDots`, `NULL` (invisibly), called for its side effects.
#' @details
#' `dotsNames` is an implementation of [allNames] for `...` arguments.
#'
#' `subDots` is a simple wrapper for `as.list(substitute(...()))`.
#'
#' `dp1Dots` applies [deparse1] to each element of `subDots(...)`.
#'
#' `checkDots` is a variation of [chkDots] for use in functions that want
#' to error in case of extraneous arguments, not just warn. `checkDots`
#' also shows whether extraneous arguments are named or unnamed, and if
#' unnamed, the message will show the deparsed expressions of the unnamed
#' arguments. See examples.
#' @seealso [...], [chkDots], [stop], [warning], [substitute], [deparse1].
#' @examples
#' f <- function(...) dotsNames(...)
#' f(1, 2, mean(1:10))
#' f(a = 1, b = 2, mean(1:10))
#'
#' f <- function(...) subDots(...)
#' f(a = 1, b = 2, mean(1:10))
#'
#' f <- function(...) dp1Dots(...)
#' f(a = 1, b = 2, mean(1:10))
#'
#' f <- function(x, ...) checkDots(..., allowed = "b")
#' f(1, b = 1)
#' try(f(1, a = 1, b = 2, mean(1:10)))
#' @name suppr-dots
NULL

#' @rdname suppr-dots
#' @export
dotsNames <- function(...) {
  nms <- ...names()
  if (is.null(nms)) {
    character(...length())
  } else {
    nms
  }
}

#' @rdname suppr-dots
#' @export
subDots <- function(...) {
  as.list(substitute(...()))
}

#' @rdname suppr-dots
#' @export
dp1Dots <- function(..., collapse = " ", width.cutoff = 500L) {
  vapply(
    X = subDots(...),
    FUN = deparse1,
    FUN.VALUE = character(1),
    collapse = collapse,
    width.cutoff = width.cutoff,
    USE.NAMES = TRUE
  )
}

#' @rdname suppr-dots
#' @export
checkDots <- function(
  ...,
  error = TRUE,
  which.call = -1,
  allowed = character(0)
) {
  if (...length() == 0L) {
    return(invisible(NULL))
  }

  stopifnot(is.character(allowed))

  args <- dp1Dots(...)
  dot_names <- dotsNames(...)

  i <- dot_names %notin% allowed
  args <- args[i]

  if (length(args) == 0L) {
    return(invisible(NULL))
  }

  dot_names <- dot_names[i]

  i_named <- nzchar(dot_names)
  named_args <- dot_names[i_named]
  unnamed_args <- args[!i_named]

  call <- paste(
    deparse(sys.call(which.call), control = c()),
    collapse = "\n"
  )

  parts <- character()

  if (le <- length(named_args)) {
    parts <- c(
      parts,
      sprintf(
        ngettext(
          le,
          "extra named argument %s is not allowed",
          "extra named arguments %s are not allowed"
        ),
        paste(sQuote(named_args), collapse = ", ")
      )
    )
  }

  if (le <- length(unnamed_args)) {
    parts <- c(
      parts,
      sprintf(
        ngettext(
          le,
          "extra unnamed argument %s is not allowed",
          "extra unnamed arguments %s are not allowed"
        ),
        paste(sQuote(unnamed_args), collapse = ", ")
      )
    )
  }

  msg <- sprintf(
    "In %s :\n %s.",
    call,
    paste(parts, collapse = ".\n ")
  )

  if (isTRUE(error)) {
    stop(
      errorCondition(
        msg,
        class = c("chkDotsError", "simpleError")
      )
    )
  } else {
    warning(
      warningCondition(
        msg,
        class = c("chkDotsWarning", "simpleWarning")
      )
    )
  }

  invisible(NULL)
}
