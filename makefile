CC                 :=$(if $(V), gcc, @gcc)
ASM                :=$(if $(V), nasm, @nasm)
LD                 :=$(if $(V), ld, @ld)
GO                 :=$(if $(V), go, @go)
RM                 :=rm -rf
MKDIR              :=$(if $(V), mkdir, @mkdir)

base               :=$(shell pwd)
config             :=$(base)/config
out                :=$(base)/unicorn
obj_out            :=$(out)/obj
image_out          :=$(base)/build/image
loop               :=/dev/loop6
grub               :=$(base)/grub

CFLAG              =-nostdlib -nostdinc -fno-builtin -fno-stack-protector -m32 -Wall -Wextra -Werror -c
LD_SCRIPT          =link.ld
LFLAG              =-T$(config)/$(LD_SCRIPT) -m elf_i386
ASMFLAG            =-felf

TARGET             =$(out)/kernel
IMAGE              =$(image_out)/disk.img

.PHONY: help clean image

boot_obj           =$(obj_out)/boot.o
boot_src           =$(base)/boot/boot.s

all: $(obj_out) $(TARGET)

$(obj_out):
	@echo "MakeDir  $@"
	$(MKDIR) -p $@

$(TARGET):$(boot_obj)
	@echo "Link     $@"
	$(LD) $(LFLAG) $^ -o $@

$(boot_obj):$(boot_src)
	@echo "Compile  $<"
	$(ASM) $(ASMFLAG) $< -o $@

image:all
	@echo "Build    $(IMAGE)"
	@sudo losetup -o 1048576 $(loop) $(IMAGE)
	@sudo mount -o loop $(loop) /mnt
	@sudo cp $(TARGET) /mnt/boot/kernel
	@sudo cp $(image_out)/initrd.img /mnt/boot/initrd
	@sudo cp $(grub)/grub.conf /mnt/boot/grub/grub.conf
	@sudo cp $(grub)/menu.lst /mnt/boot/grub/menu.lst
	@sudo umount /mnt
	@sudo losetup -d $(loop)

clean:
	$(RM) $(out)

