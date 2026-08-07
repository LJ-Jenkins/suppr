# Pattern Matching

Strongly typed wrappers around
[`grep`](https://rdrr.io/r/base/grep.html) that have the `ignore.case`
and `fixed` arguments set internally.

## Usage

``` r
grepi(
  pattern,
  x,
  perl = FALSE,
  value = FALSE,
  fixed = FALSE,
  useBytes = FALSE,
  invert = FALSE
)

grepf(
  pattern,
  x,
  ignore.case = FALSE,
  perl = FALSE,
  value = FALSE,
  useBytes = FALSE,
  invert = FALSE
)

grepfi(
  pattern,
  x,
  perl = FALSE,
  value = FALSE,
  useBytes = FALSE,
  invert = FALSE
)
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

- value:

  logical. If `FALSE`, a vector containing the (integer) indices of the
  matches determined by grep is returned, and if `TRUE`, a vector
  containing the matching elements themselves is returned.

- fixed:

  logical. If `TRUE`, pattern is a string to be matched as is. Overrides
  all conflicting arguments.

- useBytes:

  logical. If `TRUE` the matching is done byte-by-byte rather than
  character-by-character.

- invert:

  logical. If `TRUE` return indices or values for elements that do not
  match.

- ignore.case:

  logical. if `FALSE`, the pattern matching is case sensitive and if
  `TRUE`, case is ignored during matching.

## Value

with `value = FALSE`, return a vector of the indices of the elements of
`x` that yielded a match (or not, for `invert = TRUE`). This will be an
integer vector unless the input is a long vector, when it will be a
double vector.

with `value = TRUE`, return a character vector containing the selected
elements of `x` (after coercion, preserving names but no other
attributes).

## Details

`*i()` suffixed functions have `ignore.case = TRUE`.

`*f()` suffixed functions have `fixed = TRUE`.

`*fi()` suffixed functions have both `fixed = TRUE` and
`ignore.case = TRUE`.

For full documentation of the wrapped functions, see the help pages for
[`grep`](https://rdrr.io/r/base/grep.html).

## See also

Other pattern-match-replacement-wrappers:
[`grepl-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepl-wrappers.md),
[`grepv-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepv-wrappers.md),
[`sub-wrappers`](https://lj-jenkins.github.io/suppr/reference/sub-wrappers.md)

## Examples

``` r
bckQuote("example")
#> [1] "`example`"
bckQuote(c("one", "two", "three"))
#> [1] "`one`"   "`two`"   "`three`"
bckQuote(123)
#> [1] "`123`"
```
