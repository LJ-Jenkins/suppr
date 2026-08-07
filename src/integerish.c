#include <R.h>
#include <Rinternals.h>
#include <math.h>

SEXP C_is_integerish(SEXP x)
{
    SEXP out;
    int nprot = 0;

    if (!Rf_isNumber(x))
    {
        Rf_error("Input must be a logical or numeric vector.");
    }

    switch (TYPEOF(x))
    {
    case LGLSXP:
    case INTSXP:
    {
        out = PROTECT(Rf_ScalarLogical(TRUE));
        nprot++;
        goto cleanup;
        break;
    }
    case REALSXP:
    {
        R_xlen_t n = Rf_xlength(x);
        double *r = REAL(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (!R_finite(r[i]))
                continue;
            else if (fmod(fabs(r[i]), 1.0) != 0.0)
            {
                out = PROTECT(Rf_ScalarLogical(FALSE));
                nprot++;
                goto cleanup;
            }
        }

        out = PROTECT(Rf_ScalarLogical(TRUE));
        nprot++;
        goto cleanup;
        break;
    }
    }

    // will catch CPLXSP
    out = PROTECT(Rf_ScalarLogical(FALSE));
    nprot++;

cleanup:
    UNPROTECT(nprot);
    return out;
}