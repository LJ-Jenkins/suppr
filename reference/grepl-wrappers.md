# Pattern Matching

Strongly typed wrappers around
[`grepl`](https://rdrr.io/r/base/grep.html) that have the `fixed` and
`ignore.case` arguments set internally (as well as the conflicting
arguments).

## Usage

``` r
greplf(pattern, x, useBytes = FALSE)

grepli(pattern, x, perl = FALSE, useBytes = FALSE)
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

- useBytes:

  logical. If `TRUE` the matching is done byte-by-byte rather than
  character-by-character.

- perl:

  logical. Should Perl-compatible regexps be used?

## Value

logical vector (match or not for each element of `x`).

## Details

`*f()` suffixed functions have `fixed = TRUE` and conflicting arguments
(`perl` and `ignore.case`) set as `FALSE`.

`*i()` suffixed functions have `ignore.case = TRUE` and the conflicting
`fixed` argument set as `FALSE`.

For full documentation of the wrapped functions, see the help pages for
[`grep`](https://rdrr.io/r/base/grep.html).

## See also

Other pattern-match-replacement-wrappers:
[`grep-wrappers`](https://lj-jenkins.github.io/suppr/reference/grep-wrappers.md),
[`grepv-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepv-wrappers.md),
[`sub-wrappers`](https://lj-jenkins.github.io/suppr/reference/sub-wrappers.md)

## Examples

``` r
greplf("foo", c("foo", "Foo", "bar"))
#> [1]  TRUE FALSE FALSE
grepli("foo", c("foo", "Foo", "bar"))
#> [1]  TRUE  TRUE FALSE
```
