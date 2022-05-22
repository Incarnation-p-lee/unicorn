#include "type.h"
#include "monitor.h"

static inline void
move_cursor(void)
{
    uint16 cursor;

    cursor = cursor_y * MONITOR_WIDTH + cursor_x;

    write_byte(VGA_CTRL_REG, VGA_CURSOR_HIGH);
    write_byte(VGA_DATA_REG, cursor >> 8);

    write_byte(VGA_CTRL_REG, VGA_CURSOR_LOW);
    write_byte(VGA_DATA_REG, cursor);
}

uint16
get_blank(void)
{
    return (((BLACK << 4) | WHITE) << 8) | BLANK;
}

void
clear_monitor(void)
{
    uint16 blank;

    blank = get_blank();

    for (int i = 0; i < MONITOR_SIZE; i++) {
        display_memory[i] = blank;
    }

    cursor_x = cursor_y = 0;

    move_cursor();
}

