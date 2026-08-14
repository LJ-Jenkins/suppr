# Loading/Attaching Multiple Packages

Wraps [`library()`](https://rdrr.io/r/base/library.html) and
[`require()`](https://rdrr.io/r/base/library.html) to load multiple
packages.

## Usage

``` r
libraries(
  ...,
  pos = 2,
  lib.loc = NULL,
  character.only = FALSE,
  logical.return = FALSE,
  warn.conflicts,
  quietly = FALSE,
  verbose = getOption("verbose"),
  mask.ok,
  exclude,
  include.only,
  attach.required = missing(include.only)
)

requires(
  ...,
  lib.loc = NULL,
  quietly = FALSE,
  warn.conflicts,
  character.only = FALSE,
  mask.ok,
  exclude,
  include.only,
  attach.required = missing(include.only)
)
```

## Arguments

- ...:

  the names of the packages, given as
  [name](https://rdrr.io/r/base/name.html)s, character strings, a
  combination of both, or character vectors (see `character.only`
  below).

- pos:

  the position on the search list at which to attach the loaded
  namespace. Can also be the name of a position on the current search
  list as given by [`search()`](https://rdrr.io/r/base/search.html).

- lib.loc:

  a character vector describing the location of **R** library trees to
  search through, or `NULL`. The default value of `NULL` corresponds to
  all libraries currently known to
  [`.libPaths()`](https://rdrr.io/r/base/libPaths.html). Non-existent
  library trees are silently ignored.

- character.only:

  a logical indicating whether package or help can be assumed to be
  character strings. If `TRUE`, dot arguments are coerced to be
  character before being unlisted into a single character vector.

- logical.return:

  logical. If it is `TRUE`, `FALSE` or `TRUE` is returned to indicate
  success.

- warn.conflicts:

  logical. If `TRUE`, warnings are printed about
  [conflicts](https://rdrr.io/r/base/conflicts.html) from attaching the
  new package. A conflict is a function masking a function, or a
  non-function masking a non-function. The default is `TRUE` unless
  specified as `FALSE` in the `conflicts.policy` option.

- quietly:

  a logical. If `TRUE`, no message confirming package attaching is
  printed, and most often, no errors/warnings are printed if package
  attaching fails.

- verbose:

  a logical. If `TRUE`, additional diagnostics are printed.

- mask.ok:

  character vector of names of objects that can mask objects on the
  search path without signaling an error when strict conflict checking
  is enabled.

- exclude, include.only:

  character vector of names of objects to exclude or include in the
  attached frame. Only one of these arguments may be used in a call to
  `libraries` or `requires`.

- attach.required:

  logical specifying whether required packages listed in the `Depends`
  clause of the `DESCRIPTION` file should be attached automatically.

## Value

`libraries()` and `requires()` return the value of the last dot argument
evaluated, invisibly:

Normally `library` returns (invisibly) the list of attached packages,
but `TRUE` or `FALSE` if `logical.return` is `TRUE`. When called as
[`library()`](https://rdrr.io/r/base/library.html) it returns an object
of class `"libraryIQR"`, and for
[`library(help=)`](https://rdrr.io/r/base/library.html), one of class
`"packageInfo"`.

`require` returns (invisibly) a logical indicating whether the required
package is available.

## Details

All non-dot arguments are passed in their entirety to each `library` or
`require` call, so the same arguments are used for each package.

For the `help` of a package, call `library(help = <package>)` directly.

For full details see [library](https://rdrr.io/r/base/library.html).

## See also

[attach](https://rdrr.io/r/base/attach.html),
[detach](https://rdrr.io/r/base/detach.html),
[install.packages](https://rdrr.io/r/utils/install.packages.html)

## Examples

``` r
libraries("stats", "graphics", methods)
requires("stats", graphics, "methods")

x <- c("stats", "graphics")
libraries(x, "methods", character.only = TRUE)
try(requires(methods, x, character.only = TRUE))
#> Error in FUN(X[[i]], ...) : 
#>   cannot coerce type 'closure' to vector of type 'character'
```
