# Argument Verification

`match.argv()` matches a given argument against a list of candidate
values as specified by `choices`.

## Usage

``` r
match.argv(arg, choices, match.fn = NULL)
```

## Arguments

- arg:

  an **R** object.

- choices:

  a list of candidate values to match against that will be extracted
  with `[[`.

- match.fn:

  a function to use for matching the argument against the choices. This
  function must take two arguments: the first is the argument to be
  matched, and the second is a candidate value extracted from `choices`
  with `[[`. It must return a single `TRUE` or `FALSE` value indicating
  whether the argument matches the candidate value.

  If `NULL`, the default matching function is used, which checks for
  equality using[`identical()`](https://rdrr.io/r/base/identical.html)
  with `ignore.environment = TRUE`.

## Value

If `arg` is identical to `choices`, then the first element of `arg` is
returned. If `arg` is matched against a candidate value in `choices`,
then `arg` is returned. If no match is found, an error is thrown.

## Details

If `arg` is the same as `choices`, then the first element of `arg` is
returned. This check is done using
[`identical()`](https://rdrr.io/r/base/identical.html) with
`ignore.environment = TRUE`, regardless of the `match.fn` argument.

In the one-argument form `match.argv(arg)`, the `choices` are obtained
from a default setting for the formal argument `arg` of the function
from which `match.argv` was called.

## See also

[match.arg](https://rdrr.io/r/base/match.arg.html),
[match.call](https://rdrr.io/r/base/match.call.html),
[match.fun](https://rdrr.io/r/base/match.fun.html).

## Examples

``` r
# default matching function is strict.
match.argv(1:10, list(c("a", "b"), list(1, 2), 1:10))
#>  [1]  1  2  3  4  5  6  7  8  9 10
try(match.argv(1, list(c("a", "b"), list(1, 2), 1:10)))
#> Error in match.argv(1, list(c("a", "b"), list(1, 2), 1:10)) : 
#>   'arg' should be one of: c("a", "b"), list(1, 2), 1:10

# NULL can be given as a candidate.
match.argv(NULL, list(NULL, 1:10))
#> NULL

# default matching function is strict.
try(match.argv(NA, list(NA_real_, NA_integer_, NA_character_)))
#> Error in match.argv(NA, list(NA_real_, NA_integer_, NA_character_)) : 
#>   'arg' should be one of: NA_real_, NA_integer_, ‘NA’

# a custom matching function can be used.
match.argv("A", list("a", "b", "c"), match.fn = function(x, y) {
  is.character(x) && length(x) == 1L && tolower(x) == tolower(y)
})
#> [1] "a"
```
