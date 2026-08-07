# Which indices are NA?

Give the indices of `NA` values, allowing for array indices. Use the
assignment function `whichNA<-` to replace `NA` values with a given
value/s.

## Usage

``` r
whichNA(x)

whichNA(x) <- value
```

## Arguments

- x:

  numeric **R** object. Does not accept `complex` or `raw.`

- value:

  value to replace `NA` values with when using the assignment function.

## Value

If using `whichNA`, integer vector of indices of `NA` values in `x`, or
matrix of array indices if `arr.ind` is `TRUE`. If using `whichNA<-`,
the modified object with `NA` values replaced by `value`.

## Details

`whichNA<-` follows **R**'s usual recycling rules when replacing `NA`
values with `value`. If there are no `NA` values in `x`, no replacement
is made.

## See also

[is.na](https://rdrr.io/r/base/NA.html),
[setNA](https://lj-jenkins.github.io/suppr/reference/setNA.md),
[whichMin](https://lj-jenkins.github.io/suppr/reference/whichMin.md),
[whichMax](https://lj-jenkins.github.io/suppr/reference/whichMin.md)

## Examples

``` r
x <- c(1, NA, 3, NA, 5)
whichNA(x)
#> [1] 2 4
whichNA(x) <- 0
x
#> [1] 1 0 3 0 5

m <- matrix(c(1, NA, 3, NA, 5, NA), nrow = 2)
whichNA(m)
#> [1] 2 4 6

y <- c("a" = 1, "b" = NA, "c" = 2, "d" = NA, "e" = NA, "f" = NA)
whichNA(y)
#> b d e f 
#> 2 4 5 6 
whichNA(y) <- c(91, 92) # value recycled to number of NA's
y
#>  a  b  c  d  e  f 
#>  1 91  2 92 91 92 
```
