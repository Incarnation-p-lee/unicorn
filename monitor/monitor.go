package monitor

/*
#include "type.h"

void
write_byte(int port, int val)
{
    uint16 p = (uint16)port;
    uint8 v = (uint8)val;

    asm volatile (
        "outb %1, %0\n\t"
        :
        :"d"(p), "a"(v));
}

*/
import "C"
import (
    "unsafe"
)

const (
    black = 0
    blank = 0x20
    white = 15

    vgaCtrlReg = 0x3d4
    vgaDataReg = 0x3D5

    vgaCursorHigh = 14
    vgaCursorLow = 15

    monitorAddress = 0xb8000

    monitorWidth = 80
    monitorHeight = 25
    monitorSize = monitorWidth * monitorHeight
)

var (
    cursorX int = 0
    cursorY int = 0
)

func writeDataToMonitor(data int16, offset int) {
    address := monitorAddress + offset * 2
    addressInt16Ptr := (*int16)(unsafe.Pointer(uintptr(address)))

    *addressInt16Ptr = data
}

func moveCursor() {
    cursorInMonitor := cursorY * monitorWidth + cursorX

    C.write_byte(C.int(vgaCtrlReg), C.int(vgaCursorHigh))
    C.write_byte(C.int(vgaDataReg), C.int(cursorInMonitor >> 8))

    C.write_byte(C.int(vgaCtrlReg), C.int(vgaCursorLow))
    C.write_byte(C.int(vgaDataReg), C.int(cursorInMonitor))
}

// ClearMonitor will make the monitor all blank, and mov (x, y) to (0, 0).
func ClearMonitor() {
    data := (((black << 4 | white)) << 8) | blank

    for i := 0; i < monitorSize; i++ {
        writeDataToMonitor(int16(data), i)
    }

    cursorX, cursorY = 0, 0

    moveCursor()
}

