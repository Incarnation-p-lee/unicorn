#include "type.h"

void
write_byte(uint16 port, uint8 val)
{
    asm volatile (
        "outb %1, %0\n\t"
        :
        :"d"(port), "a"(val));
}

