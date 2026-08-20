# Miscellaneous Helper Functions

`path()` builds a file path using
[file.path](https://rdrr.io/r/base/file.path.html), before normalizing
the path with
[normalizePath](https://rdrr.io/r/base/normalizePath.html).

`dims()` returns the dimensions of an object (from
[dim](https://rdrr.io/r/base/dim.html)), but for objects without
dimensions the length of the object is returned along with `0L` (e.g.,
`c(length(x), 0L)`).

`enumerate` maps a list to each element of a vector, containing the
index, value, and name of each element.

## Usage

``` r
path(..., sharedDrive = FALSE, mustWork = NA)

dims(x)

enumerate(x)
```

## Arguments

- ...:

  character vectors. [Long
  vectors](https://rdrr.io/r/base/LongVectors.html) are not supported.

- sharedDrive:

  logical, whether the path is on a shared drive. If `TRUE`, then
  `.Platform$file.sep` is given as the first element of the path, e.g.,
  `"mysd`, `"mydir"` becomes `"\\\\mysd\\mydir"` (on windows).

- mustWork:

  logical: if `TRUE` then an error is given if the result cannot be
  determined; if `NA` then a warning; if `FALSE` then no error or
  warning is given.

- x:

  For `dims()`, an **R** object.

  For `enumerate()`, a vector or list to be enumerated.

## Value

For `path()`, a character string of the expanded, normalized path.

For `dims()`, an integer of length 2 or greater that specifies the
dimensions of an object.

For `enumerate()`, a list of lists, where each inner list has three
elements: `idx`, `val`, and `name`, which are the index, value, and name
of the corresponding element.

## Details

`path()` will expand paths, see example.

Unnamed elements given to `enumerate()` will have an empty string (`""`)
as their name.

## Examples

``` r
path("path", "expansion", "occurs", mustWork = FALSE)
#> [1] "path/expansion/occurs"
path("mysd", "mydir", sharedDrive = TRUE, mustWork = FALSE)
#> [1] "//mysd/mydir"

# objects with dimensions give same output as dim():
dims(matrix(1:6, nrow = 2))
#> [1] 2 3

# those without give length and 0:
dims(1:5)
#> [1] 5 0
dims(list(a = 1, b = 2, c = 3))
#> [1] 3 0

for (x in enumerate(c(a = 1, b = 2, 3))) print(x)
#> $idx
#> [1] 1
#> 
#> $val
#> [1] 1
#> 
#> $name
#> [1] "a"
#> 
#> $idx
#> [1] 2
#> 
#> $val
#> [1] 2
#> 
#> $name
#> [1] "b"
#> 
#> $idx
#> [1] 3
#> 
#> $val
#> [1] 3
#> 
#> $name
#> [1] ""
#> 
```
