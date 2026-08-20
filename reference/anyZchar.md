# Are any zero char or all whitespace elements present?

Tests if a character vector contains any zero character or all
whitespace elements.

## Usage

``` r
anyZchar(x)

anyWS(x, zchar = FALSE)
```

## Arguments

- x:

  a character vector.

- zchar:

  if `TRUE` then zero character elements will be treated as all
  whitespace.

## Value

an integer or real vector of length one with value the `1`-based index
of the first zero char/all whitespace value if any, otherwise `0`.

## Details

`anyZchar()` and `anyWS()` return an index immediately when encountering
a zero character or a whitespace element, respectively.

Whitespace elements are defined as any character that is a space,
horizontal tab, carriage return or newline, aka `"[ \t\r\n]"`. See
[trimws](https://rdrr.io/r/base/trimws.html) for more details and how to
instead match all unicode whitespace.

`anyZchar()` implements the same definition of a zero char as
[`nzchar`](https://rdrr.io/r/base/nchar.html).

`NA_character_` is not considered zero char or all whitespace.

## Note

Unlike the similar base functions, these do not coerce the input to
character.

## See also

[nzchar](https://rdrr.io/r/base/nchar.html),
[trimws](https://rdrr.io/r/base/trimws.html),
[anyNF](https://lj-jenkins.github.io/suppr/reference/is.nonfinite.md)

## Examples

``` r
anyZchar(c("hi", "bye", " ", ""))
#> [1] 4
anyWS(c("hi", "bye", " ", ""))
#> [1] 3
anyWS(c("hi", "bye", "who", ""), zchar = TRUE)
#> [1] 4
```
