#' @title Display Messages with Call Information
#' @description
#' Wrappers around [stop], [warning], and [message] that
#' enable the `call.` argument to derive a call from the
#' stack.
#' @param ... zero or more objects which can be coerced to
#' character (and which are pasted together with no separator).
#' @param call. call, logical, integer, or environment. logical, indicating
#' if the calling call should become part of the error message with same
#' semantics as [stop]. integer, specifying how many calls to go 'up'
#' the call stack to extract a call for the error message. A value of
#' `0` will give the call to `stop2()` itself, `1` will give the
#' call of the caller, and so on. Numeric values are coerced to integer
#' and absolute values are taken. Values outside either boundary of the
#' call stack will be clamped to the nearest boundary. environment,
#' which will be matched against the calling stack and the corresponding
#' call will be shown.
#' @param domain see [gettext]. If `NA`, messages will not be translated.
#' @param appendLF logical: should messages given as a character
#' string have a newline appended?
#' @return Called for side effects only.
#' @details These functions derive a call to be displayed and then construct
#' their own 'simple' conditions using [simpleError], [simpleWarning],
#' and [simpleMessage].
#'
#' If a condition object is given as the first argument, it will be
#' treated in the same way as the base functions do, by warning that
#' other arguments will be ignored and then signalling the condition.
#'
#' See [stop], [warning] and [message] for full details.
#' @seealso [stopifnot2] and [stopifnot.with] for validations with
#' call information.
#' @examples
#' f1 <- function(call.) stop2("error", call. = call.)
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
#' @export
stop2 <- function(..., call. = TRUE, domain = NULL) {
  if (...length() == 1L && inherits(..1, "condition")) {
    cond <- ..1
    if (nargs() > 1L) {
      cat(
        gettext("condition object passed: all additional arguments ignored in stop2()"),
        "\n",
        sep = "",
        file = stderr()
      )
    }
    stop(cond)
  }

  msg <- .makeMessage(..., domain = domain)
  call. <- get_call.(call.)
  stop(simpleError(msg, call = call.))
}

#' @rdname stop2
#' @export
warning2 <- function(..., call. = TRUE, domain = NULL) {
  if (...length() == 1L && inherits(..1, "condition")) {
    cond <- ..1
    if (nargs() > 1L) {
      cat(
        gettext("condition object passed: all additional arguments ignored in warning2()"),
        "\n",
        sep = "",
        file = stderr()
      )
    }
    warning(cond)
  }

  msg <- .makeMessage(..., domain = domain)
  call. <- get_call.(call.)
  warning(simpleWarning(msg, call = call.))
}

#' @rdname stop2
#' @export
message2 <- function(..., call. = TRUE, domain = NULL, appendLF = TRUE) {
  if (...length() == 1L && inherits(..1, "condition")) {
    cond <- ..1
    if (nargs() > 1L) {
      cat(
        gettext("condition object passed: all additional arguments ignored in message2()"),
        "\n",
        sep = "",
        file = stderr()
      )
    }
    message(cond)
  }

  msg <- .makeMessage(..., domain = domain, appendLF = appendLF)
  call. <- get_call.(call.)
  message(simpleMessage(msg, call = call.))
}

get_call. <- function(call.) {
  if (is.logical(call.)) {
    if (length(call.) != 1L || is.na(call.)) {
      stop("Logical `call.` inputs must be TRUE or FALSE")
    }

    call. <- if (call.) {
      if (p <- sys.parent(2L)) sys.call(p)
    } else {
      NULL
    }
  } else if (is.numeric(call.)) {
    if (length(call.) != 1L || is.na(call.)) {
      stop("Numeric `call.` inputs must be scalar non-NA")
    }

    call. <- abs(as.integer(call.))
    calls <- sys.calls()
    calls <- calls[-length(calls)]
    i <- length(calls) - call.
    if (i < 1L) i <- 1L else if (i > length(calls)) i <- length(calls)
    call. <- calls[[i]]
  } else if (is.environment(call.)) {
    call. <- get_call_from_frame(sys.calls(), sys.frames(), call.)
  } else if (!is.call(call.)) {
    stop("`call.` must be either a call, an integer, an environment, or TRUE/FALSE")
  }

  call.
}

get_call_from_frame <- function(all_calls, all_envs, given_env) {
  for (k in seq_along(all_envs)) {
    if (identical(all_envs[[k]], given_env)) {
      return(all_calls[[k]])
    }
  }
}
