# Infix Operator Helpers

Infix operators for common tasks.

`%''%` and `%""%` return the right-hand side if the left-hand side is an
empty string (`""`).

`%!||%` returns the right-hand side if the left-hand side is not `NULL`.

`%0%` returns the right-hand side if the left-hand side has length 0.

`%allin%` returns `TRUE` if all elements of the left-hand side are in
the right-hand side.

`%anyin%` returns `TRUE` if any elements of the left-hand side are in
the right-hand side.

`%nonein%` returns `TRUE` if none of the elements of the left-hand side
are in the right-hand side.

`%onein%` returns `TRUE` if exactly one element of the left-hand side is
in the right-hand side.

`%notin%` returns `TRUE` for elements of the left-hand side that are not
in the right-hand side. This is implemented in the same way as base
**R** and will be replaced by the base version in the **R** versions
that have it.

## Usage

``` r
lhs %''% rhs

lhs %""% rhs

lhs %!||% rhs

lhs %0% rhs

x %allin% table

x %anyin% table

x %nonein% table

x %onein% table

x %notin% table
```

## Arguments

- lhs:

  left-hand side object.

- rhs:

  right-hand side object.

- x:

  vector or `NULL`: the values to be matched. [Long
  vectors](https://rdrr.io/r/base/LongVectors.html) are supported.

- table:

  vector or `NULL`: the values to be matched against. [Long
  vectors](https://rdrr.io/r/base/LongVectors.html) are not supported.

## Value

For the non-`%*in%` operators, either the left-hand side or right-hand
side, depending on the result of the operator.

For `%allin%`, `%anyin%`, `%nonein%`, and `%onein%` a single logical
value (or empty logical if `x` has length `0`) is returned. For
`%notin%`, a logical vector of the same length as `x` is returned.

## Details

The `%*in%` operators follow the semantics of `%in%` for `NULL` values:

- Singular `NULL`'s on the lhs always returns a length `0` logical
  vector.

- `NULL` elements are not considered equal to singular `NULL`'s so will
  give a `TRUE` for `%nonein%` and `%notin%` and `FALSE` for `%allin%`,
  `%anyin%` and `%onein%`.

See `%in%` semantics:

    NULL %in% NULL
    #> logical(0)
    NULL %in% list(1, NULL)
    #> logical(0)
    list(1, NULL) %in% NULL
    #> [1] FALSE FALSE
    list(1, NULL) %in% list(1, NULL)
    #> [1] TRUE TRUE

## Examples

``` r
"" %''% "default" # if lhs is "", return rhs
#> [1] "default"

NULL %!||% "default" # if lhs is NULL, return *lhs* (NULL)
#> NULL
# useful for when using NULL as a default value
# or when using elements of a list that may be NULL
# e.g.,
lst <- list(a = 1, b = 2)
x <- lst$nope %!||% mean(lst$nope) # returns NULL

integer(0) %0% 5L # if lhs is length 0, return rhs
#> [1] 5

c(1, 2, 3) %allin% c(1, 2, 3, 4) # TRUE
#> [1] TRUE

c(1, 2, 3) %anyin% c(1, 2, 3, 4) # TRUE
#> [1] TRUE

c(1, 2, 3) %nonein% c(4, 5, 6) # TRUE
#> [1] TRUE

c(1, 2, 3) %onein% c(1, 4, 5) # TRUE
#> [1] TRUE

c(1, 2, 3) %notin% c(4, 5, 6) # TRUE
#> [1] TRUE TRUE TRUE
```
