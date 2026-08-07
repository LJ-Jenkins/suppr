#define R_NO_REMAP
#include <R.h>
#include <Rinternals.h>

extern SEXP C_is_wholenumber(SEXP x, SEXP tol);
extern SEXP C_is_whole(SEXP x, SEXP tol);
extern SEXP C_is_integerish(SEXP x);
extern SEXP C_is_even_odd(SEXP x, SEXP y, SEXP np);
extern SEXP C_which_na(SEXP x);
extern SEXP C_which_all_min_max(SEXP x, SEXP y);
extern SEXP C_which_last_min_max(SEXP x, SEXP y);
extern SEXP C_anyNF(SEXP x);
extern SEXP C_repeated(SEXP x);
extern SEXP C_repeated_indices(SEXP x);
extern SEXP C_repeats(SEXP x);

static const R_CallMethodDef callMethods[] = {
    {"C_is_wholenumber", (DL_FUNC)&C_is_wholenumber, 2},
    {"C_is_whole", (DL_FUNC)&C_is_whole, 2},
    {"C_is_integerish", (DL_FUNC)&C_is_integerish, 1},
    {"C_is_even_odd", (DL_FUNC)&C_is_even_odd, 3},
    {"C_which_na", (DL_FUNC)&C_which_na, 1},
    {"C_which_all_min_max", (DL_FUNC)&C_which_all_min_max, 2},
    {"C_which_last_min_max", (DL_FUNC)&C_which_last_min_max, 2},
    {"C_anyNF", (DL_FUNC)&C_anyNF, 1},
    {"C_repeated", (DL_FUNC)&C_repeated, 1},
    {"C_repeated_indices", (DL_FUNC)&C_repeated_indices, 1},
    {"C_repeats", (DL_FUNC)&C_repeats, 1},
    {NULL, NULL, 0}};

void R_init_suppr(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
    R_forceSymbols(dll, TRUE);
}
