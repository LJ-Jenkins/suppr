#include <R.h>
#include <Rinternals.h>
#include <math.h>
#include "utils.h"

SEXP C_is_wholenumber(SEXP x, SEXP tol)
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

    if (n == 0)
    {
        out = PROTECT(Rf_allocVector(LGLSXP, 0));
        nprot++;
        goto cleanup;
    }

    out = PROTECT(Rf_allocVector(LGLSXP, n));
    nprot++;

    int *res = LOGICAL(out);
    switch (in_type)
    {
    case INTSXP:
    {
        int *r = INTEGER(x);
        for (R_xlen_t i = 0; i != n; ++i)
            if (r[i] == NA_INTEGER)
                res[i] = NA_LOGICAL;
            else
                res[i] = TRUE;
        break;
    }

    case LGLSXP:
    {
        int *r = LOGICAL(x);
        for (R_xlen_t i = 0; i != n; ++i)
            if (r[i] == NA_LOGICAL)
                res[i] = NA_LOGICAL;
            else
                res[i] = TRUE;
        break;
    }

    case REALSXP:
    {
        double *r = REAL(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (!R_finite(r[i]))
                res[i] = NA_LOGICAL;
            else if (fabs(r[i] - round(r[i])) < tolerance)
                res[i] = TRUE;
            else
                res[i] = FALSE;
        }
        break;
    }

    case CPLXSXP:
    {
        Rcomplex *r = COMPLEX(x);
        for (R_xlen_t i = 0; i != n; ++i)
        {
            if (!R_finite(r[i].r) || !R_finite(r[i].i))
                res[i] = NA_LOGICAL;
            else if (fabs(r[i].r - round(r[i].r)) < tolerance && fabs(r[i].i - round(r[i].i)) < tolerance)
                res[i] = TRUE;
            else
                res[i] = FALSE;
        }
        break;
    }
    }

    preserve_names(x, out);

cleanup:
    UNPROTECT(nprot);
    return out;
}