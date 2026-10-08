# Changelog

## suppr (development version)

## suppr 1.1.0

##### New functions

- [`rm.prefix()`](https://lj-jenkins.github.io/suppr/reference/rm.prefix.md)
  and
  [`rm.suffix()`](https://lj-jenkins.github.io/suppr/reference/rm.prefix.md)
  to remove a given prefix or suffix from character vector elements.

## suppr 1.0.1

CRAN release: 2026-09-07

- [`whichRepeated()`](https://lj-jenkins.github.io/suppr/reference/repeated.md),
  [`whichNA()`](https://lj-jenkins.github.io/suppr/reference/whichNA.md),
  [`whichMin()`](https://lj-jenkins.github.io/suppr/reference/whichMin.md)/[`whichMax()`](https://lj-jenkins.github.io/suppr/reference/whichMin.md)
  when `loc = "all"` and
  [`repeats()`](https://lj-jenkins.github.io/suppr/reference/repeated.md)
  now don’t attempt to preserve names when no indices or duplicates are
  found, respectively.

- The C code for
  [`whichRepeated()`](https://lj-jenkins.github.io/suppr/reference/repeated.md)
  now avoids passing an invalid data pointer from a 0-length vector to
  `memcpy()`, which previously caused undefined behaviour. Thanks to
  Prof. Brian D. Ripley for reporting.

## suppr 1.0.0

CRAN release: 2026-09-05

- Initial CRAN submission.
