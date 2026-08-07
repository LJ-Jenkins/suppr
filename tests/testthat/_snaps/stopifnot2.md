# stopifnot2() snapshot

    Code
      stopifnot2(all.equal(c("a", "b", "c"), c("a", "x", "z")))
    Condition
      Error:
      ! c("a", "b", "c") and c("a", "x", "z") are not equal:
        2 string mismatches

# stopifnot2() call information snapshot

    Code
      helper()
    Condition
      Error in `helper()`:
      ! c(TRUE, FALSE, TRUE) are not all TRUE

