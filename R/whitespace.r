#' @title Are any zero char or all whitespace elements present?
#' @description
#' Tests if a character vector contains any zero character
#' or all whitespace elements.
#' @details
#' `anyZchar()` and `anyWS()` return an index immediately when
#' encountering a zero character or a whitespace element,
#' respectively.
#'
#' Whitespace elements are defined as any character that is a
#' space, horizontal tab, carriage return or newline:
#' aka `"[ \t\r\n]"`. See [trimws] for more details and how to
#' instead match all unicode whitespace.
#'
#' `anyZchar()` implements the same definition of a zero char
#' as [`nzchar`].
#'
#' `NA_character_` is not considered zero char or all whitespace.
#' @param x a character vector.
#' @param zchar if `TRUE` then zero character elements
#' will be treated as all whitespace.
#' @return
#' an integer or real vector of length one with value
#' the `1`-based index of the first zero char/all whitespace value
#' if any, otherwise `0`.
#' @note
#' Unlike the similar base functions, these do not coerce
#' the input to character.
#' @seealso [nzchar], [trimws], [anyNF]
#' @examples
#' anyZchar(c("hi", "bye", " ", ""))
#' anyWS(c("hi", "bye", " ", ""))
#' anyWS(c("hi", "bye", "who", ""), zchar = TRUE)
#' @export
anyZchar <- function(x) {
  .Call(C_anyZchar, x)
}

#' @rdname anyZchar
#' @export
anyWS <- function(x, zchar = FALSE) {
  .Call(C_anyWS, x, zchar)
}
