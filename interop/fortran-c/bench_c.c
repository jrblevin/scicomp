#include <stdio.h>
#include <time.h>
#include "mt.h"

#define N 1000000000

int main()
{
    mt_state *mt;
    clock_t start, end;
    double time;
    int i, ints;
    unsigned long int u;

    mt = mt_alloc();
    mt_seed(mt, 5489);

    start = clock();
    for (i = 0; i < N; i++) {
        u = mt_get(mt);
    }
    end = clock();

    time = (end - start) / (double) CLOCKS_PER_SEC;
    ints = N / time;
    printf("32-bit integers per second: %d\n", ints);
    printf("last: %ld\n", u);
    mt_free(mt);

    return 1;
}
