#ifndef HAVE_DEFINED_TEST_H
#define HAVE_DEFINED_TEST_H

#include "type.h"

#define NAME_OF(s)          (#s)

#define DEFAULT_TEST_COUNT  1024

typedef struct test_suite s_test_suite_t;
typedef struct test_result s_test_result_t;

struct test_suite {
    uint32 size;
    uint32 index;
    s_test_result_t *all_results;
};

struct test_result {
    bool is_pass;
    char *test_name;
};


extern void append_fail_test_result(s_test_suite_t *suite, char *name);
extern void append_pass_test_result(s_test_suite_t *suite, char *name);

#endif

