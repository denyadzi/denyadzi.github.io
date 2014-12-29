    .equ        RCC_BASE,               0x40023800
    .equ        RCC_CR,                 RCC_BASE
    .equ        RCC_CFGR,               RCC_BASE + 0x08
    .equ        RCC_PLLCFGR,            RCC_BASE + 0x04
    .equ        RCC_AHB1ENR,            RCC_BASE + 0x30
    .equ        RCC_APB1ENR,            RCC_BASE + 0x40
    .equ        RCC_CIR,                RCC_BASE + 0x0C
    .equ        PWR_BASE,               0x40007000
    .equ        PWR_CR,                 PWR_BASE
    .equ        FLASH_BASE,             0x40023C00
    .equ        FLASH_ACR,              FLASH_BASE
    .equ        GPIOD_BASE,             0x40020C00
    .equ        GPIOD_MODER,            GPIOD_BASE
    .equ        GPIOD_ODR,              GPIOD_BASE + 0x14

    .equ        GPIODEN,                1 << 3
    .equ        MODER12_OUT,            1 << 24
    .equ        LED_GREEN,              1 << 12
    .equ        PLLON,                  1 << 24
    .equ        PLLRDY,                 1 << 25
    .equ        PLLSRC,                 1 << 22
    .equ        HSION,                  1
    .equ        HSEBYP,                 1 << 18
    .equ        HSEON,                  1 << 16
    .equ        HSERDY,                 1 << 17
    .equ        CSSON,                  1 << 19
    .equ        PWREN,                  1 << 28
    .equ        VOS,                    1 << 14
    .equ        SW0,                    1
    .equ        SW1,                    1 << 1
    .equ        SWS0,                   1 << 2
    .equ        SWS1,                   1 << 3             

    .equ        PLL_M,                  8
    .equ        PLL_N,                  336
    .equ        PLL_P,                  2
    .equ        PLL_Q,                  7
    .equ        DELAY,                  0x5F
    .equ        ACR_LATENCY_5WS,        5 

    .equ        RCC_PLLCFGR_PLLP,       ~(0x3 << 16)
    .equ        RCC_PLLCFGR_PLLM,       ~0x3F
    .equ        RCC_PLLCFGR_PLLN,       ~(0x1FF << 6)
    .equ        RCC_CFGR_HPRE_DIV1,     0xF << 4
    .equ        RCC_CFGR_PPRE2_DIV2,    0x8000 
    .equ        RCC_CFGR_PPRE1_DIV4,    0x1400
    .equ        RCC_CFGR_SW,            3
    .equ        RCC_CFGR_SWS,           3 << 2

