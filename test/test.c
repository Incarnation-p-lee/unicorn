#include <stdlib.h>
#include <string.h>
#include "test.h"

static inline void
expand_test_suite(s_test_suite_t *suite)
{
    uint32 size = suite->size;
    uint32 new_size = size * 2;
    uint32 result_in_bytes = sizeof(s_test_suite_t);
    uint32 new_size_in_bytes = result_in_bytes * new_size;
    s_test_result_t *new_address = (s_test_result_t *)malloc(new_size_in_bytes);

    memcpy(new_address, suite->all_results, result_in_bytes * size);

    free(suite->all_results);

    suite->size = new_size;
    suite->all_results = new_address;
}

s_test_suite_t *
create_test_suite() {
    s_test_suite_t *suite = (s_test_suite_t *)malloc(sizeof(s_test_suite_t));
    uint32 size_in_bytes = sizeof(s_test_suite_t) * DEFAULT_TEST_COUNT;

    suite->all_results = (s_test_result_t *)malloc(size_in_bytes);

    suite->index = 0;
    suite->size = DEFAULT_TEST_COUNT;

    return suite;
}

static inline void
append_rest_result(s_test_suite_t *suite, char *name, bool is_pass)
{
    uint32 i = suite->index;

    if (suite->index >= suite->size) {
        expand_test_suite(suite);
    }

    suite->all_results[i].is_pass = is_pass;
    suite->all_results[i].test_name = name;

    suite->index = i + 1;
}

void
append_fail_test_result(s_test_suite_t *suite, char *name)
{
    append_rest_result(suite, name, false);
}

void
append_pass_test_result(s_test_suite_t *suite, char *name)
{
    append_rest_result(suite, name, true);
}

