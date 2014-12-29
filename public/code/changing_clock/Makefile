all:changing_clock.elf speed_up.elf

changing_clock.elf:changing_clock.S
	arm-none-eabi-gcc -nostdlib -Wall -Wextra -mthumb -mcpu=cortex-m4 -g -o $@ -Tbasic.ld $^
	arm-none-eabi-objcopy -O binary $@ $@.bin

speed_up.elf:speed_up.S
	arm-none-eabi-as -mthumb -mcpu=cortex-m4 -g -o $@.o  $^
	arm-none-eabi-ld -Tbasic.ld -o $@ $@.o
	arm-none-eabi-objcopy -O binary $@ $@.bin

burn_changing:
	st-flash write changing_clock.elf.bin 0x8000000

burn_speedup:
	st-flash write speed_up.elf.bin 0x8000000

clean:
	rm *.elf *.elf.bin
