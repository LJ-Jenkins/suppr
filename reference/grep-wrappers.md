# Pattern Matching

Strongly typed wrappers around
[`grep`](https://rdrr.io/r/base/grep.html) that have the `fixed` and
`ignore.case` arguments set internally.

## Usage

``` r
grepf(pattern, x, value = FALSE, useBytes = FALSE, invert = FALSE)

grepi(
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
  character string if possible. If a character vector of length `2` or
  more is supplied, the first element is used with a warning. Missing
  values are allowed.

- x:

  a character vector where matches are sought, or an object which can be
  coerced by [as.character](https://rdrr.io/r/base/character.html) to a
  character vector. Long vectors are supported.

- value:

  logical. If `FALSE`, a vector containing the (integer) indices of the
  matches determined by grep is returned, and if `TRUE`, a vector
  containing the matching elements themselves is returned.

- useBytes:

  logical. If `TRUE` the matching is done byte-by-byte rather than
  character-by-character.

- invert:

  logical. If `TRUE` return indices or values for elements that do not
  match.

- perl:

  logical. Should Perl-compatible regexps be used?

## Value

with `value = FALSE`, return a vector of the indices of the elements of
`x` that yielded a match (or not, for `invert = TRUE`). This will be an
integer vector unless the input is a long vector, when it will be a
double vector.

with `value = TRUE`, return a character vector containing the selected
elements of `x` (after coercion, preserving names but no other
attributes).

## Details

`*f()` suffixed functions have `fixed = TRUE` and conflicting arguments
(`perl` and `ignore.case`) set as `FALSE`.

`*i()` suffixed functions have `ignore.case = TRUE` and the conflicting
`fixed` argument set as `FALSE`.

For full documentation of the wrapped functions, see the help pages for
[`grep`](https://rdrr.io/r/base/grep.html).

## See also

Other pattern-match-replacement-wrappers:
[`grepl-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepl-wrappers.md),
[`grepv-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepv-wrappers.md),
[`sub-wrappers`](https://lj-jenkins.github.io/suppr/reference/sub-wrappers.md)

## Examples

``` r
grepf("foo", c("foo", "Foo", "bar"))
#> [1] 1
grepf("foo", c("foo", "Foo", "bar"), value = TRUE)
#> [1] "foo"
grepi("foo", c("foo", "Foo", "bar"))
#> [1] 1 2
grepi("foo", c("foo", "Foo", "bar"), value = TRUE)
#> [1] "foo" "Foo"
```
