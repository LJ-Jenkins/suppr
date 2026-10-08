#include <R.h>
#include <Rinternals.h>
#include <string.h>

// modified do_startsWith from character.c from R source code
SEXP C_rm_prefix(SEXP x, SEXP prefix)
{
    // arg checks
    if (!Rf_isString(x) || !Rf_isString(prefix))
        error("Both 'x' and 'prefix' must be character vectors.");

    R_xlen_t n_prefix = Rf_xlength(prefix);

    if (n_prefix != 1)
        error("Prefix must be a character vector of length 1.");

    R_xlen_t n = Rf_xlength(x);

    SEXP xfix = STRING_ELT(prefix, 0);

    if (xfix == NA_STRING)
        error("Prefix cannot be NA.");

    // if input is empty, or xfix is empty, return input unchanged
    if (n == 0 || Rf_xlength(xfix) == 0)
        return x;

    const char *xfix_cp = Rf_translateCharUTF8(xfix);
    int xfix_len = (int)strlen(xfix_cp);

    SEXP ans = PROTECT(Rf_allocVector(STRSXP, n));

    for (R_xlen_t i = 0; i < n; i++)
    {
        SEXP el = STRING_ELT(x, i);

        if (el == NA_STRING)
        {
            SET_STRING_ELT(ans, i, NA_STRING);
            continue;
        }

        const char *el_cp = Rf_translateCharUTF8(el);
        int xlen = (int)strlen(el_cp);

        // if contains the prefix
        if (xlen >= xfix_len && strncmp(el_cp, xfix_cp, xfix_len) == 0)
        {
            SEXP s = Rf_mkCharLen(
                el_cp + xfix_len,
                xlen - xfix_len);

            SET_STRING_ELT(ans, i, s);
        }
        else
        {
            // No match: leave string unchanged
            SET_STRING_ELT(ans, i, el);
        }
    }

    UNPROTECT(1);
    return ans;
}

SEXP C_rm_suffix(SEXP x, SEXP suffix)
{
    // arg checks
    if (!Rf_isString(x) || !Rf_isString(suffix))
        error("Both 'x' and 'suffix' must be character vectors.");

    R_xlen_t n_suffix = Rf_xlength(suffix);

    if (n_suffix != 1)
        error("Suffix must be a character vector of length 1.");

    R_xlen_t n = Rf_xlength(x);

    SEXP xfix = STRING_ELT(suffix, 0);

    if (xfix == NA_STRING)
        error("Suffix cannot be NA.");

    if (n == 0 || Rf_xlength(xfix) == 0)
        return x;

    const char *xfix_cp = Rf_translateCharUTF8(xfix);
    int xfix_len = (int)strlen(xfix_cp);

    SEXP ans = PROTECT(Rf_allocVector(STRSXP, n));

    for (R_xlen_t i = 0; i < n; i++)
    {
        SEXP el = STRING_ELT(x, i);

        if (el == NA_STRING)
        {
            SET_STRING_ELT(ans, i, NA_STRING);
            continue;
        }

        const char *el_cp = Rf_translateCharUTF8(el);
        int xlen = (int)strlen(el_cp);

        if (xlen >= xfix_len && strncmp(el_cp + xlen - xfix_len, xfix_cp, xfix_len) == 0)
        {
            SEXP s = Rf_mkCharLen(
                el_cp,
                xlen - xfix_len);

            SET_STRING_ELT(ans, i, s);
        }
        else
            SET_STRING_ELT(ans, i, el);
    }

    UNPROTECT(1);
    return ans;
}
