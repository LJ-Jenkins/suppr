#' @title Backquote Text
#' @description
#' Backquote text by combining with backticks.
#' @param x an **R** object, to be coerced to a [character] vector.
#' @return
#' A character vector of the same length as `x` (after any coercion).
#' @seealso [Quotes], [dQuote] and [sQuote].
#' @examples
#' bckQuote("example")
#' bckQuote(c("one", "two", "three"))
#' bckQuote(123)
#' @export
bckQuote <- function(x) {
  if (!length(x)) {
    return(character(0))
  }

  paste0("`", x, "`")
}

#' @title Concatenate and Print with No Separator
#' @description
#' Outputs the objects, concatenating the representations
#' with no separator.
#' @param ... **R** objects (see [cat] for the types of objects allowed).
#' @param file a connection, or a character string naming the file to
#' print to. If "" (the default), `cat0` prints to the standard output
#' connection, the console unless redirected by sink.
#' @param fill a logical or (positive) numeric controlling how the
#' output is broken into successive lines. If `FALSE` (default), only
#' newlines created explicitly by `"\n"` are printed. Otherwise, the
#' output is broken into lines with print width equal to the option
#' width if fill is `TRUE`, or the value of fill if this is numeric.
#' Linefeeds are only inserted between elements, strings wider than
#' fill are not wrapped. Non-positive fill values are ignored, with a
#' warning.
#' @param labels character vector of labels for the lines printed.
#' Ignored if fill is `FALSE`.
#' @param append logical. Only used if the argument file is the name
#' of file (and not a connection or `"|cmd"`). If `TRUE` output will be
#' appended to file; otherwise, it will overwrite the contents of file.
#' @return
#' None (invisible `NULL`).
#' @details
#' All arguments are passed to a call to [cat] with `sep` set to `""`.
#' @seealso [cat], [print], [format] and [paste] which concatenates into
#' a string.
#' @examples
#' cat(letters[1:3])
#' cat0(letters[1:3])
#'
#' cat(
#'   paste(letters, 100 * 1:26),
#'   fill = TRUE, labels = paste0("{", 1:10, "}:")
#' )
#' cat0(
#'   paste(letters, 100 * 1:26),
#'   fill = TRUE, labels = paste0("{", 1:10, "}:")
#' )
#' @export
cat0 <- function(
  ..., file = "", fill = FALSE, labels = NULL,
  append = FALSE
) {
  cat(...,
    file = file, sep = "", fill = fill, labels = labels,
    append = append
  )
}

#' @title Collapse a Vector of Strings into a Single String
#' @description
#' Collapse a character vector into a single string, with an optional
#' separator, and for `listing()` an optional conjunction and period,
#' with options to quote the terms.
#' @param ... one or more **R** objects, to be converted to [character] vectors.
#' @param x a character vector from which to create the human readable list.
#' @param sep character string to collapse the terms, not [`NA_character_`].
#' @param recurse [`logical`]. If `TRUE`, collapse each argument separately
#' first, before collapsing the results into a single string.
#' @param conjunction character string to use as a conjunction for the
#' last two terms.
#' @param period [`logical`]. If `TRUE`, append a period to the end of the
#' string.
#' @param quote [`NULL`] or a character string indicating the type of quotes
#' to use for quoting the terms. If `NULL`, no quoting is done. If `"single"`,
#' single quotes are used, if `"double"`, double quotes are used, and if
#' `"back"`, backquotes are used.
#' @return a single character string.
#' @details
#' `collapse` and `collapse0` are simple wrappers for
#' `paste0(..., collapse = sep)` and `paste(..., collapse = sep)`, with
#' an option to collapse each argument separately first, before collapsing
#' the results.
#' @seealso [paste0], [sQuote], [dQuote], [bckQuote].
#' @examples
#' collapse(c("a", "b", "c"), "d")
#' collapse0(c("a", "b", "c"), "d")
#'
#' collapse(c("a", "b", "c"), "d", sep = ", ")
#' collapse0(c("a", "b", "c"), "d", sep = ", ")
#'
#' collapse(c("a", "b"), c("c", "d"), sep = ", ")
#' collapse(c("a", "b"), c("c", "d"), sep = ", ", recurse = TRUE)
#'
#' listing(c("a", "b", "c"), sep = ", ", conjunction = "and")
#' listing(c("a", "b"), conjunction = "or", period = FALSE)
#'
#' listing(c("a", "b", "c"), quote = "single")
#' listing(c("a", "b", "c"), quote = "double")
#' listing(c("a", "b", "c"), quote = "back")
#' @export
collapse <- function(..., sep = "", recurse = FALSE) {
  if (...length() == 0L) {
    return(character(0))
  }

  if (isTRUE(recurse)) {
    x <- lapply(list(...), function(x) paste(x, collapse = sep))
    do.call(paste, c(x, list(collapse = sep)))
  } else {
    paste(..., collapse = sep)
  }
}

#' @rdname collapse
#' @export
collapse0 <- function(..., sep = "", recurse = FALSE) {
  if (...length() == 0L) {
    return(character(0))
  }

  if (isTRUE(recurse)) {
    x <- lapply(list(...), function(x) paste0(x, collapse = sep))
    do.call(paste0, c(x, list(collapse = sep)))
  } else {
    paste0(..., collapse = sep)
  }
}

#' @rdname collapse
#' @export
listing <- function(
  x, sep = ", ", conjunction = "and", period = TRUE, quote = NULL
) {
  le <- length(x)
  if (le == 0L) {
    return(character(0))
  }

  if (!is.null(quote)) {
    quote <- match.arg(quote, c("single", "double", "back"))
    x <- switch(quote,
      single = sQuote(x),
      double = dQuote(x),
      back = bckQuote(x)
    )
  }

  if (le == 1L) {
    if (period) {
      paste0(x, ".")
    } else {
      x
    }
  } else {
    x <- paste(
      paste(x[-le], collapse = sep),
      conjunction,
      x[le]
    )

    if (isTRUE(period)) {
      paste0(x, ".")
    } else {
      x
    }
  }
}

#-- grepi, grepf

#' @title Pattern Matching
#' @description
#' Strongly typed wrappers around [`grep`] that have the
#' `fixed` and `ignore.case` arguments set internally.
#' @details
#' `*f()` suffixed functions have `fixed = TRUE` and conflicting
#' arguments (`perl` and `ignore.case`) set as `FALSE`.
#'
#' `*i()` suffixed functions have `ignore.case = TRUE` and the
#' conflicting `fixed` argument set as `FALSE`.
#'
#' For full documentation of the wrapped functions, see the help
#' pages for [`grep`].
#' @param pattern
#' character string containing a regular expression (or character string
#' for `fixed = TRUE` to be matched in the given character vector.
#' Coerced by [as.character] to a character string if possible.
#' If a character vector of length `2` or more is supplied, the first
#' element is used with a warning. Missing values are allowed.
#' @param x
#' a character vector where matches are sought, or an object
#' which can be coerced by [as.character] to a character vector.
#' Long vectors are supported.
#' @param value
#' logical. If `FALSE`, a vector containing the (integer) indices of
#' the matches determined by grep is returned, and if `TRUE`, a vector
#' containing the matching elements themselves is returned.
#' @param useBytes
#' logical. If `TRUE` the matching is done byte-by-byte rather
#' than character-by-character.
#' @param invert
#' logical. If `TRUE` return indices or values for elements that
#' do not match.
#' @param perl
#' logical. Should Perl-compatible regexps be used?
#' @return
#' with `value = FALSE`, return a vector of the
#' indices of the elements of `x` that yielded a match (or not,
#' for `invert = TRUE`). This will be an integer vector unless
#' the input is a long vector, when it will be a double vector.
#'
#' with `value = TRUE`, return a character vector containing the
#' selected elements of `x` (after coercion, preserving names but
#' no other attributes).
#' @examples
#' grepf("foo", c("foo", "Foo", "bar"))
#' grepf("foo", c("foo", "Foo", "bar"), value = TRUE)
#' grepi("foo", c("foo", "Foo", "bar"))
#' grepi("foo", c("foo", "Foo", "bar"), value = TRUE)
#' @family pattern-match-replacement-wrappers
#' @name grep-wrappers
NULL

#' @rdname grep-wrappers
#' @export
grepf <- function(
  pattern, x, value = FALSE, useBytes = FALSE, invert = FALSE
) {
  grep(
    pattern = pattern, x = x, ignore.case = FALSE,
    perl = FALSE, value = value, fixed = TRUE,
    useBytes = useBytes, invert = invert
  )
}

#' @rdname grep-wrappers
#' @export
grepi <- function(
  pattern, x, perl = FALSE, value = FALSE,
  useBytes = FALSE, invert = FALSE
) {
  grep(
    pattern = pattern, x = x, ignore.case = TRUE,
    perl = perl, value = value, fixed = FALSE,
    useBytes = useBytes, invert = invert
  )
}

#-- grepli, greplf

#' @inherit grep-wrappers title details
#' @description
#' Strongly typed wrappers around [`grepl`] that have the
#' `fixed` and `ignore.case` arguments set internally (as
#' well as the conflicting arguments).
#' @inheritParams grep-wrappers pattern x perl useBytes
#' @return
#' logical vector (match or not for each element of `x`).
#' @family pattern-match-replacement-wrappers
#' @name grepl-wrappers
#' @examples
#' greplf("foo", c("foo", "Foo", "bar"))
#' grepli("foo", c("foo", "Foo", "bar"))
NULL

#' @rdname grepl-wrappers
#' @export
greplf <- function(pattern, x, useBytes = FALSE) {
  grepl(
    pattern = pattern, x = x, ignore.case = FALSE,
    perl = FALSE, fixed = TRUE, useBytes = useBytes
  )
}

#' @rdname grepl-wrappers
#' @export
grepli <- function(pattern, x, perl = FALSE, useBytes = FALSE) {
  grepl(
    pattern = pattern, x = x, ignore.case = TRUE,
    perl = perl, fixed = FALSE, useBytes = useBytes
  )
}

#-- grepv, grepvi, grepvf

#' @inherit grep-wrappers title details
#' @description
#' Strongly typed wrappers around [`grep`] that have the
#' `value` (see note), `ignore.case` and `fixed` arguments
#' set internally (as well as the conflicting arguments).
#'
#' If `grepv` is found in the current **R** version, it is
#' reexported from base.
#' @inheritParams grep-wrappers pattern x perl useBytes invert value
#' @param ignore.case
#' logical. if `FALSE`, the pattern matching is case sensitive
#' and if `TRUE`, case is ignored during matching.
#' @param fixed
#' logical. If `TRUE`, pattern is a string to be matched as is.
#' Overrides all conflicting arguments.
#' @return
#' character vector containing the selected elements of `x`
#' (after coercion, preserving names but no other attributes).
#'
#' `grepv()` can also return a vector of the indices of the
#' elements of `x` that yielded a match (or not, for
#' `invert = TRUE`) if `value = FALSE` (see note). This will
#' be an integer vector unless the input is a long vector,
#' when it will be a double vector.
#' @note
#' suppr wrappers of the base grep/sub functions remove the
#' arguments that relate to the strong typing, just like
#' `grepl` does by not having a `value` argument. However,
#' the base `grepv` implementation has kept the `value`
#' argument, so the version here keeps the `value` argument
#' for compatibility.
#' @family pattern-match-replacement-wrappers
#' @name grepv-wrappers
#' @examples
#' grepv("foo", c("foo", "Foo", "bar"))
#' grepvf("foo", c("foo", "Foo", "bar"))
#' grepvi("foo", c("foo", "Foo", "bar"))
NULL

#' @rdname grepv-wrappers
#' @export
grepv <- function(
  pattern, x, ignore.case = FALSE, perl = FALSE,
  value = TRUE, fixed = FALSE, useBytes = FALSE,
  invert = FALSE
) {
  grep(
    pattern = pattern, x = x, ignore.case = ignore.case,
    perl = perl, value = value, fixed = fixed,
    useBytes = useBytes, invert = invert
  )
}

if (exists("grepv", envir = baseenv())) {
  grepv <- get("grepv", envir = baseenv())
}

#' @rdname grepv-wrappers
#' @export
grepvf <- function(pattern, x, useBytes = FALSE, invert = FALSE) {
  grepv(
    pattern = pattern, x = x, ignore.case = FALSE,
    perl = FALSE, value = TRUE, fixed = TRUE,
    useBytes = useBytes, invert = invert
  )
}

#' @rdname grepv-wrappers
#' @export
grepvi <- function(
  pattern, x, perl = FALSE, useBytes = FALSE, invert = FALSE
) {
  grepv(
    pattern = pattern, x = x, ignore.case = TRUE,
    perl = perl, value = TRUE, fixed = FALSE,
    useBytes = useBytes, invert = invert
  )
}

#-- subi, subf

#' @title Pattern Replacement Wrappers
#' @description
#' Strongly typed wrappers around [`sub`] and [`gsub`] that have the
#' `fixed` and `ignore.case` arguments set internally (as well as
#' the conflicting arguments).
#' @inherit grep-wrappers details
#' @inheritParams grep-wrappers pattern x perl useBytes
#' @param replacement
#' a replacement for the matched pattern in sub and gsub. Coerced
#' to character if possible. For `fixed = FALSE` this can include
#' backreferences `"\1"` to `"\9"` to parenthesized subexpressions
#' of pattern. For `perl = TRUE` only, it can also contain `"\U"`
#' or `"\L"` to convert the rest of the replacement to upper or
#' lower case and `"\E"` to end case conversion. If a character
#' vector of length 2 or more is supplied, the first element is
#' used with a warning. If NA, all elements in the result
#' corresponding to matches will be set to `NA`.
#' @return
#' a character vector of the same length and with the same attributes
#' as `x` (after possible coercion to character). Elements of
#' character vectors `x` which are not substituted will be returned
#' unchanged (including any declared encoding if `useBytes = FALSE`).
#' If `useBytes = FALSE` a non-ASCII substituted result will often be
#' in UTF-8 with a marked encoding (e.g., if there is a UTF-8 input,
#' and in a multibyte locale unless `fixed = TRUE`). Such strings can
#' be re-encoded by [`enc2native`]. If any of the inputs is marked as
#' "bytes", elements of character vectors `x` which are substituted
#' will be returned marked as "bytes", but the encoding flag on
#' elements not substituted is unspecified (it may be the original or
#' "bytes"). If none of the inputs is marked as "bytes", but
#' `useBytes = TRUE` is given explicitly, the encoding flag is
#' unspecified even on the substituted elements (it may be "bytes" or
#' "unknown", possibly invalid in the current encoding). Mixed use of
#' "bytes" and other marked encodings is discouraged, but if still
#' desired one may use [`iconv`] to re-encode the result e.g. to UTF-8
#' with suitably substituted invalid bytes.
#' @family pattern-match-replacement-wrappers
#' @name sub-wrappers
#' @examples
#' subf("foo", "X", c("foo", "Foo", "bar"))
#' subi("foo", "X", c("foo", "Foo", "bar"))
#'
#' gsubf("foo", "X", c("foo foo", "Foo", "bar"))
#' gsubi("foo", "X", c("foo foo", "Foo", "bar"))
NULL

#' @rdname sub-wrappers
#' @export
subf <- function(pattern, replacement, x, useBytes = FALSE) {
  sub(
    pattern = pattern, replacement = replacement, x = x,
    ignore.case = FALSE, perl = FALSE, fixed = TRUE,
    useBytes = useBytes
  )
}

#' @rdname sub-wrappers
#' @export
subi <- function(
  pattern, replacement, x, perl = FALSE, useBytes = FALSE
) {
  sub(
    pattern = pattern, replacement = replacement, x = x,
    ignore.case = TRUE, perl = perl, fixed = FALSE,
    useBytes = useBytes
  )
}

# gsubi, gsubf

#' @rdname sub-wrappers
#' @export
gsubf <- function(pattern, replacement, x, useBytes = FALSE) {
  gsub(
    pattern = pattern, replacement = replacement, x = x,
    ignore.case = FALSE, perl = FALSE, fixed = TRUE,
    useBytes = useBytes
  )
}

#' @rdname sub-wrappers
#' @export
gsubi <- function(
  pattern, replacement, x, perl = FALSE, useBytes = FALSE
) {
  gsub(
    pattern = pattern, replacement = replacement, x = x,
    ignore.case = TRUE, perl = perl, fixed = FALSE,
    useBytes = useBytes
  )
}
