# Remove First or Last N Elements

Remove the first or last `n` elements of an **R** object.

## Usage

``` r
rm.first(x, n = 1L, ...)

# Default S3 method
rm.first(x, n = 1L, ...)

rm.first(x, ...) <- value

# Default S3 method
rm.first(x, ...) <- value

rm.last(x, n = 1L, ...)

# Default S3 method
rm.last(x, n = 1L, ...)

rm.last(x, ...) <- value

# Default S3 method
rm.last(x, ...) <- value
```

## Arguments

- x:

  an **R** object with a `[` method, e.g., a vector, matrix, list.

- n:

  integer, number of elements to remove from the beginning or end.

- value:

  integer, same as `n`.

## Value

The modified object with the first or last `n` elements removed.

## Details

The default methods operate on atomic vectors and lists, removing `n`
elements from the beginning or end of the object.

Dimensional objects ([matrix](https://rdrr.io/r/base/matrix.html),
[data.frame](https://rdrr.io/r/base/data.frame.html),
[array](https://rdrr.io/r/base/array.html)) are handled by removing `n`
entries along the first dimension ('row-wise' for matrices/data.frames
and for each slice of higher-dimensional arrays). Remaining dimensions
are preserved.

## Examples

``` r
x <- 1:10
rm.first(x, 3)
#> [1]  4  5  6  7  8  9 10
rm.last(x, 3)
#> [1] 1 2 3 4 5 6 7

x <- matrix(1:10, nrow = 5)
rm.first(x, 2)
#>      [,1] [,2]
#> [1,]    3    8
#> [2,]    4    9
#> [3,]    5   10
rm.last(x, 2)
#>      [,1] [,2]
#> [1,]    1    6
#> [2,]    2    7
#> [3,]    3    8

x <- list(a = 1, b = 2, c = 3, d = 4)
rm.first(x, 2)
#> $c
#> [1] 3
#> 
#> $d
#> [1] 4
#> 
rm.last(x, 2)
#> $a
#> [1] 1
#> 
#> $b
#> [1] 2
#> 

x <- 1:10
rm.first(x) <- 3
rm.last(x) <- 3
x
#> [1] 4 5 6 7
```
