#include <R.h>
#include <Rinternals.h>
#include "utils.h"

static inline int C_isWS(SEXP s, int empty)
{
    if (s == NA_STRING)
        return 0;

    const unsigned char *p =
        (const unsigned char *)CHAR(s);

    if (*p == '\0')
        return empty;

    for (; *p != '\0'; ++p)
    {
        if (*p != ' ' &&
            *p != '\t' &&
            *p != '\r' &&
            *p != '\n')
            return 0;
    }

    return 1;
}

SEXP C_anyWS(SEXP x, SEXP empty)
{
    if (TYPEOF(x) != STRSXP)
    {
        Rf_error("Input must be a character vector");
    }

    if (TYPEOF(empty) != LGLSXP || Rf_length(empty) != 1)
    {
        Rf_error("'zchar' must be TRUE or FALSE");
    }

    int empty_ = LOGICAL(empty)[0];

    if (empty_ == NA_LOGICAL)
    {
        Rf_error("'zchar' must be TRUE or FALSE");
    }

    R_xlen_t n = Rf_xlength(x);

    for (R_xlen_t i = 0; i < n; ++i)
    {
        if (C_isWS(STRING_ELT(x, i), empty_))
            return to_r_scalar_index(i + 1);
    }

    return Rf_ScalarInteger(0);
}