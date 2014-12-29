    .thumb
    .syntax     unified
    .cpu        cortex-m4

.include        "registers_and_bits.inc.S"

.section        .text
    .type       _reset, %function
_reset:
    bl          .Lstartup
    bl          .Linit_clock
    ldr         r0, =RCC_AHB1ENR        /* this register controls some part of peripherals' clock */
    ldr         r1, [r0]
    orr         r1, GPIODEN             /* enabling GPIOD clock */
    str         r1, [r0]
    ldr         r0, =GPIOD_MODER        /* GPIOD mode configuration register */
    ldr         r1, =MODER12_OUT        /* set 12 pin of GPIOD as output */
    str         r1, [r0]
    ldr         r0, =GPIOD_ODR          /* port output register */
    eor         r1, r1                  /* elegant way to clean register */
    eor         r2 ,r2
.Lblink:
    mov         r1, LED_GREEN
    str         r1, [r0]                /* setting LED_GREEN bit in GPIOD_ODR */
    bl          .Ldelay                 /* pause */
    eor         r1, r1
    str         r1, [r0]                /* clearing GPIOD_ODR */
    bl          .Ldelay                 /* pause */
    b           .Lblink                 /* and so on */
.Ldelay:
    movt        r2, DELAY
1:
    subs        r2, r2, 1               /* spend time substracting DELAY value by 1 */
    bne         1b                      /* '1b' means `look backward for label '1'` */

    bx          lr
.Lstartup:
    ldr         r0, =RCC_CR             /* resetting clock configuration to it's defaults */
    mov         r1, HSION               /* setting HSION bit */
    str         r1, [r0]
    ldr         r0, =RCC_CFGR           /* clearing RCC_CFGR register */
    mov         r1, 0
    str         r1, [r0]
    ldr         r0, =RCC_CR             /* clearing HSEON, CSSON, PLLON bits */
    ldr         r1, [r0]
    ldr         r2, =HSEON | CSSON | PLLON
    bic         r1, r2
    str         r1, [r0]
    ldr         r0, =RCC_PLLCFGR        /* setting the default value from datasheet */
    ldr         r1, =0x24003010
    str         r1, [r0]
    ldr         r0, =RCC_CR             /* clearing HSEBYP bit */
    ldr         r1, [r0]
    bic         r1, HSEBYP
    str         r1, [r0]
    ldr         r0, =RCC_CIR            /* disabling all interrupts */
    mov         r1, 0
    str         r1, [r0]
    bx          lr
.Linit_clock:
    ldr         r0, =RCC_CR             /* enabling HSE clock */
    ldr         r1, [r0]
    orr         r1, HSEON
    str         r1, [r0]
1:
    ldr         r1, [r0]                /* waiting for HSE to be ready */
    ands        r1, HSERDY
    beq         1b
    ldr         r0, =RCC_APB1ENR        /* enable power controller and */
    ldr         r1, [r0]                /* select regulator voltage scale mode 1*/
    orr         r1, PWREN               /* to be able to work on 168 MHz */
    str         r1, [r0]
    ldr         r0, =PWR_CR
    ldr         r1, [r0]
    orr         r1, VOS
    str         r1, [r0]
    ldr         r0, =RCC_CFGR           /* configuring peripherals clock prescaling */
    ldr         r1, [r0]
    bic         r1, RCC_CFGR_HPRE_DIV1  /* explicitly setting no devision for AHB */
    orr         r1, RCC_CFGR_PPRE2_DIV2 /* 168 / 2 <= 84 MHz for high speed devices */
    orr         r1, RCC_CFGR_PPRE1_DIV4 /* 168 / 4 <= 42 MHz for low speed devices */
    str         r1, [r0]
    ldr         r0, =RCC_PLLCFGR        /* configuring main PLL */
    ldr         r1, [r0]
    ldr         r2, =PLL_M | PLL_N << 6 | ((PLL_P >> 1) - 1) << 16 | PLLSRC | PLL_Q << 24
    orr         r1, r2
    str         r1, [r0]
    ldr         r0, =RCC_CR             /* enable main PLL */
    ldr         r1, [r0]
    orr         r1, PLLON
    str         r1, [r0]
1:
    ldr         r1, [r0]                /* wait for PLL to be ready */
    ands        r1, PLLRDY 
    beq         1b
    ldr         r0, =FLASH_ACR          /* encreasing flash latency clock cycles amount */
    ldr         r1, [r0]                /* in general this parameter depends on Vdd and system clock frequency */
    ldr         r2, =ACR_LATENCY_5WS    /* in our case it is 6 cycles (or 5 "wait states") according to the manual */
    orr         r1, r2
    str         r1, [r0]
    ldr         r0, =RCC_CFGR           /* selecting PLL as a source */
    ldr         r1, [r0]
    orr         r1, SW1
    str         r1, [r0]
1:
    ldr         r1, [r0]
    and         r1, RCC_CFGR_SWS
    cmp         r1, SWS1 
    bne         1b
    bx          lr
    .size       _reset, . - _reset


.section        .int_vector_table, "a", %progbits
    .type       basic_vectors, %object
basic_vectors:
    .word       _estack
    .word       _reset

    .size       basic_vectors, . - basic_vectors
