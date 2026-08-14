# Pattern Replacement Wrappers

Strongly typed wrappers around [`sub`](https://rdrr.io/r/base/grep.html)
and [`gsub`](https://rdrr.io/r/base/grep.html) that have the `fixed` and
`ignore.case` arguments set internally (as well as the conflicting
arguments).

## Usage

``` r
subf(pattern, replacement, x, useBytes = FALSE)

subi(pattern, replacement, x, perl = FALSE, useBytes = FALSE)

gsubf(pattern, replacement, x, useBytes = FALSE)

gsubi(pattern, replacement, x, perl = FALSE, useBytes = FALSE)
```

## Arguments

- pattern:

  character string containing a regular expression (or character string
  for `fixed = TRUE` to be matched in the given character vector.
  Coerced by [as.character](https://rdrr.io/r/base/character.html) to a
  character string if possible. If a character vector of length `2` or
  more is supplied, the first element is used with a warning. Missing
  values are allowed.

- replacement:

  a replacement for the matched pattern in sub and gsub. Coerced to
  character if possible. For `fixed = FALSE` this can include
  backreferences `"\1"` to `"\9"` to parenthesized subexpressions of
  pattern. For `perl = TRUE` only, it can also contain `"\U"` or `"\L"`
  to convert the rest of the replacement to upper or lower case and
  `"\E"` to end case conversion. If a character vector of length 2 or
  more is supplied, the first element is used with a warning. If NA, all
  elements in the result corresponding to matches will be set to `NA`.

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

a character vector of the same length and with the same attributes as
`x` (after possible coercion to character). Elements of character
vectors `x` which are not substituted will be returned unchanged
(including any declared encoding if `useBytes = FALSE`). If
`useBytes = FALSE` a non-ASCII substituted result will often be in UTF-8
with a marked encoding (e.g., if there is a UTF-8 input, and in a
multibyte locale unless `fixed = TRUE`). Such strings can be re-encoded
by [`enc2native`](https://rdrr.io/r/base/Encoding.html). If any of the
inputs is marked as "bytes", elements of character vectors `x` which are
substituted will be returned marked as "bytes", but the encoding flag on
elements not substituted is unspecified (it may be the original or
"bytes"). If none of the inputs is marked as "bytes", but
`useBytes = TRUE` is given explicitly, the encoding flag is unspecified
even on the substituted elements (it may be "bytes" or "unknown",
possibly invalid in the current encoding). Mixed use of "bytes" and
other marked encodings is discouraged, but if still desired one may use
[`iconv`](https://rdrr.io/r/base/iconv.html) to re-encode the result
e.g. to UTF-8 with suitably substituted invalid bytes.

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
[`grepl-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepl-wrappers.md),
[`grepv-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepv-wrappers.md)

## Examples

``` r
subf("foo", "X", c("foo", "Foo", "bar"))
#> [1] "X"   "Foo" "bar"
subi("foo", "X", c("foo", "Foo", "bar"))
#> [1] "X"   "X"   "bar"

gsubf("foo", "X", c("foo foo", "Foo", "bar"))
#> [1] "X X" "Foo" "bar"
gsubi("foo", "X", c("foo foo", "Foo", "bar"))
#> [1] "X X" "X"   "bar"
```
