#include <R.h>
#include <Rinternals.h>
#include "utils.h"

static SEXP subset_logical(SEXP x, const int *keep, R_xlen_t n_keep)
{
    SEXP ans = PROTECT(Rf_allocVector(TYPEOF(x), n_keep));

    R_xlen_t n = Rf_xlength(x);
    R_xlen_t k = 0;

    switch (TYPEOF(x))
    {

    case LGLSXP:
        for (R_xlen_t i = 0; i < n; i++)
        {
            if (keep[i])
            {
                LOGICAL(ans)
                [k++] = LOGICAL_ELT(x, i);
            }
        }
        break;

    case INTSXP:
        for (R_xlen_t i = 0; i < n; i++)
        {
            if (keep[i])
            {
                INTEGER(ans)
                [k++] = INTEGER_ELT(x, i);
            }
        }
        break;

    case REALSXP:
        for (R_xlen_t i = 0; i < n; i++)
        {
            if (keep[i])
            {
                REAL(ans)
                [k++] = REAL_ELT(x, i);
            }
        }
        break;

    case CPLXSXP:
        for (R_xlen_t i = 0; i < n; i++)
        {
            if (keep[i])
            {
                COMPLEX(ans)
                [k++] = COMPLEX_ELT(x, i);
            }
        }
        break;

    case STRSXP:
        for (R_xlen_t i = 0; i < n; i++)
        {
            if (keep[i])
            {
                SET_STRING_ELT(ans, k++, STRING_ELT(x, i));
            }
        }
        break;

    case VECSXP:
    case EXPRSXP:
        for (R_xlen_t i = 0; i < n; i++)
        {
            if (keep[i])
            {
                SET_VECTOR_ELT(ans, k++, VECTOR_ELT(x, i));
            }
        }
        break;

    case RAWSXP:
        for (R_xlen_t i = 0; i < n; i++)
        {
            if (keep[i])
            {
                RAW(ans)
                [k++] = RAW_ELT(x, i);
            }
        }
        break;

    default:
        Rf_error("subset_logical: unimplemented type %s", Rf_type2char(TYPEOF(x)));
    }

    UNPROTECT(1);

    return ans;
}

/*
 * Return every repeated occurrence.
 */
SEXP C_repeats(SEXP x)
{
    R_xlen_t n = Rf_xlength(x);

    if (n == 0)
    {
        return Rf_allocVector(TYPEOF(x), 0);
    }

    SEXP a, b;

    PROTECT(a = Rf_duplicated(x, FALSE));
    b = Rf_duplicated(x, TRUE);

    int *keep = LOGICAL(a);
    int *pb = LOGICAL(b);

    R_xlen_t n_keep = 0;

    for (R_xlen_t i = 0; i < n; i++)
    {
        keep[i] |= pb[i];
        n_keep += keep[i];
    }

    SEXP ans = subset_logical(x, keep, n_keep);

    preserve_names_by_logi(x, ans, keep, n_keep);

    UNPROTECT(1);

    return ans;
}

/*
 * Return a logical vector indicating all repeated values.
 */
SEXP C_repeated(SEXP x)
{
    R_xlen_t n = Rf_xlength(x);

    if (n == 0)
    {
        return Rf_allocVector(LGLSXP, 0);
    }

    SEXP a, b;

    PROTECT(a = Rf_duplicated(x, FALSE));
    b = Rf_duplicated(x, TRUE);

    int *pa = LOGICAL(a);
    int *pb = LOGICAL(b);

    for (R_xlen_t i = 0; i < n; i++)
    {
        pa[i] |= pb[i];
    }

    preserve_names(x, a);

    UNPROTECT(1);

    return a;
}

SEXP C_repeated_indices(SEXP x)
{
    R_xlen_t n = Rf_xlength(x);

    if (n == 0)
    {
        return Rf_allocVector(INTSXP, 0);
    }

    SEXP a, b, result;
    int *pa, *pb, *temp;
    R_xlen_t count = 0;

    PROTECT(a = Rf_duplicated(x, FALSE));
    PROTECT(b = Rf_duplicated(x, TRUE));

    pa = LOGICAL(a);
    pb = LOGICAL(b);

    temp = (int *)R_alloc(n, sizeof(int));

    for (R_xlen_t i = 0; i < n; i++)
    {
        if (pa[i] || pb[i])
        {
            temp[count++] = i + 1;
        }
    }

    PROTECT(result = Rf_allocVector(INTSXP, count));
    int *presult = INTEGER(result);
    memcpy(presult, temp, count * sizeof(int));

    // Preserve names
    preserve_names_for_indices(x, result);

    UNPROTECT(3); // a, b, result
    return result;
}