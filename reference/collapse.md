# Collapse a Vector of Strings into a Single String

Collapse a character vector into a single string, with an optional
separator, and for `listing()` an optional conjunction and period, with
options to quote the terms.

## Usage

``` r
collapse(..., sep = "", recurse = FALSE)

collapse0(..., sep = "", recurse = FALSE)

listing(x, sep = ", ", conjunction = "and", period = TRUE, quote = NULL)
```

## Arguments

- ...:

  one or more R objects, to be converted to character vectors.

- sep:

  character string to collapse the terms, not
  [`NA_character_`](https://rdrr.io/r/base/NA.html).

- recurse:

  [`logical`](https://rdrr.io/r/base/logical.html). If TRUE, collapse
  each argument separately first, before collapsing the results into a
  single string.

- conjunction:

  character string to use as a conjunction for the last two terms.

- period:

  [`logical`](https://rdrr.io/r/base/logical.html). If TRUE, append a
  period to the end of the string.

- quote:

  [`NULL`](https://rdrr.io/r/base/NULL.html) or a character string
  indicating the type of quotes to use for quoting the terms. If `NULL`,
  no quoting is done. If `"single"`, single quotes are used, if
  `"double"`, double quotes are used, and if `"back"`, backquotes are
  used.

## Value

a single character string.

## Details

`collapse` and `collapse0` are simple wrappers for
`paste0(..., collapse = sep)` and `paste(..., collapse = sep)`, with an
option to collapse each argument separately first.

## See also

[paste0](https://rdrr.io/r/base/paste.html),
[sQuote](https://rdrr.io/r/base/sQuote.html),
[dQuote](https://rdrr.io/r/base/sQuote.html),
[bckQuote](https://lj-jenkins.github.io/suppr/reference/bckQuote.md).

## Examples

``` r
collapse(c("a", "b", "c"), "d")
#> [1] "a db dc d"
collapse0(c("a", "b", "c"), "d")
#> [1] "adbdcd"

collapse(c("a", "b", "c"), "d", sep = ", ")
#> [1] "a d, b d, c d"
collapse0(c("a", "b", "c"), "d", sep = ", ")
#> [1] "ad, bd, cd"

collapse(c("a", "b"), c("c", "d"), sep = ", ")
#> [1] "a c, b d"
collapse(c("a", "b"), c("c", "d"), sep = ", ", recurse = TRUE)
#> [1] "a, b c, d"

listing(c("a", "b", "c"), sep = ", ", conjunction = "and")
#> [1] "a, b and c."
listing(c("a", "b"), conjunction = "or", period = FALSE)
#> [1] "a or b"

listing(c("a", "b", "c"), quote = "s")
#> [1] "‘a’, ‘b’ and ‘c’."
listing(c("a", "b", "c"), quote = "d")
#> [1] "“a”, “b” and “c”."
listing(c("a", "b", "c"), quote = "b")
#> [1] "`a`, `b` and `c`."
```
