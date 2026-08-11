# Are any non-finite values present?

Tests if a vector contains any non-finite values (`Inf`, `-Inf`, `NaN`,
or `NA`).

## Usage

``` r
anyNF(x)
```

## Arguments

- x:

  a logical, numeric, or complex vector.

## Value

an integer or real vector of length one with value the `1`-based index
of the first non-finite value if any, otherwise `0`.

## Details

`anyNF()` returns an index immediately when encountering a non-finite
value.

## Note

For character vectors use [anyNA](https://rdrr.io/r/base/NA.html).

## See also

[is.finite](https://rdrr.io/r/base/is.finite.html),
[is.whole](https://lj-jenkins.github.io/suppr/reference/is.whole.md)

## Examples

``` r
anyNF(1:10)
#> [1] 0
anyNF(c(1, 2, NA, 4))
#> [1] 3
anyNF(c(1, 2, NaN, 4))
#> [1] 3
anyNF(c(1, 2, Inf, 4))
#> [1] 3
anyNF(c(1, 2, -Inf, 4))
#> [1] 3

try(anyNF("1"))
#> Error in anyNF("1") : Input must be a logical, numeric or complex vector.
```
