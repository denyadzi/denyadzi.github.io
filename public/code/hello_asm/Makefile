main:main.S 
	arm-none-eabi-gcc -Wall -Wextra -o $@ -nostdlib -mcpu=cortex-m4 -mthumb -g -Tbasic.ld $^
	arm-none-eabi-objcopy -O binary $@ $@.bin

clean:
	rm main main.bin
