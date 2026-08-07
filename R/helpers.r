#' @title Miscellaneous Helper Functions
#' @description
#' `dims()` returns the dimensions of an object (from [dim]), but for
#' objects without dimensions (aka [dim] returns `NULL`) the length
#' of the object is returned along with `0L`.
#'
#' `enumerate` maps a list to each element of a vector, containing the
#' index, value, and name of each element.
#' @param x
#' For `dims()`, an **R** object.
#'
#' For `enumerate()`, a vector or list to be enumerated.
#' @return
#' For `dims()`, an integer of length 2 or greater that specifies
#' the dimensions of an object.
#'
#' For `enumerate()`, a list of lists, where each inner list has
#' three elements: `idx`, `val`, and `name`, which are the index,
#' value, and name of the corresponding element.
#' @details
#' Unnamed elements given to `enumerate()` will have an empty string
#' (`""`) as their name.
#' @name supprHelpers
#' @examples
#' # objects with dimensions give same output as dim():
#' dims(matrix(1:6, nrow = 2))
#'
#' # those without give length and 0:
#' dims(1:5)
#' dims(list(a = 1, b = 2, c = 3))
#'
#' for (x in enumerate(c(a = 1, b = 2, 3))) print(x)
NULL

#' @rdname supprHelpers
#' @export
dims <- function(x) {
  if (is.null(dm <- dim(x))) {
    c(length(x), 0L)
  } else {
    dm
  }
}

#' @rdname supprHelpers
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
