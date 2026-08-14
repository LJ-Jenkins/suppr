#' @title Ensure the Truth of R Expressions with Call Information
#' @description
#' Wrapper around [stopifnot] that leaves only the `...` argument and
#' adds a `call.` argument that shows a call in the error message that
#' is derived from the call stack. `warningifnot()` implements the same
#' functionality but produces a warning instead of an error.
#' @param ... any number of **R** expressions, which should each evaluate
#' to (a logical vector of [all]) [TRUE]. If named, the names will be used
#' in lieu of the default error message.
#' @inheritParams stop2 call.
#' @param warn.all logical, indicating if all failed expressions should produce
#' warnings, or only the first failed expression. Default is `FALSE`,
#' which means only the first failed expression will produce a warning.
#' @return Called for side effects only.
#' @details
#' If any of the expressions are not [all] `TRUE`, [stop] or [warning]
#' is called, producing an error/warning message indicating the first
#' (or all, if `warn.all = TRUE` for `warningifnot()`) expression
#' which was not ([all]) true. See [stopifnot] for full details.
#'
#' Special care must be taken for handlers on the call stack, as they
#' may affect the call displayed in the error or warning message. In
#' such instances, passing an environment to `call.` may be helpful.
#' @seealso [stopifnot.with] for a data-masked version of this function.
#' @examples
#' f1 <- function(call.) stopifnot2(1 == 2, call. = call.)
#' f2 <- function(call.) f1(call. = call.)
#' f <- function(call.) f2(call. = call.)
#'
#' try(f(call. = FALSE))
#' try(f(call. = TRUE))
#'
#' try(f(call. = 0))
#' try(f(call. = 1))
#' try(f(call. = 2))
#'
#' f <- function() {
#'   e <- environment()
#'   f1(call. = e)
#' }
#'
#' try(f())
#'
#' try(stopifnot2(all.equal(1, 2)))
#'
#' warningifnot(1 == 2, 2 == 3)
#' warningifnot(1 == 2, 2 == 3, warn.all = TRUE)
#' @export
stopifnot2 <- function(..., call. = TRUE) {
  n <- ...length()
  for (i in seq_len(n)) {
    r <- ...elt(i)

    if (!(is.logical(r) && !anyNA(r) && all(r))) {
      dots <- match.call()[-1L]

      if (is.null(msg <- names(dots)) || !nzchar(msg <- msg[i])) {
        cl.i <- dots[[i]]

        msg <- if (
          is.call(cl.i) && identical(cl.i[[1]], quote(all.equal)) &&
            (
              is.null(ni <- names(cl.i)) || length(cl.i) == 3L ||
                length(cl.i <- cl.i[!nzchar(ni)]) == 3L
            )
        ) {
          sprintf(
            gettext("%s and %s are not equal:\n  %s"),
            Dparse(cl.i[[2]]),
            Dparse(cl.i[[3]]),
            abbrev(r)
          )
        } else {
          le <- length(r)
          if (le == 0L) le <- 1L

          sprintf(
            ngettext(
              le,
              "%s is not TRUE",
              "%s are not all TRUE"
            ),
            Dparse(cl.i)
          )
        }
      }

      call. <- get_call.(call.)
      stop(simpleError(msg, call = call.))
    }
  }

  invisible()
}

#' @rdname stopifnot2
#' @export
warningifnot <- function(..., warn.all = FALSE, call. = TRUE) {
  n <- ...length()
  # anything other than exactly TRUE breaks at first fail
  warn.first.only <- !isTRUE(warn.all)

  for (i in seq_len(n)) {
    r <- ...elt(i)

    if (!(is.logical(r) && !anyNA(r) && all(r))) {
      dots <- match.call()[-1L]

      if (is.null(msg <- names(dots)) || !nzchar(msg <- msg[i])) {
        cl.i <- dots[[i]]

        msg <- if (
          is.call(cl.i) && identical(cl.i[[1]], quote(all.equal)) &&
            (
              is.null(ni <- names(cl.i)) || length(cl.i) == 3L ||
                length(cl.i <- cl.i[!nzchar(ni)]) == 3L
            )
        ) {
          sprintf(
            gettext("%s and %s are not equal:\n  %s"),
            Dparse(cl.i[[2]]),
            Dparse(cl.i[[3]]),
            abbrev(r)
          )
        } else {
          le <- length(r)
          if (le == 0L) le <- 1L

          sprintf(
            ngettext(
              le,
              "%s is not TRUE",
              "%s are not all TRUE"
            ),
            Dparse(cl.i)
          )
        }
      }

      if (i == 1L) {
        call. <- get_call.(call.)
      }

      warning(simpleWarning(.makeMessage(msg), call = call.))

      if (warn.first.only) {
        break
      }
    }
  }

  invisible()
}

#' @title Ensure the Truth of R Expressions in a Data Environment
#' @description
#' Wrapper around [stopifnot2] that evaluates **R** expressions
#' in an environment constructed from `data`.
#' @param data data to use for constructing an environment. This may be an
#' `environment`, a `list`, a `data.frame`, or an `integer` as in
#' `sys.call`.
#' @param ... any number of **R** expressions, which should each evaluate
#' to (a logical vector of all) [TRUE]. If named, the names will be used
#' in lieu of the default error message.
#' @inheritParams stop2 call.
#' @details
#' If any of the expressions are not [all] `TRUE`, [stop] is called,
#' producing an error message indicating the first expression which
#' was not ([all]) true. See [stopifnot] and [stopifnot2] for full details.
#'
#' Special care must be taken for handlers on the call stack, as they
#' may affect the call displayed in the error or warning message. In
#' such instances, passing an environment to `call.` may be helpful.
#' @seealso [stop2], [warning2] and [message2] for errors, warnings and
#' messages with call information.
#' @examples
#' try(stopifnot.with(data.frame(x = 1, y = 2), x == y))
#' try(stopifnot.with(list(x = 1, y = 2), all.equal(x, y)))
#'
#' f1 <- function(x, ..., call.) stopifnot.with(x, ..., call. = call.)
#' f2 <- function(x, ..., call.) f1(x, ..., call. = call.)
#' f <- function(x, ..., call.) f2(x, ..., call. = call.)
#'
#' x <- list(a = 1, b = 2)
#' try(f(x, a == b, call. = FALSE))
#' try(f(x, a == b, call. = TRUE))
#'
#' try(f(x, a == 1, b < 1, call. = 0))
#' try(f(x, b > 3, call. = 1))
#' try(f(x, a != 1, call. = 2))
#'
#' f <- function(x, ...) {
#'   e <- environment()
#'   f1(x, ..., call. = e)
#' }
#'
#' try(f(x, a == 1, b < 1))
#' @export
stopifnot.with <- function(data, ..., call. = TRUE) {
  darg <- substitute(data)
  args <- subDots(...)
  n <- length(args)

  for (i in seq_len(n)) {
    # with() but we've already sub'd args
    r <- eval(args[[i]], envir = data, enclos = parent.frame())

    if (!(is.logical(r) && !anyNA(r) && all(r))) {
      if (is.null(msg <- names(args)) || !nzchar(msg <- msg[i])) {
        cl.i <- args[[i]]

        msg <- if (
          is.call(cl.i) && identical(cl.i[[1]], quote(all.equal)) &&
            (
              is.null(ni <- names(cl.i)) || length(cl.i) == 3L ||
                length(cl.i <- cl.i[!nzchar(ni)]) == 3L
            )
        ) {
          sprintf(
            gettext("with %s : %s and %s are not equal:\n  %s"),
            Dparse(darg),
            Dparse(cl.i[[2]]),
            Dparse(cl.i[[3]]),
            abbrev(r)
          )
        } else {
          le <- length(r)
          if (le == 0L) le <- 1L

          sprintf(
            ngettext(
              le,
              "with %s : %s is not TRUE",
              "with %s : %s are not all TRUE"
            ),
            Dparse(darg),
            Dparse(cl.i)
          )
        }
      }

      call. <- get_call.(call.)
      stop(simpleError(msg, call = call.))
    }
  }

  invisible()
}

Dparse <- function(call, cutoff = 60L) {
  ch <- deparse(call, width.cutoff = cutoff)
  if (length(ch) > 1L) paste(ch[1L], "....") else ch
}

head <- function(x, n = 6L) {
  x[seq_len(if (n < 0L) max(length(x) + n, 0L) else min(n, length(x)))]
}

abbrev <- function(ae, n = 3L) {
  paste(c(head(ae, n), if (length(ae) > n) "...."), collapse = "\n  ")
}
