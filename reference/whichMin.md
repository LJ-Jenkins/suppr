# Where is the min or max?

Determines the location (i.e., index) of the (first, last, or all)
minima or maxima of a numeric (or logical) vector.

## Usage

``` r
whichMin(x, loc = c("first", "last", "all"))

whichMax(x, loc = c("first", "last", "all"))

whichMin(x, loc = c("first", "last", "all")) <- value

whichMax(x, loc = c("first", "last", "all")) <- value
```

## Arguments

- x:

  numeric (logical, integer or double) vector or an **R** object for
  which the internal coercion to
  [double](https://rdrr.io/r/base/double.html) works whose
  [min](https://rdrr.io/r/base/Extremes.html) or
  [max](https://rdrr.io/r/base/Extremes.html) is searched for.

- loc:

  `'first'`, `'last'` or `'all'` to specify which index/indices to
  return.

- value:

  value/s to replace the min or max values with when using the
  assignment functions.

## Value

integer of indices. For the assignment functions, the modified object
with min or max values replaced by `value`.

## Note

For `logical` vectors, `which(x)` is faster than
`whichMax(x, loc = "all")`, but `whichMin(x, loc = "all")` can be faster
than `which(!x)` for medium to large vectors due to not having the
performance cost of negating the vector.

## See also

[which](https://rdrr.io/r/base/which.html),
[which.max](https://rdrr.io/r/base/which.min.html) and
[which.min](https://rdrr.io/r/base/which.min.html)

## Examples

``` r
x <- c(1:4, 0:5, 11, 1:4, 0:5, 11)
whichMin(x)
#> [1] 5
whichMin(x, loc = "last")
#> [1] 16
whichMax(x)
#> [1] 11
whichMax(x, loc = "all")
#> [1] 11 22

# it *does* work with NA's present, by discarding them:
presidents[1:30]
#>  [1] NA 87 82 75 63 50 43 32 35 60 54 55 36 39 NA NA 69 57 57 51 45 37 46 39 36
#> [26] 24 32 23 25 32
whichMin(presidents) # 28
#> [1] 28
whichMax(presidents) #  2
#> [1] 2

# Find the first occurrence, i.e. the first TRUE, if there is at least one:
x <- rpois(10000, lambda = 10)
x[sample.int(50, 20)] <- NA
# where is the first value >= 20 ?
whichMax(x >= 20)
#> [1] 911
whichMax(x >= 20, loc = "last")
#> [1] 9393
whichMax(x >= 20, loc = "all")
#>  [1]  911 2414 2895 3322 3511 3709 3953 4124 4268 4590 4592 4947 5180 5231 5681
#> [16] 5803 5989 5991 6171 6494 7028 7107 7189 7295 7456 7789 7905 7936 7989 8029
#> [31] 8274 8516 8530 8667 8747 8758 9393

# objects are coerced to numeric vectors if possible:
whichMin(list(A = 7, pi = pi)) ##  ->  c(pi = 2L)
#> pi 
#>  2 

x <- 1:4
whichMin(x) <- 999
whichMax(x) <- -999
x
#> [1] -999    2    3    4
```
