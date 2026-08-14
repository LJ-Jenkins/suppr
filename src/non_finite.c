#include <R.h>
#include <Rinternals.h>
#include "utils.h"

SEXP C_is_nonfinite(SEXP x)
{
    int nprotect = 0;
    R_xlen_t n = Rf_xlength(x);
    SEXP ans;
    PROTECT(ans = Rf_allocVector(LGLSXP, n));
    nprotect++;

    int *pa = LOGICAL(ans);
    SEXP dims = R_NilValue, names = R_NilValue;
    if (Rf_isVector(x))
    {
        dims = Rf_getAttrib(x, R_DimSymbol);
        if (Rf_isArray(x))
            PROTECT(names = Rf_getAttrib(x, R_DimNamesSymbol));
        else
            PROTECT(names = Rf_getAttrib(x, R_NamesSymbol));

        nprotect++;
    }

    switch (TYPEOF(x))
    {
    case STRSXP:
    case RAWSXP:
    case NILSXP:
    {
        for (R_xlen_t i = 0; i < n; i++)
            pa[i] = 1;
        break;
    }
    case LGLSXP:
    {
        int *r = LOGICAL(x);
        for (R_xlen_t i = 0; i < n; i++)
            pa[i] = (r[i] == NA_LOGICAL);
        break;
    }
    case INTSXP:
    {
        int *r = INTEGER(x);
        for (R_xlen_t i = 0; i < n; i++)
            pa[i] = (r[i] == NA_INTEGER);
        break;
    }
    case REALSXP:
    {
        double *r = REAL(x);
        for (R_xlen_t i = 0; i < n; i++)
            pa[i] = !R_finite(r[i]);
        break;
    }
    case CPLXSXP:
    {
        Rcomplex *r = COMPLEX(x);
        for (R_xlen_t i = 0; i < n; i++)
            pa[i] = (!R_finite(r[i].r) || !R_finite(r[i].i));
        break;
    }
    default:
        Rf_error("default method not implemented for type '%s'",
                 Rf_type2char(TYPEOF(x)));
    }

    if (dims != R_NilValue)
        Rf_setAttrib(ans, R_DimSymbol, dims);

    if (names != R_NilValue)
    {
        if (Rf_isArray(x))
            Rf_setAttrib(ans, R_DimNamesSymbol, names);
        else
            Rf_setAttrib(ans, R_NamesSymbol, names);
    }

    UNPROTECT(nprotect);
    return ans;
}