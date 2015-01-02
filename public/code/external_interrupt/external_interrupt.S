    .thumb
    .syntax     unified
    .cpu        cortex-m4

    .include    "registers_and_bits.inc.S"
    .equ        DELAY,                  0x1


.section        .text
    .type       _reset, %function
_reset:
    bl          startup
    bl          init_clock
    bl          gpio_setup
    b           run
    .size       _reset, . - _reset

    
    .type       run, %function
run:
    ldr         r0, =GPIOD_ODR          /* port D output register */
    ldr         r3, =GPIOA_IDR          /* port A input register */
2:
    eor         r1, r1                  /* elegant way to clean register */
    str         r1, [r0]                /* all LEDs on GPIOD_ODR off */
1:
    ldr         r4, [r3]                /* reading port A */ 
    ands        r4, IDR0                /* when button is pressed - high level appears at pin 0 */
    beq         1b
1:
    bl          super_flash           /* make a flash */
    ldr         r4, [r3]                /* and wait for button release */
    ands        r4, IDR0
    bne         1b
    b           2b
    .size       run, . - run


    .type       super_flash, %function
super_flash:
    push        {lr}                    /* we need to preserve the return address */
    mov         r5, 5                   /* as this routine is going to call a subroutine */
1:
    mov         r1, LED_GREEN           /* flashing one by one */
    bl          flash_led
    mov         r1, LED_BLUE
    bl          flash_led
    mov         r1, LED_RED
    bl          flash_led
    mov         r1, LED_ORANGE
    bl          flash_led
    subs        r5, 1                   /* <r5> times */
    bne         1b
    pop         {lr}                    /* restore the return address and jump to it */
    bx          lr
    .size       super_flash, . - super_flash


    .type       flash_led, %function
flash_led:
    push        {lr}                    /* in this function it is assumed that */
    str         r1, [r0]                /* r0 contains port D address */
    bl          delay                 /* and r1 contains the LED bit to be flashed */
    eor         r1, r1
    str         r1, [r0]                /* LED fade out */
    bl          delay
    pop         {lr}
    bx          lr
    .size       flash_led, . - flash_led


    .type       delay, %function
delay:
    movt        r2, DELAY
1:
    subs        r2, r2, 1               /* spend time substracting DELAY value by 1 */
    bne         1b                      /* '1b' means `look backward for label '1'` */

    bx          lr
    .size       delay, . - delay


    .type       gpio_setup, %function
gpio_setup:
    ldr         r0, =RCC_AHB1ENR        /* this register controls some amount of peripherals' clock */
    ldr         r1, [r0]
    orr         r1, GPIODEN | GPIOAEN   /* enabling GPIOD AND GPIOA clock */
    str         r1, [r0]

    ldr         r0, =GPIOA_MODER        /* configure GPIOA as input */
    ldr         r1, [r0]
    bic         r1, MODER0_IN 
    str         r1, [r0]

    ldr         r0, =GPIOA_PUPDR        /* connect pulldown resistor to the pin 0 */
    ldr         r1, [r0]
    orr         r1, PUPDR0_PD 
    str         r1, [r0]

    ldr         r0, =GPIOD_MODER        /* GPIOD mode configuration register - all LED pins are outputs*/
    ldr         r1, =MODER12_OUT | MODER13_OUT | MODER14_OUT | MODER15_OUT
    str         r1, [r0]

    bx          lr
    .size       gpio_setup, . - gpio_setup


    .type       startup, %function
startup:
    ldr         r0, =RCC_CR             /* resetting clock configuration to it's defaults */
    ldr         r1, [r0]                /* clearing HSEON, CSSON, PLLON bits - directly disabling */
                                        /* HSE oscillator, clock security system, main PLL */
    orr         r1, HSION               /* setting HSION bit - directly selecting HSI oscillator*/
    ldr         r2, =(HSEON) | (CSSON) | (PLLON)
    bic         r1, r2
    str         r1, [r0]
    ldr         r0, =RCC_CFGR           /* clearing RCC_CFGR - clock configuration register */
    movw        r1, 0
    str         r1, [r0]
    ldr         r0, =RCC_CIR            /* disabling all interrupts */
    str         r1, [r0]
    ldr         r0, =RCC_PLLCFGR        /* setting the default value from datasheet */
    ldr         r1, =0x24003010         /* for PLL configuration register */
    str         r1, [r0]
    bx          lr
    .size       startup, . - startup


    .type       init_clock, %function
init_clock:
    ldr         r0, =RCC_CR             /* enabling HSE clock */
    ldr         r1, [r0]
    bic         r1, HSEBYP              /* clearing HSEBYP bit - not bypassing HSE oscillator*/
    orr         r1, HSEON
    str         r1, [r0]
1:
    ldr         r1, [r0]                /* waiting for HSE to be ready */
    ands        r1, HSERDY
    beq         1b
    ldr         r0, =RCC_CFGR           /* selecting HSE as the source */
    movw        r1, SW0
    str         r1, [r0]
    eor         r2, r2
    movt        r2, HSE_STARTUP_TIMEOUT
1:
    ldr         r1, [r0]                /* waiting for source being selected */
    subs        r2, 1                   /* counting some HSE_STARTUP_TIMEOUT value */
    beq         2f                      /* if HSE doesn't start - remain with HSI */
    and         r1, RCC_CFGR_SWS
    cmp         r1, SWS0
    bne         1b
2:
    bx          lr
    .size       init_clock, . - init_clock


.section        .int_vector_table, "a", %progbits
    .type       basic_vectors, %object
basic_vectors:
    .word       _estack
    .word       _reset
    .size       basic_vectors, . - basic_vectors

