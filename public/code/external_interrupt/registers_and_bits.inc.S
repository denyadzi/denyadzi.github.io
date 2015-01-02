    .equ        RCC_BASE,       0x40023800
    .equ        RCC_CR  ,       RCC_BASE
    .equ        RCC_CFGR,       RCC_BASE + 0x08
    .equ        RCC_PLLCFGR,    RCC_BASE + 0x04
    .equ        RCC_AHB1ENR,    RCC_BASE + 0x30
    .equ        RCC_APB2ENR,    RCC_BASE + 0x44
    .equ        RCC_CIR,        RCC_BASE + 0x0C
    .equ        GPIOD_BASE,     0x40020C00
    .equ        GPIOD_MODER,    GPIOD_BASE
    .equ        GPIOD_ODR,      GPIOD_BASE + 0x14
    .equ        GPIOA_BASE,     0x40020000
    .equ        GPIOA_MODER,    GPIOA_BASE
    .equ        GPIOA_PUPDR,    GPIOA_BASE + 0x0C
    .equ        GPIOA_IDR,      GPIOA_BASE + 0x10
    .equ        SYSCFG_BASE,    0x40013800
    .equ        SYSCFG_EXTICR1, SYSCFG_BASE + 0x08 
    .equ        EXTI_BASE,      0x40013C00
    .equ        EXTI_IMR,       EXTI_BASE
    .equ        EXTI_RTSR,      EXTI_BASE + 0x08
    .equ        EXTI_PR,        EXTI_BASE + 0x14
    .equ        NVIC_BASE,      0xE000E100
    .equ        NVIC_ISER0,     NVIC_BASE

    .equ        GPIODEN,        1 << 3
    .equ        GPIOAEN,        1
    .equ        SYSCFGEN,       1 << 14
    .equ        MODER12_OUT,    1 << 24
    .equ        MODER13_OUT,    1 << 26
    .equ        MODER14_OUT,    1 << 28
    .equ        MODER15_OUT,    1 << 30
    .equ        MODER0_IN,      0x3 
    .equ        LED_GREEN,      1 << 12
    .equ        LED_ORANGE,     1 << 13
    .equ        LED_RED,        1 << 14
    .equ        LED_BLUE,       1 << 15
    .equ        PLLON,          1 << 24
    .equ        HSION,          1
    .equ        HSEBYP,         1 << 18
    .equ        HSEON,          1 << 16
    .equ        HSERDY,         1 << 17
    .equ        CSSON,          1 << 19
    .equ        SW0,            1
    .equ        SWS0,           1 << 2             
    .equ        PUPDR0_PD,      1 << 1
    .equ        IDR0,           1
    .equ        MR0,            1
    .equ        TR0,            1
    .equ        PR0,            1
    .equ        EXTI0_IRQn,     6
    .equ        SETENA6,        1 << EXTI0_IRQn

    .equ        HSE_STARTUP_TIMEOUT,    0x1

    .equ        RCC_CFGR_SWS,           3 << 2
    .equ        GPIOx_PUPDR0,           3
    .equ        SYSCFG_EXTICR1_EXTI0,   0xF

