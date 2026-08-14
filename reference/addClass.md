# Add a Class to an Object

Add a class to an object, either appending to, or replacing, the
existing class vector.

## Usage

``` r
addClass(x, class, prepend = TRUE)
```

## Arguments

- x:

  an **R** object.

- class:

  character vector, or object coercible to character, of one or more
  class names to add.

- prepend:

  logical. If `TRUE` the new class(es) are prepended to the existing
  class vector. If `FALSE`, the class vector is replaced entirely.

## Value

The input object `x` with its class attribute updated.

## Details

With `prepend = TRUE`, `addClass()` is equivalent to:

    class(x) <- c(class, class(x))
    x

With `prepend = FALSE`:

    class(x) <- class
    x

## See also

[class](https://rdrr.io/r/base/class.html),
[inherits](https://rdrr.io/r/base/class.html), is.

## Examples

``` r
x <- structure(1, class = "base_class")
y <- addClass(x, c("new_class", "another_class"))
class(y)
#> [1] "new_class"     "another_class" "base_class"   

y <- addClass(x, c("new_class", "another_class"), prepend = FALSE)
class(y)
#> [1] "new_class"     "another_class"
```
