
<!-- README.md is generated from README.Rmd. Please edit that file -->

# suppr <img src="man/figures/logo.png" align="right" height="140" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/LJ-Jenkins/suppr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/LJ-Jenkins/suppr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Supplementary utilities and extensions to `R` that are idiomatic in
style.

## Installation

You can install the development version of suppr like so:

``` r
# install.packages("pak")
pak::pak("LJ-Jenkins/suppr")
```

## Reference

suppr provides miscellaneous supplementary functions for `R`: some are
simple wrappers that save a few keystrokes, others address common tasks,
and others provide new functionality through suppr versions of existing
`R` functions. All are intended to be idiomatic `R`, as if they were
part of the base R packages.

Much of suppr is directly amended from the `R` source code - all credit
to the authors for their great work!

#### Infix Operators

- `%''%` or `%""%` - if the lhs is ““, return the rhs, else return the
  lhs.
- `%!||%` - if the lhs is `NULL`, return the lhs, else return the rhs.
- `%0%` - if the lhs is of length `0`, return the rhs, else return the
  lhs.
- `%allin%`, `%anyin%`, `%nonein%`, `%onein%` and `%notin%` -
  `base::%in%` variants.

``` r
"" %''% "a"
#> [1] "a"
NULL %!||% "a"
#> NULL
c() %0% "a"
#> [1] "a"
c("a", "b") %allin% c("a", "b", "c")
#> [1] TRUE
c("a", "d") %anyin% c("a", "b", "c")
#> [1] TRUE
c("a", "d") %nonein% c("a", "b", "c")
#> [1] FALSE
c("a", "d") %onein% c("a", "b", "c")
#> [1] TRUE
c("a", "d") %notin% c("a", "b", "c")
#> [1] FALSE  TRUE
```

#### Character Operators

- `bckQuote()` - backquotes a string.
- `collapse()` and `collapse0()` - collapse a vector (or vectors) into a
  single string, optionally ‘recursively’ (in the sense of collapse each
  argument individually and then collapse the results).
- `listing()` - turns a character vector into a human-readable list (in
  the grammatical sense), optionally with quoting and/or a conjunction
  like “and” or “or”.
- `cat0()` - `base::cat()` with `sep = ""`.
- `grepf()`, `grepi()`, `greplf()`, `grepli()`, `grepvf()`, `grepvi()`,
  `subf()`, `subi()`, `gsubf()` and `gsubi()` - strongly typed variants
  of `base::grep()`, `base::grepl()`, `base::grepv()`, `base::sub()` and
  `base::gsub()` for the common `fixed = TRUE` and `ignore.case = TRUE`
  cases.
- `anyZchar()` - returns the `1`-based index of the first zero character
  element if any, otherwise `0`.
- `anyWS()` - returns the `1`-based index of the first all whitespace
  element if any, otherwise `0`. Optionally, zero character elements can
  be treated as all whitespace.

``` r
bckQuote(c("a", "b"))
#> [1] "`a`" "`b`"
collapse(c("a", "b", "c"))
#> [1] "abc"
listing(c("a", "b", "c"))
#> [1] "a, b and c."
cat0("a", "b", "c")
#> abc
greplf("foo", c("foo", "Foo", "bar"))
#> [1]  TRUE FALSE FALSE
grepli("foo", c("foo", "Foo", "bar"))
#> [1]  TRUE  TRUE FALSE
anyZchar(c("hi", "bye", " ", ""))
#> [1] 4
anyWS(c("hi", "bye", " ", ""))
#> [1] 3
```

#### Dots (`...`) Operators

- `checkDots()` - version of `base::chkDots()` that can error, not just
  warn.
- `dotsNames()` - returns the names of `...` arguments, returning all
  `""` if unnamed (like `methods::allNames()` but without evaluating
  `...`).
- `subDots()` - substitutes `...` arguments, returning a list of the
  substituted expressions.
- `dp1Dots()` - substitutes `...` arguments, before applying
  `base::deparse1()` to each, returning a character vector of the dot
  arguments.

``` r
f <- function(fn, ...) fn(...)
f(checkDots, a = 1, b = 2)
#> Error:
#> ! In f(checkDots, a = 1, b = 2) :
#>  extra named arguments 'a', 'b' are not allowed.
f(dotsNames, 1, 2)
#> [1] "" ""
f(subDots, x = a + b, y = a * b)
#> $x
#> a + b
#> 
#> $y
#> a * b
f(dp1Dots, x = a + b, y = a * b)
#>       x       y 
#> "a + b" "a * b"
```

#### Messages, Warnings and Errors

- `match.argv()` - matches function argument input to a list of valid
  values, not just strings like `base::match.arg()`.
- `stop2()`, `warning2()` and `stopifnot2()` - wrappers for
  `base::stop()`, `base::warning()` and `base::stopifnot()` that enable
  the inclusion of any call on the stack in the error message via a more
  flexible `call.` argument.
- `warningifnot()` - a wrapper for `stopifnot2()` that produces a
  warning instead of an error.
- `stopifnot.with()` - a wrapper for `stopifnot2()` that evaluates
  expressions in a specified environment/data object (like
  `base::with()`).

``` r
match.argv(1:3, list(c("a", "b"), list(1:3), 1:3))
#> [1] 1 2 3
f1 <- function(call.) stop2("error", call. = call.)
f2 <- function(call.) f1(call. = call.)
f2(call. = 2)
#> Error in `f2()`:
#> ! error
f1 <- function(call.) stopifnot2(all.equal(1, 2), call. = call.)
f2(call. = 1)
#> Error in `f1()`:
#> ! 1 and 2 are not equal:
#>   Mean relative difference: 1
warningifnot(1 == 2, 3 > 4, warn.all = TRUE, call. = FALSE)
#> Warning: 1 == 2 is not TRUE
#> Warning: 3 > 4 is not TRUE
stopifnot.with(data.frame(x = 1, y = 2), x == y)
#> Error:
#> ! with data.frame(x = 1, y = 2) : x == y is not TRUE
```

#### Classes

- `addClass()` - adds a class/classes to an object, either preserving
  existing classes (by prepending given classes), or overwriting
  existing classes, and returning the object.
- `isVector()` - wrapper for `base::is.vector()` that allows multiple
  classes to be specified.
- `is.Date()`, `is.datetype()`, `is.POSIXt()`, `is.POSIXct()` and
  `is.POSIXlt()` - date type predicates.
- `is.boolean()`, `is.string()` and `nzstring()` - predicates for common
  scalar values.

``` r
x <- structure(1:3, class = c("a", "b"))
class(addClass(x, "my_new_class"))
#> [1] "my_new_class" "a"            "b"
isVector(1:3, c("character", "list", "numeric"))
#> [1] TRUE
is.Date(Sys.Date())
#> [1] TRUE
is.datetype(Sys.Date())
#> [1] TRUE
is.POSIXt(Sys.time())
#> [1] TRUE
is.POSIXct(Sys.time())
#> [1] TRUE
is.POSIXlt(Sys.time())
#> [1] FALSE
is.boolean(TRUE)
#> [1] TRUE
is.string("")
#> [1] TRUE
nzstring("")
#> [1] FALSE
```

#### Data Wrangling

##### Even/odd

- `is.even()` and `is.odd()` - returns logical vector indicating if
  elements are even or odd, respectively.

``` r
is.even(c(-2:2, NA))
#> [1]  TRUE FALSE  TRUE FALSE  TRUE FALSE
is.odd(c(1, 2, NA, Inf), noparity.na = TRUE)
#> [1]  TRUE FALSE    NA    NA
```

##### Which min/max

- `whichMin()` and `whichMax()` - wrappers for `base::which.min()` and
  `base::which.max()` that offer a new `loc` argument to alternatively
  return the first, last, or all, minima/maxima.

``` r
x <- c(1, 2, 3, 1, 2, 3)
whichMin(x, loc = "first")
#> [1] 1
whichMin(x, loc = "last")
#> [1] 4
whichMin(x, loc = "all")
#> [1] 1 4
```

##### NA’s

- `is.nonfinite()` (and alias `is.nf()`) - returns a logical vector
  indicating which elements are non-finite (i.e., `NA`, `NaN`, `Inf` or
  `-Inf`).
- `anyNF()` - returns the `1`-based index of the first non-finite value
  if any, otherwise `0`.
- `whichNA()` - returns the indices of `NA` values.
- `setNA()` - sets given indices to `NA`.
- `na.vector()` - returns a vector of `NA` values of a given length and
  type.
- `na.refill()` - for an object that has had `NA` values removed by
  `stats::na.omit()`, refill the `NA` values at the original indices,
  returning an object of the same size as the original.

``` r
is.nonfinite(c(1, 2, NA, Inf))
#> [1] FALSE FALSE  TRUE  TRUE
anyNF(c(1, 2, NA, Inf))
#> [1] 3
whichNA(c(1, 2, NA, Inf))
#> [1] 3
x <- c(1, 2, 3, 4)
setNA(x, c(1, 3))
#> [1] NA  2 NA  4
na.vector(5, type = "character")
#> [1] NA NA NA NA NA
x <- stats::na.omit(c(1, 2, NA, 4))
x
#> [1] 1 2 4
#> attr(,"na.action")
#> [1] 3
#> attr(,"class")
#> [1] "omit"
na.refill(x)
#> [1]  1  2 NA  4
#> attr(,"na.action")
#> [1] 3
#> attr(,"class")
#> [1] "refilled"
```

##### Wholeness

- `is.integerish()` - returns `TRUE` if elements are all ‘integerish’ or
  `FALSE` if not.
- `is.whole()` and `is.wholenumber()` - returns a single `TRUE`/`FALSE`,
  or a logical vector, if elements are all whole numbers or not
  (according to an input tolerance), respectively.

``` r
is.integerish(c(1, 1.000000001))
#> [1] FALSE
is.whole(c(1, 1.000000001))
#> [1] TRUE
is.wholenumber(c(1, 2, 3.5, 4))
#> [1]  TRUE  TRUE FALSE  TRUE
```

##### Duplicates

- `repeated()` - returns a logical vector indicating which elements are
  repeated (analogous to
  `duplicated(x, fromLast = FALSE) | duplicated(x, fromLast = TRUE)`).
- `whichRepeated()` - returns the indices of repeated elements.
- `repeats()` - returns repeated elements.

``` r
x <- c(1, 2, 3, 1, 2, 3, 4, 5)
repeated(x)
#> [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE
whichRepeated(x)
#> [1] 1 2 3 4 5 6
repeats(x)
#> [1] 1 2 3 1 2 3
```

##### Remove elements

- `rm.first()` and `rm.last()` - removes the first or last ‘n’ elements
  of a vector, respectively.

``` r
x <- 1:10
rm.first(x, 3)
#> [1]  4  5  6  7  8  9 10
rm.last(x, 3)
#> [1] 1 2 3 4 5 6 7
```

#### Utilities

- `predapply()` - applies a predicate function to each element of a
  vector, returning a logical vector. Option to reduce the output to a
  single `TRUE` or `FALSE` value.
- `empty.list()` - wrapper for `base::vector("list", length)` that
  returns an empty list of a given length.
- `path()` - wrapper for `base::file.path()` and
  `base::normalizePath()`. Option to specify if the path is on a shared
  drive, prepending `.Platform$file.sep` if so.
- `dims()` - returns the dimensions of an object, or `c(length(x), 0L)`
  if it has no dim attribute.
- `enumerate()` - returns a list of lists - one for each element of a
  vector, with the corresponding positional list containing the vector
  element, index and name.
- `libraries()` and `requires()` - wrappers for `base::library()` and
  `base::require()` that can load multiple packages at once, either from
  names, strings, or character vectors.

``` r
predapply(1:10, is.even, reduce = "any")
#> [1] TRUE
empty.list(2)
#> [[1]]
#> NULL
#> 
#> [[2]]
#> NULL
path("mysd", "mydir", sharedDrive = TRUE, mustWork = FALSE)
#> [1] "\\\\mysd\\mydir"
dims(1:10)
#> [1] 10  0
enumerate(c("a", el = "b"))
#> [[1]]
#> [[1]]$idx
#> [1] 1
#> 
#> [[1]]$val
#> [1] "a"
#> 
#> [[1]]$name
#> [1] ""
#> 
#> 
#> [[2]]
#> [[2]]$idx
#> [1] 2
#> 
#> [[2]]$val
#> [1] "b"
#> 
#> [[2]]$name
#> [1] "el"
libraries(stats, "utils")
x <- c("stats", "utils")
requires(x, "methods", character.only = TRUE)
```

## Performance

Functions should have similar overhead to their nearest `R` equivalents.
Most of the ‘data wrangling’ functions (and some others) have been
implemented in `C` and typically perform equivalently to their `R`
counterparts.

## Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on
[GitHub](https://github.com/LJ-Jenkins/suppr/issues).

## Code of Conduct

Please note that the suppr project is released with a [Contributor Code
of
Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
