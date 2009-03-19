/* test-foo.c -- an example test suite
 *
 * Copyright (C) 2009 Jason Blevins <jrblevin@sdf.lonestar.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
