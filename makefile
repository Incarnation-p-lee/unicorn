CC                 :=$(if $(V), gcc, @gcc)
ASM                :=$(if $(V), nasm, @nasm)
LD                 :=$(if $(V), ld, @ld)
GO                 :=$(if $(V), go, @go)
RM                 :=rm -rf
MKDIR              :=$(if $(V), mkdir, @mkdir)

base               :=$(shell pwd)
out                :=$(base)/unicorn
obj_out            :=$(out)/obj

CFLAG              =-nostdlib -nostdinc -fno-builtin -fno-stack-protector -m32 -Wall -Wextra -Werror -c
LD_SCRIPT          =link.ld
LFLAG              =-T$(script)/$(LD_SCRIPT) -m elf_i386
ASMFLAG            =-felf

.PHONY: all help clean

boot_obj           =$(obj_out)/boot.o
boot_src           =$(base)/boot/boot.s

all: $(obj_out) $(boot_obj)

$(obj_out):
	@echo "MakeDir  $@"
	$(MKDIR) -p $@

$(boot_obj):$(boot_src)
	@echo "Compile  $(notdir $<)"
	$(ASM) $(ASMFLAG) $< -o $@

clean:
	$(RM) $(out)

