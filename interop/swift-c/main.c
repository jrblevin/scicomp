// main.c

#include <stdio.h>
#include "sum.h"

int main () {
    size_t n = 10;
    double a[n];
    for (size_t i = 0; i < n; i++) {
        a[i] = (double) i;
    }
    printf("%2.0f\n", sum(n, a));
    return 0;
}
