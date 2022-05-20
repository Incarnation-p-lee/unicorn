package main

// #cgo CFLAGS: -m32 -fno-stack-protector
import "C"

//export Entry
func Entry(magic int) {
}


// XXXXX#cgo CFLAGS: -nostdlib -nostdinc -fno-builtin -fno-stack-protector -m32 -Wall -Wextra -Werror
func main() {
}

