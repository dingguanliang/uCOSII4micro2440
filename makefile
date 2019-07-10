####################################################

OBJTREE	:= $(CURDIR)
SRCTREE	:= $(CURDIR)
export	OBJTREE SRCTREE

include	$(SRCTREE)/config.mk

####################################################

LIBS	:= arch/lib.a
LIBS 	+= app/lib.a
LIBS 	+= dev/lib.a
LIBS 	+= lib/lib.a
LIBS 	+= kernel/source/lib.a
LIBS 	+= kernel/port/lib.a

CDIR	:= $(dir $(LIBS))

####################################################

.PHONY: all
all: clean firmware.bin clean_dep

firmware.bin: firmware.elf
	$(OBJCOPY) $(OBJCFLAGS) -O binary $< $@

firmware.elf: mklibs
	$(LD) $(LDFLAGS) -o $@ $(LIBS)

.PHONY: mklibs
mklibs: 
	@for n in $(CDIR); \
	do \
		$(MAKE) -C $$n; \
	done

####################################################

.PHONY: clean_dep
clean_dep:
	@find -type f \( -name '.depend' \) -print | xargs rm -f
	@echo clear depend file complete!

####################################################

.PHONY: clean
clean:
	@find -type f \( -name '*.map' -o -name '*.asm' -o -name '*.elf' -o -name '*.bin' -o -name '*.o' -o -name '*.a' -o -name '.depend' \) -print | xargs rm -f
	@echo clear complete!

####################################################

.PHONY: disasm
disasm: all firmware.asm

firmware.asm:
	$(OBJDUMP) -D -b binary -m arm firmware.bin >> $@

####################################################
