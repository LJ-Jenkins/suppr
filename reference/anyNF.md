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

a single `TRUE` or `FALSE`.

## Details

`anyNF()` returns `TRUE` immediately when encountering a non-finite
value.

## Note

`anyNF()` will throw an error if the input is not a numeric vector. For
character vectors use [anyNA](https://rdrr.io/r/base/NA.html).

## See also

[is.finite](https://rdrr.io/r/base/is.finite.html),
[is.whole](https://lj-jenkins.github.io/suppr/reference/is.whole.md)

## Examples

``` r
anyNF(1:10)
#> [1] FALSE
anyNF(c(1, 2, NA, 4))
#> [1] TRUE
anyNF(c(1, 2, NaN, 4))
#> [1] TRUE
anyNF(c(1, 2, Inf, 4))
#> [1] TRUE
anyNF(c(1, 2, -Inf, 4))
#> [1] TRUE

try(anyNF("1"))
#> Error in anyNF("1") : Input must be a logical, numeric or complex vector.
```
