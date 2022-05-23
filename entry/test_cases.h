#ifndef HAVE_DEFINED_TEST_CASES_H
#define HAVE_DEFINED_TEST_CASES_H

#include "test.h"

extern void test_clear_monitor(s_test_suite_t *suite);
extern void write_byte(uint16 port, uint8 val);
extern s_test_suite_t * create_test_suite();

#endif

