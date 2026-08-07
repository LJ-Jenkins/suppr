#include <R.h>
#include <Rinternals.h>
#include <math.h>
#include "utils.h"

// TRUE or FALSE for even/odd
SEXP C_is_even_odd(SEXP x, SEXP y, SEXP np)
{
    SEXP out;
    int nprot = 0;
    const int mode = INTEGER(y)[0]; // 0=even, 1=odd
    const int false_or_na = (INTEGER(np)[0] == 0) ? FALSE : NA_LOGICAL;

    if (!Rf_isNumeric(x))
    {
        Rf_error("Input must be a logical or numeric vector.");
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
    switch (TYPEOF(x))
    {
    case INTSXP:
    {
        int *r = INTEGER(x);
        if (mode == 0)
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (r[i] == NA_INTEGER)
                    res[i] = false_or_na;
                else if (r[i] % 2 == 0)
                    res[i] = TRUE;
                else
                    res[i] = FALSE;
        }
        else
        {
            for (R_xlen_t i = 0; i != n; ++i)
            {
                if (r[i] == NA_INTEGER)
                {
                    res[i] = false_or_na;
                    continue;
                }
                int rem = r[i] % 2;
                if (rem == 1 || rem == -1)
                    res[i] = TRUE;
                else
                    res[i] = FALSE;
            }
        }
        break;
    }

    case REALSXP:
    {
        double *r = REAL(x);
        if (mode == 0)
        {
            for (R_xlen_t i = 0; i != n; ++i)
            {
                if (!R_finite(r[i]))
                {
                    res[i] = false_or_na;
                    continue;
                }
                double rem = fmod(r[i], 2.0);
                if (rem == 0.0)
                    res[i] = TRUE;
                else if (rem == 1.0 || rem == -1.0)
                    res[i] = FALSE;
                else
                    res[i] = false_or_na;
            }
        }
        else
        {
            for (R_xlen_t i = 0; i != n; ++i)
            {
                if (!R_finite(r[i]))
                {
                    res[i] = false_or_na;
                    continue;
                }
                double rem = fmod(r[i], 2.0);
                if (rem == 1.0 || rem == -1.0)
                    res[i] = TRUE;
                else if (rem == 0.0)
                    res[i] = FALSE;
                else
                    res[i] = false_or_na;
            }
        }
        break;
    }

    case LGLSXP:
    {
        int *r = LOGICAL(x);
        if (mode == 0)
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (r[i] == FALSE)
                    res[i] = TRUE;
                else
                    res[i] = FALSE;
        }
        else
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (r[i] == TRUE)
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