#ifndef UTILS_H
#define UTILS_H

#include <Rinternals.h>

static inline void preserve_names(SEXP src, SEXP dest)
{
    SEXP names = Rf_getAttrib(src, R_NamesSymbol);
    if (names != R_NilValue)
        Rf_setAttrib(dest, R_NamesSymbol, names);
}

static inline void preserve_names_by_logi(SEXP src, SEXP target, int *keep, R_xlen_t n_keep)
{
    SEXP names = Rf_getAttrib(src, R_NamesSymbol);

    if (names == R_NilValue)
        return;

    R_xlen_t n = Rf_xlength(src);

    SEXP out_names = PROTECT(Rf_allocVector(STRSXP, n_keep));

    R_xlen_t j = 0;
    for (R_xlen_t i = 0; i < n; i++)
    {
        if (keep[i])
        {
            SET_STRING_ELT(out_names, j, STRING_ELT(names, i));
            j++;
        }
    }

    Rf_setAttrib(target, R_NamesSymbol, out_names);

    UNPROTECT(1);
}

static inline void preserve_names_for_indices(SEXP x, SEXP indices)
{
    SEXP names = Rf_getAttrib(x, R_NamesSymbol);
    if (names == R_NilValue)
    {
        return;
    }

    R_xlen_t n = Rf_xlength(indices);
    SEXP selected = PROTECT(Rf_allocVector(STRSXP, n));

    switch (TYPEOF(indices))
    {
    case INTSXP:
    {
        int *idx = INTEGER(indices);
        for (R_xlen_t i = 0; i < n; i++)
        {
            SET_STRING_ELT(selected, i, STRING_ELT(names, idx[i] - 1));
        }

        break;
    }

    case REALSXP:
    {
        double *idx = REAL(indices);
        for (R_xlen_t i = 0; i < n; i++)
        {
            SET_STRING_ELT(selected, i,
                           STRING_ELT(names, (R_xlen_t)idx[i] - 1));
        }

        break;
    }

    default:
        UNPROTECT(1);
        Rf_error("Expected an integer or double index vector.");
    }

    Rf_setAttrib(indices, R_NamesSymbol, selected);
    UNPROTECT(1);
}

#endif