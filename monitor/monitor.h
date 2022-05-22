#ifndef HAVE_DEFINED_MONITOR_H
#define HAVE_DEFINED_MONITOR_H

#define VGA_CTRL_REG    0x3D4
#define VGA_DATA_REG    0x3D5

#define VGA_CURSOR_HIGH 14
#define VGA_CURSOR_LOW  15

#define BLACK           0
#define WHITE           15

#define NEW_LINE        0xA
#define BLANK           0x20

#define MONITOR_WIDTH   80
#define MONITOR_HEIGHT  25
#define MONITOR_SIZE    (MONITOR_WIDTH * MONITOR_HEIGHT)

extern void write_byte(uint16 port, uint8 val);

static uint16 cursor_x = 0;
static uint16 cursor_y = 0;

/*
 * monitor memory start address of VGA controller dedicated.
 */
static uint16 *display_memory = (uint16 *)0xB8000;

#endif

