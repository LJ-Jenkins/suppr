# Backquote Text

Backquote text by combining with backticks (“).

## Usage

``` r
bckQuote(x)
```

## Arguments

- x:

  an **R** object, to be coerced to a character vector.

## Value

A character vector of the same length as x (after any coercion).

## See also

[Quotes](https://rdrr.io/r/base/Quotes.html),
[dQuote](https://rdrr.io/r/base/sQuote.html) and
[sQuote](https://rdrr.io/r/base/sQuote.html).

## Examples

``` r
bckQuote("example")
#> [1] "`example`"
bckQuote(c("one", "two", "three"))
#> [1] "`one`"   "`two`"   "`three`"
bckQuote(123)
#> [1] "`123`"
```
