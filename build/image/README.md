# How to build one new disk image

1. `dd if=/dev/zero of=disk.img count=10080`
1. `fdisk disk.img`
  ```
    x     -> Extra functionality
    c 10  -> 10 cylinders
    h 16  -> 16 heads
    s 63  -> 63 sectors per track
    r     -> Return to main menu
    n     -> Create a new partition
    p     -> Primary
    1     -> Partition #1
    1     -> First cylinder
    10    -> Last cylinder
    a     -> Set bootable flag
    1     -> Partition number
    w     -> Write partition to disk
  ```
1. Find one free loop device by `sudo losetup -f`.
1. `losetup -o 1048576 /dev/loop0 disk.img`
1. `mkfs.ext2 /dev/loop0`
1. `mount -o loop /dev/loop0 /mnt`
1. `umount /mnt`
1. `losetup -d /dev/loop0`

