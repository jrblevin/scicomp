/* test-foo.c -- an example test suite
 *
 * Copyright (C) 2009 Jason Blevins <jrblevin@sdf.lonestar.org>
 *
 * This software may be modified and distributed under the terms
 * of the BSD license.  See the LICENSE file for details.
 */

#include "test.h"

int test_foo()
{
    ASSERT_TRUE(1);
    ASSERT_FALSE(0);
    ASSERT_EQUAL(5, 5);
    return test_assert_fail;
}

int test_bar()
{
    ASSERT_STRING_EQUAL("xyz", "xzy");
    ASSERT_EQUAL_WITHIN(0.1, 0.1, 0.0001);
    return test_assert_fail;
}

int main (int argc, char* argv[])
{
    test_suite("foo");

    run_test("Foo test", test_foo);
    run_test("Bar test", test_bar);

    print_results();
    return 0;
}
