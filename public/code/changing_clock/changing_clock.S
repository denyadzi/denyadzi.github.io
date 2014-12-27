    .thumb
    .syntax     unified
    .cpu        cortex-m4
#define RCC_BASE            0x40023800
#define RCC_CR              RCC_BASE
#define RCC_CFGR            RCC_BASE + 0x08
#define RCC_PLLCFGR         RCC_BASE + 0x04
#define RCC_AHB1ENR         RCC_BASE + 0x30
#define RCC_CIR             RCC_BASE + 0x0C
#define GPIOD_BASE          0x40020C00
#define GPIOD_MODER         GPIOD_BASE
#define GPIOD_ODR           GPIOD_BASE + 0x14

#define GPIODEN             1 << 3
#define MODER12_OUT         1 << 24
#define LED_GREEN           1 << 12
#define PLLON               1 << 24
#define HSION               1
#define HSEBYP              1 << 18
#define HSEON               1 << 16
#define HSERDY              1 << 17
#define CSSON               1 << 19
#define SW0                 1
#define SWS0                1 << 2             

#define DELAY               0x5F
#define HSE_STARTUP_TIMEOUT 0x1

#define RCC_CFGR_SWS        3 << 2

.section        .text
    .type       _reset, %function
_reset:
    bl          .Lstartup
    bl          .Linit_clock
    ldr         r0, =RCC_AHB1ENR        /* this register controls some amount of peripherals' clock */
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

.Linit_clock:
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
    .size       _reset, . - _reset


.section        .int_vector_table, "a", %progbits
    .type       basic_vectors, %object
basic_vectors:
    .word       _estack
    .word       _reset

    .size       basic_vectors, . - basic_vectors
