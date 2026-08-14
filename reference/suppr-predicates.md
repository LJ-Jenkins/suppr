# Value Predicates for Common Object Types

`is.boolean` checks if an object is a single logical value (`TRUE` or
`FALSE`).

`is.string` checks if an object is a single (non-NA) character string.

`nzstring` checks if an object is a single (non-NA) non-empty character
string.

## Usage

``` r
is.boolean(x)

is.string(x)

nzstring(x)
```

## Arguments

- x:

  an object to be tested.

## Value

`TRUE` or `FALSE`.

## Details

The `string` helpers differ slightly from what you *may* expect from
base **R** as `NA_character_` is not considered a string. For example:

    nzchar(NA_character_)
    #> [1] TRUE
    is.string(NA_character_)
    #> [1] FALSE
    nzstring(NA_character_)
    #> [1] FALSE

## Examples

``` r
is.boolean(TRUE)
#> [1] TRUE
is.boolean(NA)
#> [1] FALSE

is.string("hello")
#> [1] TRUE
is.string(NA_character_)
#> [1] FALSE
is.string("")
#> [1] TRUE

nzstring("")
#> [1] FALSE
```
