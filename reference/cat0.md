# Concatenate and Print with No Separator

Outputs the objects, concatenating the representations with no
separator.

## Usage

``` r
cat0(..., file = "", fill = FALSE, labels = NULL, append = FALSE)
```

## Arguments

- ...:

  `R` objects (see [cat](https://rdrr.io/r/base/cat.html) for the types
  of objects allowed).

- file:

  a connection, or a character string naming the file to print to. If ""
  (the default), cat0 prints to the standard output connection, the
  console unless redirected by sink.

- fill:

  a logical or (positive) numeric controlling how the output is broken
  into successive lines. If FALSE (default), only newlines created
  explicitly by "" are printed. Otherwise, the output is broken into
  lines with print width equal to the option width if fill is TRUE, or
  the value of fill if this is numeric. Linefeeds are only inserted
  between elements, strings wider than fill are not wrapped.
  Non-positive fill values are ignored, with a warning.

- labels:

  character vector of labels for the lines printed. Ignored if fill is
  FALSE.

- append:

  logical. Only used if the argument file is the name of file (and not a
  connection or "\|cmd"). If TRUE output will be appended to file;
  otherwise, it will overwrite the contents of file.

- sep:

  a character vector of strings to append after each element.

## Value

None (invisible NULL).

## Details

All arguments are passed to a call to
[cat](https://rdrr.io/r/base/cat.html) with `sep` set to `""`.

## See also

[cat](https://rdrr.io/r/base/cat.html),
[print](https://rdrr.io/r/base/print.html),
[format](https://rdrr.io/r/base/format.html) and
[paste](https://rdrr.io/r/base/paste.html) which concatenates into a
string.

## Examples

``` r
cat(letters[1:3])
#> a b c
cat0(letters[1:3])
#> abc

cat(
  paste(letters, 100 * 1:26),
  fill = TRUE, labels = paste0("{", 1:10, "}:")
)
#> {1}: a 100 b 200 c 300 d 400 e 500 f 600 g 700 h 800 i 900 j 1000 k 1100 l 1200 
#> {2}: m 1300 n 1400 o 1500 p 1600 q 1700 r 1800 s 1900 t 2000 u 2100 v 2200 
#> {3}: w 2300 x 2400 y 2500 z 2600
cat0(
  paste(letters, 100 * 1:26),
  fill = TRUE, labels = paste0("{", 1:10, "}:")
)
#> {1}: a 100b 200c 300d 400e 500f 600g 700h 800i 900j 1000k 1100l 1200m 1300n 1400
#> {2}: o 1500p 1600q 1700r 1800s 1900t 2000u 2100v 2200w 2300x 2400y 2500z 2600
```
