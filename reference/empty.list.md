# Create an Empty list of Given Length

For a given length, create an empty list of that length.

## Usage

``` r
empty.list(length = 0L)
```

## Arguments

- length:

  integer, specified length of the output list.

## Value

an empty list of given length.

## Details

This is a simple wrapper of `vector("list", length)` with a clearer
naming convention.

## See also

[vector](https://rdrr.io/r/base/vector.html),
[na.vector](https://lj-jenkins.github.io/suppr/reference/na.vector.md)

## Examples

``` r
empty.list()
#> list()
empty.list(5L)
#> [[1]]
#> NULL
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> NULL
#> 
#> [[4]]
#> NULL
#> 
#> [[5]]
#> NULL
#> 
empty.list(length = 3L)
#> [[1]]
#> NULL
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> NULL
#> 
```
