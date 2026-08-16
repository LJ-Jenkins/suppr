# Ensure the Truth of R Expressions with Call Information

Wrapper around [stopifnot](https://rdrr.io/r/base/stopifnot.html) that
leaves only the `...` argument and adds a `call.` argument that shows a
call in the message that is derived from the call stack.
`warningifnot()` implements the same functionality but produces a
warning instead of an error.

## Usage

``` r
stopifnot2(..., call. = TRUE)

warningifnot(..., warn.all = FALSE, call. = TRUE)
```

## Arguments

- ...:

  any number of **R** expressions, which should each evaluate to (a
  logical vector of [all](https://rdrr.io/r/base/all.html))
  [TRUE](https://rdrr.io/r/base/logical.html). If named, the names will
  be used in lieu of the default error/warning message.

- call.:

  call, logical, integer, or environment. logical, indicating if the
  calling call should become part of the error message with same
  semantics as [stop](https://rdrr.io/r/base/stop.html). integer,
  specifying how many calls to go 'up' the call stack to extract a call
  for the message. A value of `0` will give the call to
  [`stop2()`](https://lj-jenkins.github.io/suppr/reference/stop2.md)
  itself, `1` will give the call of the caller, and so on. Numeric
  values are coerced to integer and absolute values are taken. Values
  outside either boundary of the call stack will be clamped to the
  nearest boundary. environment, which will be matched against the
  calling stack and the corresponding call will be shown.

- warn.all:

  logical, indicating if all failed expressions should produce warnings,
  or only the first failed expression. Default is `FALSE`, which means
  only the first failed expression will produce a warning.

## Value

Called for side effects only.

## Details

If any of the expressions are not [all](https://rdrr.io/r/base/all.html)
`TRUE`, [stop](https://rdrr.io/r/base/stop.html) or
[warning](https://rdrr.io/r/base/warning.html) is called, producing an
error/warning message indicating the first (or all, if `warn.all = TRUE`
for `warningifnot()`) expression which was not
([all](https://rdrr.io/r/base/all.html)) true. See
[stopifnot](https://rdrr.io/r/base/stopifnot.html) for full details.

Special care must be taken for handlers on the call stack, as they may
affect the call displayed in the error or warning message. In such
instances, passing an environment to `call.` may be helpful.

## See also

[stopifnot.with](https://lj-jenkins.github.io/suppr/reference/stopifnot.with.md)
for a data-masked version of this function.

## Examples

``` r
f1 <- function(call.) stopifnot2(1 == 2, call. = call.)
f2 <- function(call.) f1(call. = call.)
f <- function(call.) f2(call. = call.)

try(f(call. = FALSE))
#> Error : 1 == 2 is not TRUE
try(f(call. = TRUE))
#> Error in f1(call. = call.) : 1 == 2 is not TRUE

try(f(call. = 0))
#> Error in stopifnot2(1 == 2, call. = call.) : 1 == 2 is not TRUE
try(f(call. = 1))
#> Error in f1(call. = call.) : 1 == 2 is not TRUE
try(f(call. = 2))
#> Error in f2(call. = call.) : 1 == 2 is not TRUE

f <- function() {
  e <- environment()
  f1(call. = e)
}

try(f())
#> Error in f() : 1 == 2 is not TRUE

try(stopifnot2(all.equal(1, 2)))
#> Error in eval(expr, envir) : 1 and 2 are not equal:
#>   Mean relative difference: 1

warningifnot(1 == 2, 2 == 3)
#> Warning: 1 == 2 is not TRUE
warningifnot(1 == 2, 2 == 3, warn.all = TRUE)
#> Warning: 1 == 2 is not TRUE
#> Warning: 2 == 3 is not TRUE
```
