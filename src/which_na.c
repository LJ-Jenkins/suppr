#include <R.h>
#include <Rinternals.h>
#include "utils.h"

// Find all NA indices
SEXP C_which_na(SEXP x)
{
    SEXP out;
    int nprot = 0;

    if (!Rf_isNumber(x) && TYPEOF(x) != STRSXP && TYPEOF(x) != VECSXP && TYPEOF(x) != LISTSXP)
    {
        Rf_error("Input must be a numeric, character, logical, or list.");
    }

    R_xlen_t n = Rf_xlength(x);

    if (n == 0 || TYPEOF(x) == RAWSXP) // empty or raw (no na's in raw)
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
        for (R_xlen_t i = 0; i != n; i++) // find all instances of na
        {
            if (r[i] == NA_INTEGER)
                buf[j++] = i + 1;
        }
        break;
    }

    case REALSXP:
    {
        double *r = REAL(x);
        for (R_xlen_t i = 0; i != n; i++)
        {
            if (ISNAN(r[i]))
                buf[j++] = i + 1;
        }
        break;
    }

    case LGLSXP:
    {
        int *r = LOGICAL(x);
        for (R_xlen_t i = 0; i != n; i++)
        {
            if (r[i] == NA_LOGICAL)
                buf[j++] = i + 1;
        }
        break;
    }

    case STRSXP:
    {
        for (R_xlen_t i = 0; i != n; i++)
        {
            if (STRING_ELT(x, i) == NA_STRING)
                buf[j++] = i + 1;
        }
        break;
    }

    case CPLXSXP:
    {
        Rcomplex *r = COMPLEX(x);
        for (R_xlen_t i = 0; i != n; i++)
        {
            if (ISNAN(r[i].r) || ISNAN(r[i].i))
                buf[j++] = i + 1;
        }
        break;
    }

#define which_na_list_vec(y)                                           \
    if (Rf_isVector(y) && Rf_xlength(y) == 1)                          \
    {                                                                  \
        switch (TYPEOF(y))                                             \
        {                                                              \
        case INTSXP:                                                   \
        {                                                              \
            int val = INTEGER(y)[0];                                   \
            if (val == NA_INTEGER)                                     \
            {                                                          \
                buf[j++] = i + 1;                                      \
            }                                                          \
            break;                                                     \
        }                                                              \
        case REALSXP:                                                  \
        {                                                              \
            double val = REAL(y)[0];                                   \
            if (ISNAN(val))                                            \
            {                                                          \
                buf[j++] = i + 1;                                      \
            }                                                          \
            break;                                                     \
        }                                                              \
        case LGLSXP:                                                   \
        {                                                              \
            int val = LOGICAL(y)[0];                                   \
            if (val == NA_LOGICAL)                                     \
            {                                                          \
                buf[j++] = i + 1;                                      \
            }                                                          \
            break;                                                     \
        }                                                              \
        case STRSXP:                                                   \
        {                                                              \
            SEXP val = STRING_ELT(y, 0);                               \
            if (val == NA_STRING)                                      \
            {                                                          \
                buf[j++] = i + 1;                                      \
            }                                                          \
            break;                                                     \
        }                                                              \
        case CPLXSXP:                                                  \
        {                                                              \
            Rcomplex val = COMPLEX(y)[0];                              \
            if (ISNAN(val.r) || ISNAN(val.i))                          \
            {                                                          \
                buf[j++] = i + 1;                                      \
            }                                                          \
            break;                                                     \
        }                                                              \
        default:                                                       \
        {                                                              \
            Rf_error("Unsupported type in list/vector for which_na."); \
        }                                                              \
        }                                                              \
    }

    case VECSXP:
    {
        for (R_xlen_t i = 0; i != n; i++)
        {
            SEXP y = VECTOR_ELT(x, i);
            which_na_list_vec(y);
        }
        break;
    }

    case LISTSXP:
    {
        for (R_xlen_t i = 0; i != n; i++)
        {
            SEXP y = CAR(x);
            which_na_list_vec(y);
            x = CDR(x);
        }
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
