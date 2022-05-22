package main

import "C"
import (
    "monitor/monitor"
)

//export Entry
func Entry() {
    monitor.ClearMonitor()
}

func main() {
}

