#include <R.h>
#include <Rinternals.h>
#include <math.h>

SEXP C_is_whole(SEXP x, SEXP tol)
{
    SEXP out;
    int nprot = 0;

    if (!Rf_isReal(tol) || Rf_length(tol) != 1)
    {
        Rf_error("'tol' must be a numeric scalar.");
    }

    double tolerance = REAL(tol)[0];
    int in_type = TYPEOF(x);

    if (!Rf_isNumber(x))
    {
        Rf_error("Input must be a logical, numeric or complex vector.");
    }

    R_xlen_t n = Rf_xlength(x);

    switch (in_type)
    {
    case INTSXP:
    case LGLSXP:
    {
        out = PROTECT(Rf_ScalarLogical(TRUE));
        nprot++;
        goto cleanup;
        break;
    }

    case REALSXP:
    {
        double *r = REAL(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (!R_finite(r[i]))
                continue;
            else if (fabs(r[i] - round(r[i])) >= tolerance)
            {
                out = PROTECT(Rf_ScalarLogical(FALSE));
                nprot++;
                goto cleanup;
            }
        }
        break;
    }

    case CPLXSXP:
    {
        Rcomplex *r = COMPLEX(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (!R_finite(r[i].r) || !R_finite(r[i].i))
                continue;
            else if (fabs(r[i].r - round(r[i].r)) >= tolerance || fabs(r[i].i - round(r[i].i)) >= tolerance)
            {
                out = PROTECT(Rf_ScalarLogical(FALSE));
                nprot++;
                goto cleanup;
            }
        }
        break;
    }
    }

    out = PROTECT(Rf_ScalarLogical(TRUE));
    nprot++;

cleanup:
    UNPROTECT(nprot);
    return out;
}