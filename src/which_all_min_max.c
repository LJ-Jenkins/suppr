#include <R.h>
#include <Rinternals.h>
#include "utils.h"

// Find all min/max indices, ignoring NA/NaN
SEXP C_which_all_min_max(SEXP x, SEXP y)
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

    R_xlen_t j = 0;
    int *buf = (int *)R_alloc(n, sizeof(int));

    switch (TYPEOF(x))
    {
    case INTSXP:
    {
        int *r = INTEGER(x);
        int val = mode == 0 ? INT_MAX : INT_MIN;

        if (mode == 0)
        {
            for (R_xlen_t i = 0; i != n; ++i) // get val (min/max)
                if (r[i] != NA_INTEGER && r[i] < val)
                    val = r[i];
        }
        else
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (r[i] != NA_INTEGER && r[i] > val)
                    val = r[i];
        }

        for (R_xlen_t i = 0; i != n; i++) // find all instances of val
        {
            if (r[i] != NA_LOGICAL && r[i] == val)
                buf[j++] = i + 1;
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
                if (!ISNAN(r[i]) && r[i] < val)
                    val = r[i];
        }
        else
        {
            for (R_xlen_t i = 0; i != n; ++i)
                if (!ISNAN(r[i]) && r[i] > val)
                    val = r[i];
        }

        for (R_xlen_t i = 0; i != n; i++)
        {
            if (r[i] == val)
                buf[j++] = i + 1;
        }
        break;
    }

    case LGLSXP:
    {
        int *r = LOGICAL(x);
        int val = FALSE;
        bool has = false;

        if (mode == 0)
        { // min, get val aka FALSE if present, else TRUE
            for (R_xlen_t i = 0; i != n; i++)
                if (r[i] == FALSE)
                {
                    has = true;
                    break;
                }
            val = has ? FALSE : TRUE;
        }
        else
        { // max, get val aka TRUE if present, else FALSE
            for (R_xlen_t i = 0; i != n; i++)
                if (r[i] == TRUE)
                {
                    has = true;
                    break;
                }
            val = has ? TRUE : FALSE;
        }

        for (R_xlen_t i = 0; i != n; i++)
            if (r[i] == val)
                buf[j++] = i + 1;
        break;
    }
    }

    // Allocate output vector and copy buffer
    bool large = ((R_xlen_t)j) > INT_MAX;
    out = PROTECT(Rf_allocVector(large ? REALSXP : INTSXP, j));
    nprot++;
    if (j > 0)
    {
        if (large)
        {
            double *outptr = REAL(out);
            for (R_xlen_t k = 0; k != j; k++)
                outptr[k] = (double)buf[k];
        }
        else
        {
            memcpy(INTEGER(out), buf, j * sizeof(int));
        }
    }

    // Preserve names
    // SEXP names = Rf_getAttrib(x, R_NamesSymbol);
    // if (names != R_NilValue)
    // {
    //     R_xlen_t nout = Rf_xlength(out);
    //     SEXP outnam = PROTECT(Rf_allocVector(STRSXP, nout));
    //     nprot++;

    //     if (TYPEOF(out) == INTSXP)
    //     {
    //         int *idx = INTEGER(out);
    //         for (R_xlen_t i = 0; i != nout; i++)
    //             SET_STRING_ELT(outnam, i, STRING_ELT(names, idx[i] - 1));
    //     }
    //     else
    //     {
    //         double *idx = REAL(out);
    //         for (R_xlen_t i = 0; i != nout; i++)
    //             SET_STRING_ELT(outnam, i, STRING_ELT(names, (R_xlen_t)idx[i] - 1));
    //     }

    //     Rf_setAttrib(out, R_NamesSymbol, outnam);
    // }

    preserve_names_for_indices(x, out);

cleanup:
    UNPROTECT(nprot);
    return out;
}
