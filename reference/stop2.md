# Display Warnings and Errors with Call Information

Wrappers around [stop](https://rdrr.io/r/base/stop.html) and
[warning](https://rdrr.io/r/base/warning.html) that enable the `call.`
argument to derive a call from the stack.

## Usage

``` r
stop2(..., call. = TRUE, domain = NULL)

warning2(..., call. = TRUE, domain = NULL)
```

## Arguments

- ...:

  zero or more objects which can be coerced to character (and which are
  pasted together with no separator).

- call.:

  call, logical, integer, or environment. logical, indicating if the
  calling call should become part of the error message with same
  semantics as [stop](https://rdrr.io/r/base/stop.html). integer,
  specifying how many calls to go 'up' the call stack to extract a call
  for the message. A value of `0` will give the call to `stop2()`
  itself, `1` will give the call of the caller, and so on. Numeric
  values are coerced to integer and absolute values are taken. Values
  outside either boundary of the call stack will be clamped to the
  nearest boundary. environment, which will be matched against the
  calling stack and the corresponding call will be shown.

- domain:

  see [gettext](https://rdrr.io/r/base/gettext.html). If `NA`, messages
  will not be translated.

## Value

Called for side effects only.

## Details

These functions derive a call to be displayed and then construct their
own 'simple' conditions using
[simpleError](https://rdrr.io/r/base/conditions.html) and
[simpleWarning](https://rdrr.io/r/base/conditions.html).

If a condition object is given as the first argument, it will be treated
in the same way as the base functions do, by warning that other
arguments will be ignored and then signalling the condition.

See [stop](https://rdrr.io/r/base/stop.html) and
[warning](https://rdrr.io/r/base/warning.html) for full details.

## See also

[stopifnot2](https://lj-jenkins.github.io/suppr/reference/stopifnot2.md)
and
[stopifnot.with](https://lj-jenkins.github.io/suppr/reference/stopifnot.with.md)
for validations with call information.

## Examples

``` r
f1 <- function(call.) stop2("error", call. = call.)
f2 <- function(call.) f1(call. = call.)
f <- function(call.) f2(call. = call.)

try(f(call. = FALSE))
#> Error : error
try(f(call. = TRUE))
#> Error in f1(call. = call.) : error

try(f(call. = 0))
#> Error in stop2("error", call. = call.) : error
try(f(call. = 1))
#> Error in f1(call. = call.) : error
try(f(call. = 2))
#> Error in f2(call. = call.) : error

f <- function() {
  e <- environment()
  f1(call. = e)
}

try(f())
#> Error in f() : error

f1 <- function(call.) warning2("warning", call. = call.)
try(f())
#> Warning: warning
```
