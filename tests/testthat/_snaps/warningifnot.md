# warningifnot() snapshot

    Code
      warningifnot(all.equal(c("a", "b", "c"), c("a", "x", "z")))
    Condition
      Warning:
      c("a", "b", "c") and c("a", "x", "z") are not equal:
        2 string mismatches

# warningifnot() call information snapshot

    Code
      helper()
    Condition
      Warning in `helper()`:
      c(TRUE, FALSE, TRUE) are not all TRUE

