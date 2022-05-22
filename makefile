CC                 :=$(if $(V), gcc, @gcc)
ASM                :=$(if $(V), nasm, @nasm)
GO                 :=$(if $(V), go, @go)
LD                 :=$(if $(V), ld, @ld)
RM                 :=rm -rf
MKDIR              :=$(if $(V), mkdir, @mkdir)

base               :=.
config             :=$(base)/config
out                :=$(base)/unicorn
image_out          :=$(base)/build/image
loop               :=/dev/loop6
grub               :=$(base)/grub

CFLAG              =-m32 -Wall -Wextra -Werror -c
LFLAG              =-m elf_i386 -T$(config)/link.ld
ASMFLAG            =-felf

TARGET             =$(out)/kernel
IMAGE              =$(image_out)/disk.img

.PHONY: help clean image

c_src              =$(shell find . -name *.c)
c_obj              =$(subst .c,.o, $(c_src))

asm_src            =$(shell find . -name *.s)
asm_obj            =$(subst .s,.o, $(asm_src))

all: $(out) $(TARGET)

$(out):
	@echo "MakeDir  $@"
	$(MKDIR) -p $@

$(TARGET):$(asm_obj) $(c_obj)
	@echo "Link     $@"
	$(LD) $(LFLAG) $^ -o $@

$(asm_obj):$(asm_src)
	@echo "Compile  $<"
	$(ASM) $(ASMFLAG) $< -o $@

$(c_obj):%o:%c
	@echo "Compile  $<"
	$(CC) $(CFLAG) $< -o $@

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
	$(RM) $(out) $(asm_obj) $(c_obj)

