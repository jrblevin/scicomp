/* test.h -- simple unit test macros for C
 *
 * Copyright (C) 2009 Jason Blevins <jrblevin@sdf.lonestar.org>
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#ifndef TEST_H
#define TEST_H

#include <stdio.h>
#include <string.h>
#include <math.h>

static int n_test = 0;
static int n_test_fail = 0;
static int n_assert = 0;
static int n_assert_fail = 0;
static int test_assert = 0;
static int test_assert_fail = 0;

#define test_suite(text)                                    \
    printf("%s\n", text);                                   \
    int i;                                                  \
    for (i = 0; i < strlen(text); i++)                      \
        putchar('=');                                       \
    printf("\n\n");                                         \
    n_test = 0;                                             \
    n_test_fail = 0;                                        \
    n_assert = 0;                                           \
    n_assert_fail = 0;                                      \

#define run_test(text, function)                            \
    test_assert = 0;                                        \
    test_assert_fail = 0;                                   \
    n_test++;                                               \
    printf("%d. %s...", n_test, text);                      \
    fflush(NULL);                                           \
    if (function() != 0) {                                  \
        n_test_fail++;                                      \
    }                                                       \
    else {                                                  \
        printf("pass.\n");                                  \
    }                                                       \
    n_assert += test_assert;                                \
    n_assert_fail += test_assert_fail;                      \

#define ASSERT_TRUE(expr)                                   \
    test_assert++;                                          \
    if (!(expr)) {                                          \
        printf("\n\nASSERT_TRUE failed:\n");                \
        printf("\n%s evaluates to false\n", #expr);         \
        test_assert_fail++;                                 \
    }

#define ASSERT_FALSE(expr)                                  \
    test_assert++;                                          \
    if (expr) {                                             \
        printf("\n\nASSERT_FALSE failed:\n");               \
        printf("\n%s evaluates to true\n\n", #expr);        \
        test_assert_fail++;                                 \
    }

#define ASSERT_EQUAL(a, b)                                  \
    test_assert++;                                          \
    if ((a) != (b)) {                                       \
        printf("\n\nASSERT_EQUAL failed:\n");               \
        printf("\n%s != %s\n\n", #a, #b);                   \
        test_assert_fail++;                                 \
    }

#define ASSERT_STRING_EQUAL(a, b)                           \
    test_assert++;                                          \
    if (strcmp(a, b)) {                                     \
        printf("\n\nASSERT_STRING_EQUAL failed:\n");        \
        printf("\na = %s\n\nb = %s\n\n", a, b);             \
        test_assert_fail++;                                 \
    }

#define ASSERT_EQUAL_WITHIN(a, b, tol)                      \
    test_assert++;                                          \
    if (fabs(a - b) > tol) {                                \
        printf("\n\nASSERT_EQUAL_WITHIN failed:\n");        \
        printf("\n%g != %g (tol = %g)\n\n", a, b, tol);     \
        test_assert_fail++;                                 \
    }

void print_results()
{
    printf("\n");
    printf("Tests passed: %d/%d, (%d failed)\n",
           n_test - n_test_fail, n_test, n_test_fail);
    printf("Assertions: %d/%d (%d failed)\n",
           n_assert - n_assert_fail, n_assert, n_assert_fail);
}

#endif /* TEST_H */
