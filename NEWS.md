# suppr (development version)

# suppr 1.0.1

* `whichRepeated()`, `whichNA()`, `whichMin()`/`whichMax()` when `loc = "all"` and `repeats()` now don't attempt to preserve names when no indices or duplicates are found, respectively.

* The C code for `whichRepeated()` now avoids passing an invalid data pointer from a 0-length vector to `memcpy()`, which previously caused undefined behaviour. Thanks to Prof. Brian D. Ripley for reporting.

# suppr 1.0.0

* Initial CRAN submission.
