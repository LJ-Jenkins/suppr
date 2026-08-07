# stopifnot.with() snapshot

    Code
      dat <- data.frame(expected = c(1, 2, 3), actual = c(1, 4, 5))
      stopifnot.with(dat, all.equal(expected, actual))
    Condition
      Error:
      ! with dat : expected and actual are not equal:
        Mean relative difference: 0.8

