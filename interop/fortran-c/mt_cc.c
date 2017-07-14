#include <stdlib.h>
#include "mt.h"

/* Period parameters */
#define N 624
#define M 397
#define MATRIX_A   0x9908b0dfUL /* constant vector a */
#define UPPER_MASK 0x80000000UL /* most significant w-r bits */
#define LOWER_MASK 0x7fffffffUL /* least significant r bits */

struct mt_state {
    unsigned long int mt[N];    /* state vector */
    int mti;                    /* counter */
};

mt_state *mt_alloc()
{
    mt_state *mt = malloc(sizeof(mt_state));
    mt_seed(mt, 4357);
    return mt;
}

void mt_free(mt_state* state)
{
    if (state == NULL) {
        return;
    }
    free(state);
}

void mt_seed(mt_state* state, unsigned long int seed)
{
    size_t i;

    state->mt[0] = seed & 0xffffffffUL;

    for (i = 1; i < N; i++) {
        state->mt[i] =
	    (1812433253UL * (state->mt[i-1] ^ (state->mt[i-1] >> 30)) + i);
        /* See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier. */
        /* In the previous versions, MSBs of the seed affect   */
        /* only MSBs of the array mt[].                        */
        /* 2002/01/09 modified by Makoto Matsumoto             */
        state->mt[i] &= 0xffffffffUL; /* mask for >32 bit machines */
    }

    state->mti = N;
}

unsigned long int mt_get(mt_state* state)
{
    unsigned long int y;
    unsigned long int *mt = state->mt;
    static unsigned long mag01[2] = { 0x0UL, MATRIX_A };
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    /* Generate N words at once */
    if (state->mti >= N) {
        int kk;

        for (kk = 0; kk < N - M; kk++) {
            y = (mt[kk] & UPPER_MASK) | (mt[kk + 1] & LOWER_MASK);
            mt[kk] = mt[kk + M] ^ (y >> 1) ^ mag01[y & 0x1UL];
        }
        for (; kk < N - 1; kk++) {
            y = (mt[kk] & UPPER_MASK) | (mt[kk+1] & LOWER_MASK);
            mt[kk] = mt[kk + (M - N)] ^ (y >> 1) ^ mag01[y & 0x1UL];
        }
        y = (mt[N - 1] & UPPER_MASK) | (mt[0] & LOWER_MASK);
        mt[N - 1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1UL];

        state->mti = 0;
    }

    y = mt[state->mti];

    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    state->mti++;

    return y;
}
