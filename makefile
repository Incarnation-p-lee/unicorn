CC                 :=$(if $(V), gcc, @gcc)
ASM                :=$(if $(V), nasm, @nasm)
LD                 :=$(if $(V), ld, @ld)
RM                 :=rm -rf
MKDIR              :=$(if $(V), mkdir, @mkdir)

base               :=.
config             :=$(base)/config
inc                :=$(base)/common/inc
out                :=$(base)/unicorn
image_out          :=$(base)/build/image
loop               :=/dev/loop6
grub               :=$(base)/grub

CFLAG              =-nostdlib -nostdinc -fno-builtin -fno-stack-protector -m32 \
                    -Wall -Wextra -Werror -I$(inc) -c
LFLAG              =-m elf_i386 -T$(config)/link.ld

CFLAG_TEST         =-m32 -coverage -fprofile-arcs -ftest-coverage -Wall \
                    -Wextra -Werror -I$(inc) -c
LFLAG_TEST         =-m32 -coverage

ASMFLAG            =-felf

TARGET             =$(out)/kernel
TARGET_TEST        =$(out)/kernel_test
IMAGE              =$(image_out)/disk.img

.PHONY: help clean image test

c_src              =$(shell find . -name *.c | grep -v test)
c_obj              =$(subst .c,.o, $(c_src))

c_test_src         =$(shell find . -name *.c | grep test)
c_test_obj         =$(subst .c,.o, $(c_test_src))
c_test_gcno        =$(subst .c,.gcno, $(c_test_src))
c_test_gcda        =$(subst .c,.gcda, $(c_test_src))

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

$(c_test_obj):%o:%c
	@echo "Compile  $<"
	$(CC) $(CFLAG_TEST) $< -o $@

$(TARGET_TEST):$(c_test_obj)
	@echo "Link     $@"
	$(CC) $(LFLAG_TEST) $^ -o $@ -lgcov

test:$(out) $(TARGET_TEST)
	@echo "Test     $(TARGET_TEST)"
	@echo "Generate code coverage"
	@$(TARGET_TEST)

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
	$(RM) $(out) $(asm_obj) $(c_obj) $(c_test_obj) $(c_test_gcno) $(c_test_gcda)

