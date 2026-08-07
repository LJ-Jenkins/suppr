# checkDots() warns

    Code
      f(1, 2, 3, x = 1)
    Condition
      Warning:
      In f(1, 2, 3, x = 1) :
       extra named argument 'x' is not allowed.
       extra unnamed argument '3' is not allowed.

# checkDots() errors

    Code
      f(1, 2, 3, x = 1)
    Condition
      Error:
      ! In f(1, 2, 3, x = 1) :
       extra named argument 'x' is not allowed.
       extra unnamed argument '3' is not allowed.

