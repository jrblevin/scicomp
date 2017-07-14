/* na.c -- Make your own NaN marker to annotate your floating-point data
 *
 * From "21st Century C" by Ben Klemens (O'Reilly, 2012, p. 125).
 *
 * 1. First produce a plain `NaN` by calculating `0/0.` (where the dot is
 * important, because we need floating-point division, not integer
 * division--integers have no means of representing `NaN`, and `0/0` is a
 * plain arithmetic error).
 *
 * 2. Then, we point a char at the bit pattern, where char is C's way
 * of saying byte.
 *
 * 3. Now that we can manipulate individual bytes of the
 * floating-point number, we set the third byte, comfortably in the
 * middle of the bit pattern that is this `NaN`, to match the
 * character `a`. Now we have a bit pattern that is `a NaN`, but a
 * very specific one, and one that the system didn't generate.
 *
 * 4. The `is_na` function checks whether the bit pattern of the number
 * we're testing matches the special bit pattern that `set_na` made
 * up. It does this by treating both inputs as character strings and
 * performing a character-by-character comparison.
 */

#include <stdio.h>
#include <math.h> //isnan

double ref;

double set_na() {
    if (!ref) {
        ref = 0 / 0.;
        char *cr = (char *)(&ref); cr[2]='a';
    }
    return ref;
}

int is_na(double in) {
    if (!ref) {
        return 0; // set_na was never called ==> no NAs yet.
    }
    char *cc = (char *)(&in);
    char *cr = (char *)(&ref);
    for (int i = 0; i < sizeof(double); i++) {
        if (cc[i] != cr[i]) {
            return 0;
        }
    }
    return 1;
}

int main() {
    double x = set_na();
    double y = x;
    printf("Is x=set_na() NA? %i\n", is_na(x));
    printf("Is x=set_na() NAN? %i\n", isnan(x));
    printf("Is y=x NA? %i\n", is_na(y));
    printf("Is 0/0 NA? %i\n", is_na(0/0.));
    printf("Is 8 NA? %i\n", is_na(8));
}
