# Pattern Matching

Strongly typed wrappers around
[`grep`](https://rdrr.io/r/base/grep.html) that have the `value` (see
note), `ignore.case` and `fixed` arguments set internally (as well as
the conflicting arguments).

If `grepv` is found in the current **R** version, it is reexported from
base.

## Usage

``` r
grepv(
  pattern,
  x,
  ignore.case = FALSE,
  perl = FALSE,
  value = TRUE,
  fixed = FALSE,
  useBytes = FALSE,
  invert = FALSE
)

grepvf(pattern, x, useBytes = FALSE, invert = FALSE)

grepvi(pattern, x, perl = FALSE, useBytes = FALSE, invert = FALSE)
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

- ignore.case:

  logical. if `FALSE`, the pattern matching is case sensitive and if
  `TRUE`, case is ignored during matching.

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

## Value

character vector containing the selected elements of `x` (after
coercion, preserving names but no other attributes).

`grepv()` can also return a vector of the indices of the elements of `x`
that yielded a match (or not, for `invert = TRUE`) if `value = FALSE`
(see note). This will be an integer vector unless the input is a long
vector, when it will be a double vector.

## Details

`*f()` suffixed functions have `fixed = TRUE` and conflicting arguments
(`perl` and `ignore.case`) set as `FALSE`.

`*i()` suffixed functions have `ignore.case = TRUE` and the conflicting
`fixed` argument set as `FALSE`.

For full documentation of the wrapped functions, see the help pages for
[`grep`](https://rdrr.io/r/base/grep.html).

## Note

suppr wrappers of the base grep/sub functions remove the arguments that
relate to the strong typing, just like `grepl` does by not having a
`value` argument. However, the base `grepv` implementation has kept the
`value` argument, so the version here keeps the `value` argument for
compatibility.

## See also

Other pattern-match-replacement-wrappers:
[`grep-wrappers`](https://lj-jenkins.github.io/suppr/reference/grep-wrappers.md),
[`grepl-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepl-wrappers.md),
[`sub-wrappers`](https://lj-jenkins.github.io/suppr/reference/sub-wrappers.md)

## Examples

``` r
grepv("foo", c("foo", "Foo", "bar"))
#> [1] "foo"
grepvf("foo", c("foo", "Foo", "bar"))
#> [1] "foo"
grepvi("foo", c("foo", "Foo", "bar"))
#> [1] "foo" "Foo"
```
