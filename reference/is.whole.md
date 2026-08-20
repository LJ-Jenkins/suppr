# Are vectors whole or integer-like?

Tests if numeric vectors are integerish, or whole according to a given
tolerance.

`is.whole()` and `is.integerish()` check if the entire vector is whole
or integerish, whilst `is.wholenumber()` checks element-wise for
wholeness.

## Usage

``` r
is.whole(x, tol = .Machine$double.eps^0.5)

is.wholenumber(x, tol = .Machine$double.eps^0.5)

is.integerish(x)
```

## Arguments

- x:

  a logical, numeric, or complex vector.

- tol:

  numeric tolerance for wholeness.

## Value

For `is.whole()` and `is.integerish()` a single `TRUE` or `FALSE`.

For `is.wholenumber()`, a logical vector of the same length as `x`.

## Details

`is.integerish()` tests if a vector is integerish by evaluating if the
remainder of the [absolute](https://rdrr.io/r/base/MathFun.html) value
of `x` divided by `1` is 'equal' to `0.0` in the `C` code.

`is.whole()` and `is.wholenumber()` test for wholeness by evaluating if
the [absolute](https://rdrr.io/r/base/MathFun.html) value of `x` minus
its rounded value is less than the given tolerance.

Both `is.integerish()` and `is.whole()` ignore non-finite values (i.e.,
treat them as integerish/whole) and only test finite values for
integerishness or wholeness. If you do not want this behavior, use
[anyNF](https://lj-jenkins.github.io/suppr/reference/is.nonfinite.md),
e.g., `!anyNF(x) && is.whole(x)`.

`is.wholenumber()` returns `NA` for non-finite elements.

## See also

is.integerish,
[anyNF](https://lj-jenkins.github.io/suppr/reference/is.nonfinite.md)

## Examples

``` r
is.integerish(1)
#> [1] TRUE
is.integerish(1.0)
#> [1] TRUE
is.integerish(1.0000000001)
#> [1] FALSE
is.integerish(1.0000000000000001)
#> [1] TRUE

is.wholenumber(1)
#> [1] TRUE
x <- c(1.0, 1.0000001, 1.0000000001)
is.wholenumber(x)
#> [1]  TRUE FALSE  TRUE
is.whole(x)
#> [1] FALSE


# ignores non-finite values:
is.integerish(c(Inf, -Inf, NaN, NA))
#> [1] TRUE
is.whole(c(Inf, -Inf, NaN, NA))
#> [1] TRUE

# non-finite values flag as NA:
is.wholenumber(c(Inf, -Inf, NaN, NA))
#> [1] NA NA NA NA

# all error on non-numeric vector inputs:
try(is.integerish("1"))
#> Error in is.integerish("1") : Input must be a logical or numeric vector.
try(is.whole("1"))
#> Error in is.whole("1") : 
#>   Input must be a logical, numeric or complex vector.
try(is.wholenumber("1"))
#> Error in is.wholenumber("1") : 
#>   Input must be a logical, numeric or complex vector.
```
