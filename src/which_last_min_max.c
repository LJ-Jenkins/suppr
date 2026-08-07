#include <R.h>
#include <Rinternals.h>
#include "utils.h"

// Find index of last minimum value, ignoring NA/NaN
// Taken near verbatim from R source code, all credit original authors
SEXP C_which_last_min_max(SEXP x, SEXP y)
{
    SEXP out;
    int nprot = 0;
    const int mode = INTEGER(y)[0]; // 0=min, 1=max

    if (!Rf_isNumeric(x))
    {
        PROTECT(x = Rf_coerceVector(x, REALSXP));
        nprot++;
    }

    R_xlen_t n = Rf_xlength(x);

    if (n == 0)
    {
        out = PROTECT(Rf_allocVector(INTSXP, 0));
        nprot++;
        goto cleanup;
    }

    R_xlen_t j = -1;

    switch (TYPEOF(x))
    {
    case INTSXP:
    {
        int *r = INTEGER(x);
        int val = mode == 0 ? INT_MAX : INT_MIN;
        if (mode == 0)
        {
            for (R_xlen_t i = 0; i != n; ++i) // get val (min/max)
                if (r[i] != NA_INTEGER && r[i] <= val)
                {
                    val = r[i];
                    j = i;
                }
        }
        else
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (r[i] != NA_INTEGER && r[i] >= val)
                {
                    val = r[i];
                    j = i;
                }
        }
        break;
    }
    case REALSXP:
    {
        double *r = REAL(x);
        double val = mode == 0 ? R_PosInf : R_NegInf;
        if (mode == 0)
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (!ISNAN(r[i]) && r[i] <= val)
                {
                    val = r[i];
                    j = i;
                }
        }
        else
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (!ISNAN(r[i]) && r[i] >= val)
                {
                    val = r[i];
                    j = i;
                }
        }
        break;
    }
    case LGLSXP:
    {
        int *r = LOGICAL(x);
        if (mode == 0)
        { // min, get val aka FALSE if present, else TRUE
            for (R_xlen_t i = n; i-- > 0;)
                if (r[i] == FALSE)
                {
                    j = i;
                    break;
                }
                else if (j == -1 && r[i] != NA_LOGICAL)
                {
                    j = i;
                }
        }
        else
        { // max, get val aka TRUE if present, else FALSE
            for (R_xlen_t i = n; i-- > 0;)
                if (r[i] == TRUE)
                {
                    j = i;
                    break;
                }
                else if (j == -1 && r[i] != NA_LOGICAL)
                {
                    j = i;
                }
        }
        break;
    }
    }

    /* nothing found (all NA/NaN) */
    if (j == -1)
    {
        out = PROTECT(Rf_allocVector(INTSXP, 0));
        nprot++;
        goto cleanup;
    }

    // check large and output index
    bool large = ((R_xlen_t)j + 1) > INT_MAX;
    out = PROTECT(Rf_allocVector(large ? REALSXP : INTSXP, 1));
    nprot++;
    if (large)
    {
        REAL(out)
        [0] = (double)j + 1;
    }
    else
    {
        INTEGER(out)
        [0] = (int)(j + 1);
    }

    // preserve names
    SEXP names = Rf_getAttrib(x, R_NamesSymbol);
    if (names != R_NilValue)
    {
        SEXP outnam = PROTECT(Rf_ScalarString(STRING_ELT(names, j)));
        nprot++;

        Rf_setAttrib(out, R_NamesSymbol, outnam);
    }

cleanup:
    UNPROTECT(nprot);
    return out;
}
