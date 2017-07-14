#include <stdlib.h>

/* An example function which operates on a real vector x of length n. */
int osl_foo(size_t n, double *x, double *y)
{
    size_t i;

    for (i = 0; i < n; i++) {
        y[i] = x[i] * x[i];
    }
    return 0;
}
