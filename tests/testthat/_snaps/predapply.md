# predapply() validates reduce, na.as and FUN output shape

    Code
      predapply(1:3, is.numeric, reduce = "invalid")
    Condition
      Error in `match.arg()`:
      ! 'arg' should be one of "all", "any", "none"

