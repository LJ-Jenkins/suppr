# Pattern Matching

Strongly typed wrappers around
[`grepl`](https://rdrr.io/r/base/grep.html) that have the `ignore.case`
and `fixed` arguments set internally.

## Usage

``` r
grepli(pattern, x, perl = FALSE, fixed = FALSE, useBytes = FALSE)

greplf(pattern, x, ignore.case = FALSE, perl = FALSE, useBytes = FALSE)

greplfi(pattern, x, perl = FALSE, useBytes = FALSE)
```

## Arguments

- pattern:

  character string containing a regular expression (or character string
  for `fixed = TRUE` to be matched in the given character vector.
  Coerced by [as.character](https://rdrr.io/r/base/character.html) to a
  character string if possible. If a character vector of length 2 or
  more is supplied, the first element is used with a warning. Missing
  values are allowed.

- x:

  a character vector where matches are sought, or an object which can be
  coerced by [as.character](https://rdrr.io/r/base/character.html) to a
  character vector. Long vectors are supported.

- perl:

  logical. Should Perl-compatible regexps be used?

- fixed:

  logical. If `TRUE`, pattern is a string to be matched as is. Overrides
  all conflicting arguments.

- useBytes:

  logical. If `TRUE` the matching is done byte-by-byte rather than
  character-by-character.

- ignore.case:

  logical. if `FALSE`, the pattern matching is case sensitive and if
  `TRUE`, case is ignored during matching.

## Value

logical vector (match or not for each element of `x`).

## Details

`*i()` suffixed functions have `ignore.case = TRUE`.

`*f()` suffixed functions have `fixed = TRUE`.

`*fi()` suffixed functions have both `fixed = TRUE` and
`ignore.case = TRUE`.

For full documentation of the wrapped functions, see the help pages for
[`grep`](https://rdrr.io/r/base/grep.html).

## See also

Other pattern-match-replacement-wrappers:
[`grep-wrappers`](https://lj-jenkins.github.io/suppr/reference/grep-wrappers.md),
[`grepv-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepv-wrappers.md),
[`sub-wrappers`](https://lj-jenkins.github.io/suppr/reference/sub-wrappers.md)
