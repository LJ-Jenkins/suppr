# Get `...` Arguments as Expressions/Character and Check for Extraneous Arguments

`dotsNames` returns the names of the `...` arguments, or a character
vector of empty strings if they are unnamed.

`subDots` returns the `...` arguments as a list of expressions.

`dp1Dots` returns the `...` arguments as a character vector of deparsed
expressions.

`checkDots` errors or warns about extraneous arguments in the `...` of
its caller.

## Usage

``` r
dotsNames(...)

subDots(...)

dp1Dots(..., collapse = " ", width.cutoff = 500L)

checkDots(..., error = TRUE, which.call = -1, allowed = character(0))
```

## Arguments

- ...:

  "the dots", as passed from the caller.

- collapse:

  a string, passed to [paste](https://rdrr.io/r/base/paste.html)`()`.

- width.cutoff:

  integer in `[20, 500]` determining the cutoff (in bytes) at which
  line-breaking is tried.

- error:

  a logical value indicating whether to throw an error (`TRUE`) or a
  warning (`FALSE`) for extraneous arguments.

- which.call:

  passed to [sys.call](https://rdrr.io/r/base/sys.parent.html)`()`. A
  caller may use -2 if the message should mention its caller.

- allowed:

  character vector of named elements in `...` which are "allowed" and
  hence do not cause an error or warning.

## Value

For `dotsNames`, a character vector of the names of the `...` arguments.

For `subDots`, a list of expressions.

For `dp1Dots`, a character vector of deparsed expressions.

For `checkDots`, `NULL` (invisibly), called for its side effects.

## Details

`dotsNames` is an implementation of allNames for `...` arguments.

`subDots` is a simple wrapper for `as.list(substitute(...()))`.

`dp1Dots` applies [deparse1](https://rdrr.io/r/base/deparse.html) to
each element of `subDots(...)`.

`checkDots` is a variation of
[chkDots](https://rdrr.io/r/base/chkDots.html) for use in functions that
want to error in case of extraneous arguments, not just warn.
`checkDots` also shows whether extraneous arguments are named or
unnamed, and if unnamed, the message will show the deparsed expressions
of the unnamed arguments. See examples.

## See also

[...](https://rdrr.io/r/base/dots.html),
[chkDots](https://rdrr.io/r/base/chkDots.html),
[stop](https://rdrr.io/r/base/stop.html),
[warning](https://rdrr.io/r/base/warning.html),
[substitute](https://rdrr.io/r/base/substitute.html),
[deparse1](https://rdrr.io/r/base/deparse.html).

## Examples

``` r
f <- function(...) dotsNames(...)
f(1, 2, mean(1:10))
#> [1] "" "" ""
f(a = 1, b = 2, mean(1:10))
#> [1] "a" "b" "" 

f <- function(...) subDots(...)
f(a = 1, b = 2, mean(1:10))
#> $a
#> [1] 1
#> 
#> $b
#> [1] 2
#> 
#> [[3]]
#> mean(1:10)
#> 

f <- function(...) dp1Dots(...)
f(a = 1, b = 2, mean(1:10))
#>            a            b              
#>          "1"          "2" "mean(1:10)" 

f <- function(x, ...) checkDots(..., allowed = "b")
f(1, b = 1)
try(f(1, a = 1, b = 2, mean(1:10)))
#> Error : In f(1, a = 1, b = 2, mean(1:10)) :
#>  extra named argument ‘a’ is not allowed.
#>  extra unnamed argument ‘mean(1:10)’ is not allowed.
```
