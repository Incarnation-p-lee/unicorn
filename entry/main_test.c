#include "test_cases.h"

int main() {
    s_test_suite_t *suite = create_test_suite();

    test_clear_monitor(suite);

    print_test_suite(suite);
    destroy_test_suite(suite);

    return 0;
}

