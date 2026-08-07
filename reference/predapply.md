# Apply a predicate function over a list or vector

Returns a logical of the same length as `X`, each element of which is
the result of applying predicate `FUN` to the corresponding element of
`X.`

## Usage

``` r
predapply(X, FUN, ..., reduce = NULL, na.as = NA)
```

## Arguments

- X:

  a vector (atomic or list) or an expression object. Other objects
  (including classed objects) will be coerced by
  [`as.list`](https://rdrr.io/r/base/list.html).

- FUN:

  a predicate function to be applied to each element of `X` that returns
  a single logical value.

- ...:

  optional arguments to `FUN`.

- reduce:

  `NULL` or one of `"all"`, `"any"`, or `"none"`. When non-`NULL`, the
  output logical vector is reduced to a single boolean value using
  [all](https://rdrr.io/r/base/all.html),
  [any](https://rdrr.io/r/base/any.html) or `"none"` (`all(!logi)`).

- na.as:

  logical value to return for `NA` values in the output logical vector
  (`NA`, `TRUE` or `FALSE`).

## Value

logical vector or boolean if `reduce` is non-`NULL`.

## Details

`na.as` is most meaningful when `reduce` is non-`NULL`, as it allows
control flow calls (e.g., `if (predapply(...))`) to proceed without
error. See examples.

## See also

[apply](https://rdrr.io/r/base/apply.html),
[lapply](https://rdrr.io/r/base/lapply.html),
[mapply](https://rdrr.io/r/base/mapply.html),
[all](https://rdrr.io/r/base/all.html),
[any](https://rdrr.io/r/base/any.html).

## Examples

``` r
x <- list(a = 1, b = 2, c = NA)
predapply(x, is.numeric)
#>     a     b     c 
#>  TRUE  TRUE FALSE 
predapply(x, is.numeric, reduce = "any")
#> [1] TRUE

x <- list(a = 1, b = 2, c = 3)
predapply(x, is.numeric, reduce = "all")
#> [1] TRUE

x <- list(a = "1", b = "2", c = "3")
predapply(x, is.numeric, reduce = "none")
#> [1] TRUE

x <- c(1, 2, NA)
predapply(x, function(x) x > 0)
#> [1] TRUE TRUE   NA
predapply(x, function(x) x > 0, reduce = "all")
#> [1] NA
predapply(x, function(x) x > 0, reduce = "all", na.as = TRUE)
#> [1] TRUE
```
