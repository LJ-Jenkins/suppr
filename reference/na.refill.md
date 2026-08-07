# Refill the NAs for a 'na.action' Object

For a [na.action](https://rdrr.io/r/stats/na.action.html) object, use
the indices of where `NA`s were removed to refill the object back to its
original size with `NA`s in the appropriate positions.

## Usage

``` r
na.refill(object, ...)
```

## Arguments

- object:

  a [na.action](https://rdrr.io/r/stats/na.action.html) object (atomic
  vector, matrix or data.frame).

- ...:

  further arguments special methods could require.

## Value

vector, matrix or data.frame with the indices from `na.action` refilled
with `NA`s. [rownames](https://rdrr.io/r/base/colnames.html) and
[colnames](https://rdrr.io/r/base/colnames.html) are preserved.

If the object given is not of those types, or not a `na.action` object,
it is returned unchanged.

## Details

For objects where [na.omit](https://rdrr.io/r/stats/na.fail.html)
removes whole rows (e.g., matrices, data.frames), the information about
that row is lost, so `na.refill` will refill those **entire rows** with
`NA`s.

## See also

[na.action](https://rdrr.io/r/stats/na.action.html),
[na.omit](https://rdrr.io/r/stats/na.fail.html)

## Examples

``` r
x <- c(1, 2, NA, 4, NA, 6)
na_x <- na.omit(x)
na_x
#> [1] 1 2 4 6
#> attr(,"na.action")
#> [1] 3 5
#> attr(,"class")
#> [1] "omit"
na.refill(na_x)
#> [1]  1  2 NA  4 NA  6
#> attr(,"na.action")
#> [1] 3 5
#> attr(,"class")
#> [1] "refilled"

m <- matrix(1:9, 3, 3)
m[c(1, 3), 1:2] <- NA
dimnames(m) <- list(c("r1", "r2", "r3"), c("a", "b", "c"))
na_m <- na.omit(m)
na_m
#>    a b c
#> r2 2 5 8
#> attr(,"na.action")
#> r1 r3 
#>  1  3 
#> attr(,"class")
#> [1] "omit"
na.refill(na_m) # previous data in NA row is lost
#>     a  b  c
#> r1 NA NA NA
#> r2  2  5  8
#> r3 NA NA NA
#> attr(,"na.action")
#> r1 r3 
#>  1  3 
#> attr(,"class")
#> [1] "refilled"

df <- data.frame(x = 1:5, y = c("a", NA, "c", "d", NA))
na_df <- na.omit(df)
na_df
#>   x y
#> 1 1 a
#> 3 3 c
#> 4 4 d
na.refill(na_df)
#>    x    y
#> 1  1    a
#> 2 NA <NA>
#> 3  3    c
#> 4  4    d
#> 5 NA <NA>
```
