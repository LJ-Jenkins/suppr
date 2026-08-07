# match.argv() errors when no match is found

    Code
      match.argv(4, list(1, 2, 3))
    Condition
      Error in `match.argv()`:
      ! 'arg' should be one of: 1, 2, 3

# match.argv() uses formal argument defaults when choices is omitted

    Code
      f("d")
    Condition
      Error in `match.argv()`:
      ! 'arg' should be one of: 'a', 'b', 'c'

