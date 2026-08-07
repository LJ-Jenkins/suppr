#' @title Loading/Attaching Multiple Packages
#' @description Wraps [library()] and [require()] to
#' load multiple packages.
#' @param ...
#' the names of the packages, given as [name]s, character strings,
#' a combination of both, or character vectors (see `character.only`
#' below).
#' @param pos
#' the position on the search list at which to attach the loaded
#' namespace. Can also be the name of a position on the current
#' search list as given by [`search()`].
#' @param lib.loc
#' a character vector describing the location of R library trees to
#' search through, or `NULL`. The default value of `NULL` corresponds
#' to all libraries currently known to [`.libPaths()`]. Non-existent
#' library trees are silently ignored.
#' @param character.only
#' a logical indicating whether package or help can be assumed to be
#' character strings. If `TRUE`, dot arguments are coerced to be
#' character before being unlisted into a single character vector.
#' @param logical.return
#' logical. If it is `TRUE`, `FALSE` or `TRUE` is returned to indicate
#' success.
#' @param warn.conflicts
#' logical. If `TRUE`, warnings are printed about [conflicts] from
#' attaching the new package. A conflict is a function masking a
#' function, or a non-function masking a non-function. The default
#' is `TRUE` unless specified as `FALSE` in the `conflicts.policy` option.
#' @param quietly
#' a logical. If `TRUE`, no message confirming package attaching
#' is printed, and most often, no errors/warnings are printed
#' if package attaching fails.
#' @param verbose
#' a logical. If `TRUE`, additional diagnostics are printed.
#' @param mask.ok
#' character vector of names of objects that can mask objects on the
#' search path without signaling an error when strict conflict checking
#' is enabled.
#' @param exclude,include.only
#' character vector of names of objects to exclude or include in the
#' attached frame. Only one of these arguments may be used in a
#' call to `libraries` or `requires`.
#' @param attach.required
#' logical specifying whether required packages listed in the
#' `Depends` clause of the `DESCRIPTION` file should be attached
#' automatically.
#' @details All non-dot arguments are passed in their entirety to
#' each `library` or `require` call, so the same arguments are
#' used for each package.
#'
#' For the `help` of a package, call `library(help = <package>)`
#' directly.
#'
#' For full details see [library].
#' @return
#' `libraries()` and `requires()` return the value of the last
#' dot argument evaluated, invisibly:
#'
#' Normally `library` returns (invisibly) the list of attached
#' packages, but `TRUE` or `FALSE` if `logical.return` is `TRUE`.
#' When called as `library()` it returns an object of class
#' `"libraryIQR"`, and for `library(help=)`, one of class
#' `"packageInfo"`.
#'
#' `require` returns (invisibly) a logical indicating whether the required package is available.
#' @seealso [attach], [detach], [install.packages]
#' @examples
#' libraries("stats", "graphics", methods)
#' requires("stats", graphics, "methods")
#'
#' x <- c("stats", "graphics")
#' libraries(x, "methods", character.only = TRUE)
#' try(requires(methods, x, character.only = TRUE))
#' @export
libraries <- function(
  ...,
  pos = 2,
  lib.loc = NULL,
  character.only = FALSE,
  logical.return = FALSE,
  warn.conflicts,
  quietly = FALSE,
  verbose = getOption("verbose"),
  mask.ok,
  exclude,
  include.only,
  attach.required = missing(include.only)
) {
  if (isTRUE(character.only)) {
    pkgs <- unlist(lapply(list(...), as.character))
  } else {
    pkgs <- as.character(subDots(...))
  }

  if (length(pkgs) == 0L) {
    return(
      library(
        pos = pos,
        lib.loc = lib.loc,
        character.only = character.only,
        logical.return = logical.return,
        warn.conflicts = warn.conflicts,
        quietly = quietly,
        verbose = verbose,
        mask.ok = mask.ok,
        exclude = exclude,
        include.only = include.only,
        attach.required = attach.required
      )
    )
  }

  for (pkg in pkgs) {
    x <- library(
      package = pkg,
      pos = pos,
      lib.loc = lib.loc,
      character.only = TRUE,
      logical.return = logical.return,
      warn.conflicts = warn.conflicts,
      quietly = quietly,
      verbose = verbose,
      mask.ok = mask.ok,
      exclude = exclude,
      include.only = include.only,
      attach.required = attach.required
    )
  }

  invisible(x)
}

#' @rdname libraries
#' @export
requires <- function(
  ...,
  lib.loc = NULL,
  quietly = FALSE,
  warn.conflicts,
  character.only = FALSE,
  mask.ok,
  exclude,
  include.only,
  attach.required = missing(include.only)
) {
  if (isTRUE(character.only)) {
    pkgs <- unlist(lapply(list(...), as.character))
  } else {
    pkgs <- as.character(subDots(...))
  }

  if (length(pkgs) == 0L) {
    return(
      require(
        lib.loc = lib.loc,
        quietly = quietly,
        warn.conflicts = warn.conflicts,
        character.only = character.only,
        mask.ok = mask.ok,
        exclude = exclude,
        include.only = include.only,
        attach.required = attach.required
      )
    )
  }

  for (pkg in pkgs) {
    x <- require(
      package = pkg,
      lib.loc = lib.loc,
      quietly = quietly,
      warn.conflicts = warn.conflicts,
      character.only = TRUE,
      mask.ok = mask.ok,
      exclude = exclude,
      include.only = include.only,
      attach.required = attach.required
    )
  }

  invisible(x)
}
