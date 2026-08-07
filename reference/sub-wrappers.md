# Pattern Replacement Wrappers

Strongly typed wrappers around [`sub`](https://rdrr.io/r/base/grep.html)
and [`gsub`](https://rdrr.io/r/base/grep.html) that have the
`ignore.case` and `fixed` arguments set internally.

## Usage

``` r
subi(pattern, replacement, x, perl = FALSE, fixed = FALSE, useBytes = FALSE)

subf(
  pattern,
  replacement,
  x,
  ignore.case = FALSE,
  perl = FALSE,
  useBytes = FALSE
)

subfi(pattern, replacement, x, perl = FALSE, useBytes = FALSE)

gsubi(pattern, replacement, x, perl = FALSE, fixed = FALSE, useBytes = FALSE)

gsubf(
  pattern,
  replacement,
  x,
  ignore.case = FALSE,
  perl = FALSE,
  useBytes = FALSE
)

gsubfi(pattern, replacement, x, perl = FALSE, useBytes = FALSE)
```

## Arguments

- pattern:

  character string containing a regular expression (or character string
  for `fixed = TRUE` to be matched in the given character vector.
  Coerced by [as.character](https://rdrr.io/r/base/character.html) to a
  character string if possible. If a character vector of length 2 or
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

## See also

Other pattern-match-replacement-wrappers:
[`grep-wrappers`](https://lj-jenkins.github.io/suppr/reference/grep-wrappers.md),
[`grepl-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepl-wrappers.md),
[`grepv-wrappers`](https://lj-jenkins.github.io/suppr/reference/grepv-wrappers.md)
