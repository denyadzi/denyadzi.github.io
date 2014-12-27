    .thumb
    .syntax     unified
    .cpu        cortex-m4
#define RCC_BASE        0x40023800
#define RCC_CR          RCC_BASE
#define RCC_CFGR        RCC_BASE + 0x08
#define RCC_PLLCFGR     RCC_BASE + 0x04
#define RCC_AHB1ENR     RCC_BASE + 0x30
#define RCC_APB1ENR     RCC_BASE + 0x40
#define RCC_CIR         RCC_BASE + 0x0C
#define PWR_BASE        0x40007000
#define PWR_CR          PWR_BASE
#define FLASH_BASE      0x40023C00
#define FLASH_ACR       FLASH_BASE
#define GPIOD_BASE      0x40020C00
#define GPIOD_MODER     GPIOD_BASE
#define GPIOD_ODR       GPIOD_BASE + 0x14

#define GPIODEN         1 << 3
#define MODER12_OUT     1 << 24
#define LED_GREEN       1 << 12
#define PLLON           1 << 24
#define PLLRDY          1 << 25
#define PLLSRC          1 << 22
#define HSION           1
#define HSEBYP          1 << 18
#define HSEON           1 << 16
#define HSERDY          1 << 17
#define CSSON           1 << 19
#define PWREN           1 << 28
#define VOS             1 << 14
#define SW0             1
#define SW1             1 << 1
#define SWS0            1 << 2
#define SWS1            1 << 3             
#define ICEN            1 << 9
#define DCEN            1 << 10

#define PLL_M           8
#define PLL_N           336
#define PLL_P           2
#define PLL_Q           7
#define DELAY           0x5F
#define ACR_LATENCY_5WS 5 

#define RCC_PLLCFGR_PLLP    ~(0x3 << 16)
#define RCC_PLLCFGR_PLLM    ~0x3F
#define RCC_PLLCFGR_PLLN    ~(0x1FF << 6)
#define RCC_CFGR_PPRE2_DIV2 0x8000 
#define RCC_CFGR_PPRE1_DIV4 0x1400
#define RCC_CFGR_SW         3
#define RCC_CFGR_SWS        3 << 2

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
    ldr         r2, =(HSEON) | (CSSON) | (PLLON)
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
    ldr         r0, =RCC_APB1ENR        /* select regulator voltage scale mode 1*/
    ldr         r1, [r0]
    orr         r1, PWREN
    str         r1, [r0]
    ldr         r0, =PWR_CR
    ldr         r1, [r0]
    orr         r1, VOS
    str         r1, [r0]
    ldr         r0, =RCC_CFGR
    ldr         r1, [r0]
    orr         r1, RCC_CFGR_PPRE2_DIV2
    orr         r1, RCC_CFGR_PPRE1_DIV4
    str         r1, [r0]
    ldr         r0, =RCC_PLLCFGR        /* configuring main PLL */
    ldr         r1, [r0]
    ldr         r2, =(PLL_M | (PLL_N << 6) | (((PLL_P >> 1) - 1) << 16) | (PLLSRC) | (PLL_Q << 24))
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
    ldr         r0, =FLASH_ACR
    ldr         r1, [r0]
    ldr         r2, =((ICEN) | (DCEN) | (ACR_LATENCY_5WS))
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
