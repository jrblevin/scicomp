#ifndef MT_H
#define MT_H

typedef struct mt_state mt_state;

mt_state *mt_alloc();
void mt_free(mt_state *state);
void mt_seed(mt_state *state, unsigned long int seed);
unsigned long int mt_get(mt_state *state);

#endif  /* MT_H */
