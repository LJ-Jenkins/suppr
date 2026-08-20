#' @title Miscellaneous Helper Functions
#' @description
#' `path()` builds a file path using [file.path], before normalizing
#' the path with [normalizePath].
#'
#' `dims()` returns the dimensions of an object (from [dim]), but for
#' objects without dimensions the length of the object is returned
#' along with `0L` (e.g., `c(length(x), 0L)`).
#'
#' `enumerate` maps a list to each element of a vector, containing the
#' index, value, and name of each element.
#' @param ...
#' character vectors. [Long vectors] are not supported.
#' @param sharedDrive logical, whether the path is on a shared drive.
#' If `TRUE`, then `.Platform$file.sep` is given as the first element
#' of the path, e.g., `"mysd`, `"mydir"` becomes `"\\\\mysd\\mydir"`
#' (on windows).
#' @param mustWork
#' logical: if `TRUE` then an error is given if the result cannot be
#' determined; if `NA` then a warning; if `FALSE` then no error or
#' warning is given.
#' @param x
#' For `dims()`, an **R** object.
#'
#' For `enumerate()`, a vector or list to be enumerated.
#' @return
#' For `path()`, a character string of the expanded, normalized path.
#'
#' For `dims()`, an integer of length 2 or greater that specifies
#' the dimensions of an object.
#'
#' For `enumerate()`, a list of lists, where each inner list has
#' three elements: `idx`, `val`, and `name`, which are the index,
#' value, and name of the corresponding element.
#' @details
#' `path()` will expand paths, see example.
#'
#' Unnamed elements given to `enumerate()` will have an empty string
#' (`""`) as their name.
#' @name suppr-helpers
#' @examples
#' path("path", "expansion", "occurs", mustWork = FALSE)
#' path("mysd", "mydir", sharedDrive = TRUE, mustWork = FALSE)
#'
#' # objects with dimensions give same output as dim():
#' dims(matrix(1:6, nrow = 2))
#'
#' # those without give length and 0:
#' dims(1:5)
#' dims(list(a = 1, b = 2, c = 3))
#'
#' for (x in enumerate(c(a = 1, b = 2, 3))) print(x)
NULL

#' @rdname suppr-helpers
#' @export
path <- function(..., sharedDrive = FALSE, mustWork = NA) {
  if (isTRUE(sharedDrive)) {
    normalizePath(file.path(.Platform$file.sep, ...), mustWork = mustWork)
  } else {
    normalizePath(file.path(...), mustWork = mustWork)
  }
}

#' @rdname suppr-helpers
#' @export
dims <- function(x) {
  if (is.null(dm <- dim(x))) {
    c(length(x), 0L)
  } else {
    dm
  }
}

#' @rdname suppr-helpers
#' @export
enumerate <- function(x) {
  Map(list, idx = seq_along(x), val = x, name = methods::allNames(x))
}

#' @title Create an Empty list of Given Length
#' @description For a given length, create an empty list of that length.
#' @param length integer, specified length of the output list.
#' @return an empty list of given length.
#' @details This is a simple wrapper of `vector("list", length)` with a
#' clearer naming convention.
#' @seealso [vector], [na.vector]
#' @examples
#' empty.list()
#' empty.list(5L)
#' empty.list(length = 3L)
#' @export
empty.list <- function(length = 0L) {
  vector("list", length = length)
}
