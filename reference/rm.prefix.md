# Remove a prefix or suffix

Remove a prefix or suffix from a character vector.

## Usage

``` r
rm.prefix(x, prefix)

rm.suffix(x, suffix)
```

## Arguments

- x:

  A character vector.

- prefix, suffix:

  A single string.

## Value

`x` is returned with the specified prefix or suffix removed from each
element where it was present.

## Details

Elements without the specified prefix or suffix will remain unchanged.
An error will occur if `prefix` or `suffix` is `NA`.

## Note

Both `x` and `prefix`/`suffix` are translated to UTF-8 before
processing.

## See also

[startsWith](https://rdrr.io/r/base/startsWith.html),
[endsWith](https://rdrr.io/r/base/startsWith.html)

## Examples

``` r
x <- c("x_apple", "x_banana", "x_cherry")
rm.prefix(x, "x_")
#> [1] "apple"  "banana" "cherry"
rm.suffix(x, "_cherry")
#> [1] "x_apple"  "x_banana" "x"       
```
