external_interrupt:external_interrupt.S
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g -o $@.o $^
	arm-none-eabi-ld -Tbasic.ld $@.o -o $@
	arm-none-eabi-objcopy -O binary $@ $@.bin

burn:
	st-flash write external_interrupt.bin 0x8000000

clean:
	rm *.bin *.o external_interrupt

external_interrupt_1:external_interrupt_1.S
	arm-none-eabi-as -mcpu=cortex-m4 -mthumb -g -o $@.o $^
	arm-none-eabi-ld -Tbasic.ld $@.o -o $@
	arm-none-eabi-objcopy -O binary $@ $@.bin
