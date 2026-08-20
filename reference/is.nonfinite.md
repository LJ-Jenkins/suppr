# Are non-finite values present?

Tests if a vector contains non-finite values (`Inf`, `-Inf`, `NaN`, or
`NA`).

## Usage

``` r
is.nonfinite(x)

is.nf(x)

anyNF(x)
```

## Arguments

- x:

  **R** object to be tested: the default methods handle atomic vectors.

## Value

For `is.nonfinite()` and `is.nf()`, a logical vector of the same length
as `x`.

For `anyNF()`, an integer or real vector of length one with value the
`1`-based index of the first non-finite value if any, otherwise `0`.

## Details

`is.nonfinite()` (and alias `is.nf()`) check for non-finite values,
returning a logical vector of the same length as `x`, whereas `anyNF()`
returns an index immediately when encountering a non-finite value.

`is.nonfinite()` and `anyNF()` are S3 generics, so custom methods can be
defined for different object types.

Similar to [`is.finite()`](https://rdrr.io/r/base/is.finite.html)
semantics, `is.nonfinite()` returns all `TRUE` for character and raw
vectors, and `anyNF()` returns `1L`.

## Note

For character vectors use [is.na](https://rdrr.io/r/base/NA.html) and
[anyNA](https://rdrr.io/r/base/NA.html).

## See also

[is.finite](https://rdrr.io/r/base/is.finite.html),
[is.whole](https://lj-jenkins.github.io/suppr/reference/is.whole.md),
[anyZchar](https://lj-jenkins.github.io/suppr/reference/anyZchar.md),
[anyWS](https://lj-jenkins.github.io/suppr/reference/anyZchar.md)

## Examples

``` r
is.nonfinite(1:10)
#>  [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
anyNF(1:10)
#> [1] 0

is.nonfinite(c(1, 2, NA, 4))
#> [1] FALSE FALSE  TRUE FALSE
anyNF(c(1, 2, NA, 4))
#> [1] 3

is.nonfinite(c(1, 2, NaN, 4))
#> [1] FALSE FALSE  TRUE FALSE
anyNF(c(1, 2, NaN, 4))
#> [1] 3

is.nonfinite(c(1, 2, Inf, 4))
#> [1] FALSE FALSE  TRUE FALSE
anyNF(c(1, 2, Inf, 4))
#> [1] 3

is.nf(c(1, 2, -Inf, 4))
#> [1] FALSE FALSE  TRUE FALSE
anyNF(c(1, 2, -Inf, 4))
#> [1] 3
```
