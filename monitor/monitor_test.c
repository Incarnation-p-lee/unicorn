#include "test.h"

#include "monitor.c"

void
test_clear_monitor(s_test_suite_t *suite)
{
    uint16 test_display_memory[MONITOR_SIZE];
    uint16 test_data = 0xF20;

    cursor_x = cursor_y = 0xF;
    display_memory = test_display_memory;

    clear_monitor();

    for (int i = 0; i < MONITOR_SIZE; i++) {
        if (display_memory[i] != test_data) {
            append_fail_test_result(suite, NAME_OF(clear_monitor));
            return;
        }
    }

    if (cursor_x != 0 || cursor_y != 0) {
        append_fail_test_result(suite, NAME_OF(clear_monitor));
    }

    append_pass_test_result(suite, NAME_OF(clear_monitor));
}

