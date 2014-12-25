    .syntax unified
    .cpu cortex-m4
    .fpu softvfp
    .thumb

#define RCC_BASE        0x40023800
#define RCC_AHB1ENR     RCC_BASE + 0x30 
#define RCC_CR          RCC_BASE
#define RCC_PLLCFGR     RCC_BASE + 0x4
#define RCC_CFGR        RCC_BASE + 0x8
#define GPIOD_BASE      0x40020C00
#define GPIOD_MODER     GPIOD_BASE
#define GPIOD_ODR       GPIOD_BASE + 0x14

#define GPIODEN         1 << 3
#define MODER15_OUT     1 << 30
#define MODER14_OUT     1 << 28
#define MODER13_OUT     1 << 26
#define MODER12_OUT     1 << 24
#define LED_BLUE        1 << 15
#define LED_RED         1 << 14
#define LED_ORANGE      1 << 13
#define LED_GREEN       1 << 12
#define DELAY           0x000F

.section    .text
  .weak     _reset              /* that's because of declaring it as an entry point */
  .type     _reset, %function
_reset:  
    ldr     r0, =RCC_AHB1ENR    /* firstly, to use any peripheral, the clock should be */ 
    ldr     r1, [r0]            /* enabled for it. Different registers are responsible for that */
                                /* (see reference manual's "Reset and clock control" section on page 210). */
                                /* For use of GPIOD it's clock is enabled in RCC_AHB1ENR register */
    orr     r1, GPIODEN         /* by setting GPIODEN bit */
    str     r1, [r0]
    ldr     r0, =GPIOD_MODER    /* port mode configuration ragister (input,output, etc) */
    ldr     r1, =(MODER15_OUT | MODER14_OUT | MODER13_OUT | MODER12_OUT)
    str     r1, [r0]            /* configuring GPIOD pins 12-15 as outputs where LEDs are connected to */
    mov     r1, 0		        /* clearing for further LED selection	 */
    ldr     r2, =GPIOD_ODR      /* GPIOD output data register	 */
                                /* writing to it controls pins' voltage */
.Lblink:
    movw    r1, LED_GREEN		
    str     r1, [r2]            /* setting LED_GREEN bit on GPIOD_ODR */
    bl      .Ldelay             /* pause */
    movw    r1, LED_BLUE 
    str     r1, [r2]            /* setting LED_BLUE bit on GPIOD_ODR  */
    bl      .Ldelay             /* pause */
    movw    r1, LED_RED
    str     r1, [r2]            /* etc  */
    bl      .Ldelay
    movw    r1, LED_ORANGE
    str     r1, [r2]
    bl      .Ldelay
    b       .Lblink

.Ldelay:
    movt    r0, DELAY           /* moving DELAY value into high halfword of the register  */
1:                              /* to make a big number */
    subs    R0, R0, 1           /* and just spend time substracting */
    bne     1b
    bx      lr                  /* return */

    .size   _reset, . - _reset


.section    .int_vector_table, "a", %progbits   /* interrupt table */
                                                /* "a" - tells that section is allocatable  */
                                                /* (see ld manual) */
                                                /* %progbits - tells that section contains data */
                                                /* (see gas manual) */
    .type   basic_vectors, %object
basic_vectors:
    .word   _estack             /* stack top address (declared in basic.ld) - the last SRAM address */
    .word   _reset              /* the address of a reset handler */

    .size   basic_vectors, . - basic_vectors
