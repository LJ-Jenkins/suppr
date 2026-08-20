#' @title Argument Verification
#' @description
#' `match.argv()` matches a given argument against a
#' list of candidate values as specified by `choices`.
#' @details
#' If `arg` is the same as `choices`, then the first element
#' of `arg` is returned. This check is done using
#' [`identical()`] with `ignore.environment = TRUE`, regardless
#' of the `match.fn` argument.
#'
#' In the one-argument form `match.argv(arg)`, the `choices`
#' are obtained from a default setting for the formal argument
#' `arg` of the function from which `match.argv` was called.
#' @param arg an **R** object.
#' @param choices a list of candidate values to match
#' against that will be extracted with `[[`.
#' @param match.fn a function to use for matching the
#' argument against the choices. This function must
#' take two arguments: the first is the argument to be
#' matched, and the second is a candidate value
#' extracted from `choices` with `[[`. It must return
#' a single `TRUE` or `FALSE` value indicating whether
#' the argument matches the candidate value.
#'
#' If `NULL`, the default matching function is used,
#' which checks for equality using`identical()` with
#' `ignore.environment = TRUE`.
#' @return
#' If `arg` is identical to `choices`, then the first
#' element of `arg` is returned. If `arg` is matched
#' against a candidate value in `choices`, then `arg`
#' is returned. If no match is found, an error is thrown.
#' @seealso [match.arg], [match.call], [match.fun].
#' @examples
#' # default matching function is strict.
#' match.argv(1:10, list(c("a", "b"), list(1, 2), 1:10))
#' try(match.argv(1, list(c("a", "b"), list(1, 2), 1:10)))
#'
#' # NULL can be given as a candidate.
#' match.argv(NULL, list(NULL, 1:10))
#'
#' # default matching function is strict.
#' try(match.argv(NA, list(NA_real_, NA_integer_, NA_character_)))
#'
#' # a custom matching function can be used.
#' match.argv("A", list("a", "b", "c"), match.fn = function(x, y) {
#'   is.character(x) && length(x) == 1L && tolower(x) == tolower(y)
#' })
#' @export
match.argv <- function(arg, choices, match.fn = NULL) {
  defaults <- NULL

  if (missing(choices)) {
    formal.args <- formals(
      sys.function(sys_p <- sys.parent())
    )

    defaults <- formal.args[[as.character(substitute(arg))]]

    choices <- eval(
      defaults,
      envir = sys.frame(sys_p)
    )
  }

  if (is.null(defaults)) {
    defaults <- substitute(choices)
  }

  if (!is.list(choices)) {
    stop(sQuote("choices"), " must be a list.")
  }

  if (is.null(match.fn)) {
    match.fn <- function(x, y) {
      identical(x, y, ignore.environment = TRUE)
    }
  } else {
    if (!is.function(match.fn)) {
      stop(sQuote("match.fn"), " must be a function.")
    }
  }

  # if arg and choices same, return [[1]]
  if (identical(arg, choices, ignore.environment = TRUE)) {
    return(arg[[1]])
  }

  # for loop for early return, ignore subsequent matches
  for (i in seq_along(choices)) {
    if (match.fn(arg, choices[[i]])) {
      return(choices[[i]])
    }
  }

  defaults <- as.list(defaults)[-1]

  err_args <- collapse(
    vapply(
      defaults,
      fmt_err_arg,
      character(1)
    ),
    sep = ", "
  )

  stop(
    sprintf(
      ngettext(
        length(defaults),
        "'arg' should be: %s",
        "'arg' should be one of: %s"
      ),
      err_args
    ),
    domain = NA
  )
}

fmt_err_arg <- function(x) {
  if (is.character(x) && length(x) == 1L) {
    sQuote(x)
  } else {
    deparse1(x)
  }
}
