# Ensure the Truth of R Expressions in a Data Environment

Wrapper around
[stopifnot2](https://lj-jenkins.github.io/suppr/reference/stopifnot2.md)
that evaluates **R** expressions in an environment constructed from
`data`.

## Usage

``` r
stopifnot.with(data, ..., call. = TRUE)
```

## Arguments

- data:

  data to use for constructing an environment. This may be an
  `environment`, a `list`, a `data.frame`, or an `integer` as in
  `sys.call`.

- ...:

  any number of **R** expressions, which should each evaluate to (a
  logical vector of all) [TRUE](https://rdrr.io/r/base/logical.html). If
  named, the names will be used in lieu of the default error message.

- call.:

  call, logical, integer, or environment. logical, indicating if the
  calling call should become part of the error message with same
  semantics as [stop](https://rdrr.io/r/base/stop.html). integer,
  specifying how many calls to go 'up' the call stack to extract a call
  for the error message. A value of `0` will give the call to
  [`stop2()`](https://lj-jenkins.github.io/suppr/reference/stop2.md)
  itself, `1` will give the call of the caller, and so on. Numeric
  values are coerced to integer and absolute values are taken. Values
  outside either boundary of the call stack will be clamped to the
  nearest boundary. environment, which will be matched against the
  calling stack and the corresponding call will be shown.

## Details

If any of the expressions are not [all](https://rdrr.io/r/base/all.html)
`TRUE`, [stop](https://rdrr.io/r/base/stop.html) is called, producing an
error message indicating the first expression which was not
([all](https://rdrr.io/r/base/all.html)) true. See
[stopifnot](https://rdrr.io/r/base/stopifnot.html) and
[stopifnot2](https://lj-jenkins.github.io/suppr/reference/stopifnot2.md)
for full details.

Special care must be taken for handlers on the call stack, as they may
affect the call displayed in the error or warning message. In such
instances, passing an environment to `call.` may be helpful.

## See also

[stop2](https://lj-jenkins.github.io/suppr/reference/stop2.md),
[warning2](https://lj-jenkins.github.io/suppr/reference/stop2.md) and
[message2](https://lj-jenkins.github.io/suppr/reference/stop2.md) for
errors, warnings and messages with call information.

## Examples

``` r
try(stopifnot.with(data.frame(x = 1, y = 2), x == y))
#> Error in eval(expr, envir) : 
#>   with data.frame(x = 1, y = 2) : x == y is not TRUE
try(stopifnot.with(list(x = 1, y = 2), all.equal(x, y)))
#> Error in eval(expr, envir) : 
#>   with list(x = 1, y = 2) : x and y are not equal:
#>   Mean relative difference: 1

f1 <- function(x, ..., call.) stopifnot.with(x, ..., call. = call.)
f2 <- function(x, ..., call.) f1(x, ..., call. = call.)
f <- function(x, ..., call.) f2(x, ..., call. = call.)

x <- list(a = 1, b = 2)
try(f(x, a == b, call. = FALSE))
#> Error : with x : a == b is not TRUE
try(f(x, a == b, call. = TRUE))
#> Error in f1(x, ..., call. = call.) : with x : a == b is not TRUE

try(f(x, a == 1, b < 1, call. = 0))
#> Error in stopifnot.with(x, ..., call. = call.) : 
#>   with x : b < 1 is not TRUE
try(f(x, b > 3, call. = 1))
#> Error in f1(x, ..., call. = call.) : with x : b > 3 is not TRUE
try(f(x, a != 1, call. = 2))
#> Error in f2(x, ..., call. = call.) : with x : a != 1 is not TRUE

f <- function(x, ...) {
  e <- environment()
  f1(x, ..., call. = e)
}

try(f(x, a == 1, b < 1))
#> Error in f(x, a == 1, b < 1) : with x : b < 1 is not TRUE
```
