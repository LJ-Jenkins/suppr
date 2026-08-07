# Set given indices as NA

For given `indices`, set those indices of an object as `NA`.

## Usage

``` r
setNA(x, indices)

setNA(x) <- value
```

## Arguments

- x:

  an **R** object.

- indices:

  integer vector of indices to set as `NA`.

- value:

  integer vector of indices to set as `NA` for the replacement function.

## Value

the modified object with given indices set to `NA`.

## Details

This function is a S3 generic. The default method sets indices to `NA`
using `[<-`, passing the indices first to
[`arrayInd`](https://rdrr.io/r/base/which.html) if the input has a
non-`NULL` `dim` attribute.

The `setNA<-` function is meant to be a direct replacement for `is.na<-`
with (in my opinion) a clearer naming convention. The base methods are
implemented verbatim (for [factor](https://rdrr.io/r/base/factor.html)
and [numeric_version](https://rdrr.io/r/base/numeric_version.html)
objects), whereas the default method differs by using `arrayInd` (see
above), whereas `is.na<-` is implemented just as `x[value] <- NA`.

## See also

`is.na<-`,
[whichNA](https://lj-jenkins.github.io/suppr/reference/whichNA.md)

## Examples

``` r
setNA(1:5, c(1, 4))
#> [1] NA  2  3 NA  5
setNA(c("hi", "hello", "bye", "goodbye"), c(1, 4))
#> [1] NA      "hello" "bye"   NA     
setNA(matrix(1:4, 2, 2), c(1, 4))
#>      [,1] [,2]
#> [1,]   NA    3
#> [2,]    2   NA
setNA(list(1, 2, 3, list(1, 2)), c(1, 4))
#> [[1]]
#> [1] NA
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
#> 
#> [[4]]
#> [1] NA
#> 

x <- 1:10
setNA(x) <- c(1, 7, 9)
x
#>  [1] NA  2  3  4  5  6 NA  8 NA 10
```
