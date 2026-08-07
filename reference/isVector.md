# Check if One of Given Vector Types

Wrapper around [is.vector](https://rdrr.io/r/base/vector.html) that
allows the `mode` argument to accept a character vector of multiple
types. `TRUE` is returned if the given object is **any** of the given
types.

## Usage

``` r
isVector(x, mode = "any")
```

## Arguments

- x:

  an **R** object.

- mode:

  character string (or chr vector) naming an atomic mode or `"list"` or
  `"expression"` or `"any"`. When using `"any"`, it must be given on its
  own.

## Value

`TRUE` or `FALSE`.

## Details

See [is.vector](https://rdrr.io/r/base/vector.html) for full details and
for the types that can be checked with `mode`.

## See also

[is.vector](https://rdrr.io/r/base/vector.html),
[typeof](https://rdrr.io/r/base/typeof.html).

## Examples

``` r
x <- c(a = 1, b = 2)
isVector(x) # default `mode` is "any"
#> [1] TRUE

# "any" can't be given with other types.
try(isVector(x, mode = c("numeric", "any")))
#> Error in isVector(x, mode = c("numeric", "any")) : 
#>   In argument ‘mode’: 'any' cannot be given with other types.

# `TRUE` is returned if *any* of the types are matched.
isVector(x, mode = c("character", "list", "logical", "numeric"))
#> [1] TRUE
isVector(x, mode = c("character", "list", "logical"))
#> [1] FALSE
```
