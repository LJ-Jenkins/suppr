# Is Number Even/Odd?

Show where a numeric input is even or odd.

## Usage

``` r
is.even(x, noparity.na = FALSE)

is.odd(x, noparity.na = FALSE)
```

## Arguments

- x:

  numeric (logical, integer or double) vector.

- noparity.na:

  logical, whether values without parity (e.g., `NA`, `NaN`, `Inf`,
  `-Inf`, and decimal numbers) should return `NA` (`TRUE`) or `FALSE`
  (`FALSE`).

## Value

logical vector.

## Examples

``` r
is.even(2)
#> [1] TRUE
is.odd(1)
#> [1] TRUE

is.even(-5:5)
#>  [1] FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE
is.odd(-5:5)
#>  [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE

m <- matrix(1:4, nrow = 2, ncol = 2)
is.even(m)
#> [1] FALSE  TRUE FALSE  TRUE
is.odd(m)
#> [1]  TRUE FALSE  TRUE FALSE

# inputs without parity can be handled as NA or FALSE:
x <- c(2.0, 3.0, 2.2, 3.1, NA, Inf, -Inf, NaN)
is.even(x)
#> [1]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
is.odd(x)
#> [1] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
is.even(x, noparity.na = TRUE)
#> [1]  TRUE FALSE    NA    NA    NA    NA    NA    NA
is.odd(x, noparity.na = TRUE)
#> [1] FALSE  TRUE    NA    NA    NA    NA    NA    NA
```
