    .thumb
    .cpu        cortex-m4
    .syntax     unified

    .equ        TIM2_BASE, 0x40000000 
    .equ        TIM2_ARR,  TIM2_BASE + 0x2C
    .equ        TIM2_CR1,  TIM2_BASE
    .equ        TIM2_DIER, TIM2_BASE + 0x0C
    .equ        TIM2_PSC,  TIM2_BASE + 0x28
    .equ        TIM2_SR,   TIM2_BASE + 0x10
    .equ        TIM2_EGR,  TIM2_BASE + 0x14

    /*
    ---------- TIM3..TIM5------------------
    */

    .equ        CEN, 1
    .equ        UIE, 1
    .equ        UIF, 1
    .equ        UG,  1

    .globl      tim_2_init
    .globl      TIM2_IRQHandler
    .globl      tim_3_init
    .globl      TIM3_IRQHandler
    .globl      tim_4_init
    .globl      TIM4_IRQHandler
    .globl      tim_5_init
    .globl      TIM5_IRQHandler


.section        .text
    .type       tim_2_init, %function
tim_2_init:
    push        {r0, r1}
    ldr         r0, =TIM2_ARR               /* preloading count value */
    movw        r1, 3999
    str         r1, [r0]
    
    ldr         r0, =TIM2_DIER              /* enabling update interrupt */
    ldr         r1, [r0]
    orr         r1, UIE 
    str         r1, [r0]

    ldr         r0, =TIM2_PSC               /* setting timer clock prescaler */
    movw        r1, 62999
    str         r1, [r0]

    ldr         r0, =TIM2_EGR               /* update event to apply prescaler*/
    ldr         r1, [r0]
    orr         r1, UG
    str         r1, [r0]

    ldr         r0, =TIM2_CR1               /* enabling counter */
    ldr         r1, [r0]
    orr         r1, CEN
    str         r1, [r0]
    
    pop         {r0, r1}
    bx          lr
    .size       tim_2_init, . - tim_2_init


    .type       TIM2_IRQHandler, %function
TIM2_IRQHandler:
    push        {r0, r1, lr}
    bl          flash_green
    ldr         r0, =TIM2_SR                /* clearing interrupt flag */
    ldr         r1, [r0]
    bic         r1, UIF
    str         r1, [r0]

    pop         {r0, r1, lr}
    bx          lr
    .size       TIM2_IRQHandler, . - TIM2_IRQHandler


    .type       tim_3_init, %function
tim_3_init:
    /*
    ---------TIM3
    */
    .size       tim_3_init, . - tim_3_init


    .type       TIM3_IRQHandler, %function
TIM3_IRQHandler:
    push        {r0, r1, lr}
    bl          flash_orange
    ldr         r0, =TIM3_SR                /* clearing interrupt flag */
    ldr         r1, [r0]
    bic         r1, UIF
    str         r1, [r0]

    pop         {r0, r1, lr}
    bx          lr
    .size       TIM3_IRQHandler, . - TIM3_IRQHandler


    .type       tim_4_init, %function
tim_4_init:
    /*
    ------------ TIM4--------------------
    */
    .size       tim_3_init, . - tim_3_init


    .type       TIM4_IRQHandler, %function
TIM4_IRQHandler:
    push        {r0, r1, lr}
    bl          flash_red
    ldr         r0, =TIM4_SR                /* clearing interrupt flag */
    ldr         r1, [r0]
    bic         r1, UIF
    str         r1, [r0]

    pop         {r0, r1, lr}
    bx          lr
    .size       TIM4_IRQHandler, . - TIM4_IRQHandler


    .type       tim_5_init, %function
tim_5_init:
    /* 
    -------- TIM5 -------------------
    */
    .size       tim_5_init, . - tim_5_init


    .type       TIM5_IRQHandler, %function
TIM5_IRQHandler:
    push        {r0, r1, lr}
    bl          flash_blue
    ldr         r0, =TIM5_SR                /* clearing interrupt flag */
    ldr         r1, [r0]
    bic         r1, UIF
    str         r1, [r0]

    pop         {r0, r1, lr}
    bx          lr
    .size       TIM5_IRQHandler, . - TIM5_IRQHandler
