# Is object of a Date type?

Tests if an object inherits from some/all of **R**'s date types: `Date`,
`POSIXt`, `POSIXct` and `POSIXlt`.

## Usage

``` r
is.datetype(x)

is.Date(x)

is.POSIXt(x)

is.POSIXct(x)

is.POSIXlt(x)
```

## Arguments

- x:

  an **R** object.

## Value

`TRUE` or `FALSE`.

## Details

`is.datetype` checks if the object inherits from either `Date` or
`POSIXt`.

`is.Date` checks if the object inherits from `Date`.

`is.POSIXt` checks if the object inherits from `POSIXt`.

`is.POSIXct` checks if the object inherits from `POSIXct`.

`is.POSIXlt` checks if the object inherits from `POSIXlt`.

## See also

[as.Date](https://rdrr.io/r/base/as.Date.html),
[as.POSIXct](https://rdrr.io/r/base/as.POSIXlt.html),
[as.POSIXlt](https://rdrr.io/r/base/as.POSIXlt.html).

## Examples

``` r
a <- "2020-01-01"
b <- as.Date("2020-01-01")
c <- 123

is.Date(a)
#> [1] FALSE
is.Date(b)
#> [1] TRUE
is.Date(c)
#> [1] FALSE

is.Date(as.POSIXct(a))
#> [1] FALSE
is.POSIXt(as.POSIXct(a))
#> [1] TRUE
is.POSIXct(as.POSIXct(a))
#> [1] TRUE
is.POSIXlt(as.POSIXct(a))
#> [1] FALSE
is.datetype(as.POSIXct(a))
#> [1] TRUE
```
