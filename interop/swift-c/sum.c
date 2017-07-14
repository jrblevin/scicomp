// sum.c

#include <stdlib.h>

double sum(size_t n, const double *v) {
    double result = 0;
    for (size_t i = 0; i < n; i++) {
        result += v[i];
    }
    return result;
}
