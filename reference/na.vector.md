# Create a vector of NA's

For a given atomic mode and length, create a vector of NA's.

## Usage

``` r
na.vector(
  length = 1L,
  type = c("logical", "integer", "double", "character", "complex", "numeric", "list")
)
```

## Arguments

- length:

  integer, length of the output vector.

- type:

  character string naming an atomic type that has an equivalent NA value
  (i.e., not [raw](https://rdrr.io/r/base/raw.html)).

## Value

vector of given mode and length filled with NA values.

## Details

This function also offers a `"list"` type, which gives a list of single
(logical) `NA` values. To initialize an empty list of a given length,
use
[empty.list](https://lj-jenkins.github.io/suppr/reference/empty.list.md)
instead.

## See also

[vector](https://rdrr.io/r/base/vector.html),
[whichNA](https://lj-jenkins.github.io/suppr/reference/whichNA.md),
[setNA](https://lj-jenkins.github.io/suppr/reference/setNA.md)

## Examples

``` r
na.vector(5L)
#> [1] NA NA NA NA NA
x <- na.vector(3L, "character")
class(x)
#> [1] "character"

x <- complex(1:5, 6:10)
y <- na.vector(type = typeof(x), length = length(x))
class(y)
#> [1] "complex"
length(y)
#> [1] 5
```
