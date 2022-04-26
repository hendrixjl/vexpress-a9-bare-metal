ARMGNU ?= arm-none-eabi
AS = $(ARMGNU)-as
CC = $(ARMGNU)-gcc
LD = $(ARMGNU)-ld
OBJDUMP = $(ARMGNU)-objdump
OBJCOPY = $(ARMGNU)-objcopy


AOPS = --warn --fatal-warnings 
COPS = -Werror -nostdlib -nostartfiles -ffreestanding 



gcc : cenv.hex cenv.bin

all : gcc

clean :
	rm -f *.o
	rm -f *.bin
	rm -f *.hex
	rm -f *.elf
	rm -f *.list

startup.o : startup.s
	$(AS) $(AOPS) $^ -o $@

cstart.o : cstart.c
	$(CC) -c $(COPS) $^ -o $@

sp804.o : sp804.c
	$(CC) -c $(COPS) $^ -o $@

cenv.elf : startup.o cstart.o sp804.o
	$(LD) -T linkscript.ld -o $@ $^
	$(OBJDUMP) -D $@ > cenv.list

cenv.bin : cenv.elf
	$(OBJCOPY) $^ -O binary $@

cenv.hex : cenv.elf
	$(OBJCOPY) $^ -O ihex $@

qemu : cenv.bin
	qemu-system-arm -M vexpress-a9 -m 512M -no-reboot -nographic -monitor telnet:127.0.0.1:1234,server,nowait -kernel $^ -serial mon:stdio

.PHONY : help

