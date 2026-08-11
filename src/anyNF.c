#include <R.h>
#include <Rinternals.h>
#include "utils.h"

SEXP C_anyNF(SEXP x)
{
    if (!Rf_isNumber(x))
    {
        Rf_error("Input must be a logical, numeric or complex vector.");
    }

    R_xlen_t n = Rf_xlength(x);

    switch (TYPEOF(x))
    {
    case LGLSXP:
    {
        int *r = LOGICAL(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (r[i] == NA_LOGICAL)
                return to_r_scalar_index(i + 1);
        }
        break;
    }

    case INTSXP:
    {
        int *r = INTEGER(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (r[i] == NA_INTEGER)
                return to_r_scalar_index(i + 1);
        }
        break;
    }

    case REALSXP:
    {
        double *r = REAL(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (!R_finite(r[i]))
                return to_r_scalar_index(i + 1);
        }
        break;
    }

    case CPLXSXP:
    {
        Rcomplex *r = COMPLEX(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (!R_finite(r[i].r) || !R_finite(r[i].i))
                return to_r_scalar_index(i + 1);
        }
        break;
    }
    }

    return Rf_ScalarInteger(0);
}