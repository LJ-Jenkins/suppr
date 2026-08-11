#include <R.h>
#include <Rinternals.h>
#include "utils.h"

SEXP C_anyZchar(SEXP x)
{
    if (TYPEOF(x) != STRSXP)
    {
        Rf_error("Input must be a character vector");
    }

    R_xlen_t n = Rf_xlength(x);

    for (R_xlen_t i = 0; i < n; ++i)
    {
        if (Rf_length(STRING_ELT(x, i)) == 0)
            return to_r_scalar_index(i + 1);
    }

    return Rf_ScalarInteger(0);
}