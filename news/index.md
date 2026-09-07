# Changelog

## suppr (development version)

## suppr 1.0.1

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

- Initial CRAN submission.
