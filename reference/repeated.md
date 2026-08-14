# Determine Repeated Elements

Return a logical vector, indices, or the values of repeated elements in
a vector.

## Usage

``` r
repeated(x, ...)

# S3 method for class 'array'
repeated(x, MARGIN = 1L, ...)

whichRepeated(x, ...)

# S3 method for class 'array'
whichRepeated(x, MARGIN = 1L, ...)

repeats(x, ...)

# S3 method for class 'array'
repeats(x, MARGIN = 1L, ...)

non.unique(x, ...)
```

## Arguments

- x:

  a vector, a data frame, an array, or `NULL`.

- ...:

  additional arguments passed to methods.

- MARGIN:

  the array margin to be held fixed: see
  [apply](https://rdrr.io/r/base/apply.html), and note that `MARGIN = 0`
  may be useful.

## Value

`repeated()`: For a vector input, a logical vector of the same length as
`x`. For a data frame, a logical vector with one element for each row.
For a matrix or array, and when `MARGIN = 0`, a logical array with the
same dimensions and dimnames.

`whichRepeated()`: For a vector input, an integer vector giving the
indices of the repeated values. For a data frame, an integer vector
giving the indices of the repeated rows. For a matrix or array, an
integer vector giving the indices of the repeated elements across the
margin specified.

`repeats()` and its alias `non.unique()`: an object of the same type as
`x`, containing the repeated values (vector input), rows (data frame
input), or elements across the margin (matrix/array input).

## Details

The `repeated` functions determine which elements of a vector or data
frame are duplicates of elements with smaller subscripts. They are very
similar in functionality to
[duplicated](https://rdrr.io/r/base/duplicated.html) but instead mark
**all** duplicates (not just those after the first/last occurrence), and
do not have an `incomparables` argument.

These are generic functions with methods for vectors (including lists
and expressions), data frames and arrays (including matrices).

The array method calculates for each element of the sub-array specified
by `MARGIN` if the dimensions are identical to those for an earlier or
later element (in row-major order). This would most commonly be used to
find repeated rows (the default) or columns (with `MARGIN = 2`). Note
that `MARGIN = 0` returns an array of the same dimensionality attributes
as `x`.

`non.unique()` is an alias for `repeats()`.

## See also

[duplicated](https://rdrr.io/r/base/duplicated.html) and
[unique](https://rdrr.io/r/base/unique.html).

## Examples

``` r
# Repeated values in a vector
x <- c(1, 2, 3, 2, 1)

repeated(x)
#> [1]  TRUE  TRUE FALSE  TRUE  TRUE
whichRepeated(x)
#> [1] 1 2 4 5
repeats(x)
#> [1] 1 2 2 1

# Repeated rows in a data frame
df <- data.frame(
  x = c(1, 2, 1),
  y = c("a", "b", "a")
)

repeated(df)
#> [1]  TRUE FALSE  TRUE
repeats(df)
#>   x y
#> 1 1 a
#> 3 1 a

# Repeated rows/columns in a matrix
m <- cbind(
  c(1, 2),
  c(3, 4),
  c(1, 2)
)

repeated(m)
#> [1] FALSE FALSE
repeated(m, MARGIN = 2)
#> [1]  TRUE FALSE  TRUE
repeats(m, MARGIN = 2)
#>      [,1] [,2]
#> [1,]    1    1
#> [2,]    2    2

# non.unique() is an alias for repeats()
identical(repeats(x), non.unique(x))
#> [1] TRUE
```
