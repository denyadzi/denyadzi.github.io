changing_clock.elf:changing_clock.S
	arm-none-eabi-gcc -nostdlib -Wall -Wextra -mthumb -mcpu=cortex-m4 -g -o $@ -Tbasic.ld $^
	arm-none-eabi-objcopy -O binary $@ $@.bin
	arm-none-eabi-objcopy -O ihex $@ $@.hex

burn:
	st-flash write changing_clock.elf.bin 0x8000000

clean:
	rm changing_clock.elf.bin changing_clock.elf changing_clock.elf.hex
