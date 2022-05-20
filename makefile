CC                 :=$(if $(V), gcc, @gcc)
ASM                :=$(if $(V), nasm, @nasm)
GO                 :=$(if $(V), go, @go)
RM                 :=rm -rf
MKDIR              :=$(if $(V), mkdir, @mkdir)

base               :=.
config             :=$(base)/config
out                :=$(base)/unicorn
image_out          :=$(base)/build/image
loop               :=/dev/loop6
grub               :=$(base)/grub

CFLAG              =-m32 -Wall -Wextra -Werror -c
LFLAG              =-m32 -static
ASMFLAG            =-felf
GOFLAG             =-buildmode=c-archive

TARGET             =$(out)/kernel
IMAGE              =$(image_out)/disk.img

.PHONY: help clean image

go_src             =$(shell find . -name *.go | grep -v _test.go)
go_archive         =$(subst .go,.a, $(go_src))

c_src              =$(shell find . -name *.c)
c_obj              =$(subst .c,.o, $(c_src))

asm_src            =$(shell find . -name *.s)
asm_obj            =$(subst .s,.o, $(asm_src))

all: $(out) $(TARGET)

$(out):
	@echo "MakeDir  $@"
	$(MKDIR) -p $@

$(TARGET):$(asm_obj) $(c_obj) $(go_archive)
	@echo "Link     $@"
	$(CC) $(LFLAG) $^ -o $@

$(asm_obj):$(asm_src)
	@echo "Compile  $<"
	$(ASM) $(ASMFLAG) $< -o $@

$(c_obj):$(c_src)
	@echo "Compile  $<"
	$(CC) $(CFLAG) $< -o $@

$(go_archive):%.a:%.go
	@echo "Build    $<"
	$(GO) env -w GOARCH=386 CGO_ENABLED=1
	$(GO) build -o $@ $(GOFLAG) $<

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
	$(RM) $(out) $(asm_obj) $(c_obj) $(go_archive)

