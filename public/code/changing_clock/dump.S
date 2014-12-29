ARM GAS  /tmp/ccxoHwPf.s 			page 1


   1              	# 1 "speed_up.S"
   1              	    .thumb
   1              	...
   0              	
   0              	
   2              	    .syntax     unified
   3              	    .cpu        cortex-m4
   4              	#define RCC_BASE        0x40023800
   5              	    .equ        RCC_CR, RCC_BASE
   6              	#define RCC_CFGR        RCC_BASE + 0x08
   7              	#define RCC_PLLCFGR     RCC_BASE + 0x04
   8              	#define RCC_AHB1ENR     RCC_BASE + 0x30
   9              	#define RCC_APB1ENR     RCC_BASE + 0x40
  10              	#define RCC_CIR         RCC_BASE + 0x0C
  11              	#define PWR_BASE        0x40007000
  12              	#define PWR_CR          PWR_BASE
  13              	#define FLASH_BASE      0x40023C00
  14              	#define FLASH_ACR       FLASH_BASE
  15              	#define GPIOD_BASE      0x40020C00
  16              	#define GPIOD_MODER     GPIOD_BASE
  17              	#define GPIOD_ODR       GPIOD_BASE + 0x14
  18              	
  19              	#define GPIODEN         1 << 3
  20              	#define MODER12_OUT     1 << 24
  21              	    .equ    LED_GREEN, 1 << 12
  22              	#define PLLON           1 << 24
  23              	#define PLLRDY          1 << 25
  24              	#define PLLSRC          1 << 22
  25              	#define HSION           1
  26              	#define HSEBYP          1 << 18
  27              	#define HSEON           1 << 16
  28              	#define HSERDY          1 << 17
  29              	#define CSSON           1 << 19
  30              	#define PWREN           1 << 28
  31              	#define VOS             1 << 14
  32              	#define SW0             1
  33              	#define SW1             1 << 1
  34              	#define SWS0            1 << 2
  35              	#define SWS1            1 << 3             
  36              	#define ICEN            1 << 9
  37              	#define DCEN            1 << 10
  38              	
  39              	#define PLL_M           8
  40              	#define PLL_N           336
  41              	#define PLL_P           2
  42              	#define PLL_Q           7
  43              	#define DELAY           0x5F
  44              	#define ACR_LATENCY_5WS 5 
  45              	
  46              	#define RCC_PLLCFGR_PLLP    ~(0x3 << 16)
  47              	#define RCC_PLLCFGR_PLLM    ~0x3F
  48              	#define RCC_PLLCFGR_PLLN    ~(0x1FF << 6)
  49              	#define RCC_CFGR_PPRE2_DIV2 0x8000 
  50              	#define RCC_CFGR_PPRE1_DIV4 0x1400
  51              	#define RCC_CFGR_SW         3
  52              	#define RCC_CFGR_SWS        3 << 2
  53              	
ARM GAS  /tmp/ccxoHwPf.s 			page 2


  54              	.section        .text
  55              	    .type       _reset, %function
  56              	_reset:
  57 0000 00F01FF8 	    bl          .Lstartup
  58 0004 00F038F8 	    bl          .Linit_clock
  59 0008 3848     	    ldr         r0, =RCC_AHB1ENR        /* this register controls some part of peripherals' clock *
  60 000a 0168     	    ldr         r1, [r0]
  61 000c 41F00801 	    orr         r1, GPIODEN             /* enabling GPIOD clock */
  62 0010 0160     	    str         r1, [r0]
  63 0012 3748     	    ldr         r0, =GPIOD_MODER        /* GPIOD mode configuration register */
  64 0014 3749     	    ldr         r1, =MODER12_OUT        /* set 12 pin of GPIOD as output */
  65 0016 0160     	    str         r1, [r0]
  66 0018 3748     	    ldr         r0, =GPIOD_ODR          /* port output register */
  67 001a 81EA0101 	    eor         r1, r1                  /* elegant way to clean register */
  68 001e 82EA0202 	    eor         r2 ,r2
  69              	.Lblink:
  70 0022 4FF48051 	    mov         r1, LED_GREEN
  71 0026 0160     	    str         r1, [r0]                /* setting LED_GREEN bit in GPIOD_ODR */
  72 0028 00F006F8 	    bl          .Ldelay                 /* pause */
  73 002c 81EA0101 	    eor         r1, r1
  74 0030 0160     	    str         r1, [r0]                /* clearing GPIOD_ODR */
  75 0032 00F001F8 	    bl          .Ldelay                 /* pause */
  76 0036 F4E7     	    b           .Lblink                 /* and so on */
  77              	.Ldelay:
  78 0038 C0F25F02 	    movt        r2, DELAY
  79              	1:
  80 003c 013A     	    subs        r2, r2, 1               /* spend time substracting DELAY value by 1 */
  81 003e FDD1     	    bne         1b                      /* '1b' means `look backward for label '1'` */
  82              	
  83 0040 7047     	    bx          lr
  84              	.Lstartup:
  85 0042 2E48     	    ldr         r0, =RCC_CR             /* resetting clock configuration to it's defaults */
  86 0044 4FF00101 	    mov         r1, HSION               /* setting HSION bit */
  87 0048 0160     	    str         r1, [r0]
  88 004a 2D48     	    ldr         r0, =RCC_CFGR           /* clearing RCC_CFGR register */
  89 004c 4FF00001 	    mov         r1, 0
  90 0050 0160     	    str         r1, [r0]
  91 0052 2A48     	    ldr         r0, =RCC_CR             /* clearing HSEON, CSSON, PLLON bits */
  92 0054 0168     	    ldr         r1, [r0]
  93 0056 2B4A     	    ldr         r2, =(HSEON) | (CSSON) | (PLLON)
  94 0058 21EA0201 	    bic         r1, r2
  95 005c 0160     	    str         r1, [r0]
  96 005e 2A48     	    ldr         r0, =RCC_PLLCFGR        /* setting the default value from datasheet */
  97 0060 2A49     	    ldr         r1, =0x24003010
  98 0062 0160     	    str         r1, [r0]
  99 0064 2548     	    ldr         r0, =RCC_CR             /* clearing HSEBYP bit */
 100 0066 0168     	    ldr         r1, [r0]
 101 0068 21F48021 	    bic         r1, HSEBYP
 102 006c 0160     	    str         r1, [r0]
 103 006e 2848     	    ldr         r0, =RCC_CIR            /* disabling all interrupts */
 104 0070 4FF00001 	    mov         r1, 0
 105 0074 0160     	    str         r1, [r0]
 106 0076 7047     	    bx          lr
 107              	.Linit_clock:
 108 0078 2048     	    ldr         r0, =RCC_CR             /* enabling HSE clock */
 109 007a 0168     	    ldr         r1, [r0]
 110 007c 41F48031 	    orr         r1, HSEON
ARM GAS  /tmp/ccxoHwPf.s 			page 3


 111 0080 0160     	    str         r1, [r0]
 112              	1:
 113 0082 0168     	    ldr         r1, [r0]                /* waiting for HSE to be ready */
 114 0084 11F40031 	    ands        r1, HSERDY
 115 0088 FBD0     	    beq         1b
 116 008a 2248     	    ldr         r0, =RCC_APB1ENR        /* select regulator voltage scale mode 1*/
 117 008c 0168     	    ldr         r1, [r0]
 118 008e 41F08051 	    orr         r1, PWREN
 119 0092 0160     	    str         r1, [r0]
 120 0094 2048     	    ldr         r0, =PWR_CR
 121 0096 0168     	    ldr         r1, [r0]
 122 0098 41F48041 	    orr         r1, VOS
 123 009c 0160     	    str         r1, [r0]
 124 009e 1848     	    ldr         r0, =RCC_CFGR
 125 00a0 0168     	    ldr         r1, [r0]
 126 00a2 41F40041 	    orr         r1, RCC_CFGR_PPRE2_DIV2
 127 00a6 41F4A051 	    orr         r1, RCC_CFGR_PPRE1_DIV4
 128 00aa 0160     	    str         r1, [r0]
 129 00ac 1648     	    ldr         r0, =RCC_PLLCFGR        /* configuring main PLL */
 130 00ae 0168     	    ldr         r1, [r0]
 131 00b0 1A4A     	    ldr         r2, =(PLL_M | (PLL_N << 6) | (((PLL_P >> 1) - 1) << 16) | (PLLSRC) | (PLL_Q << 24))
 132 00b2 41EA0201 	    orr         r1, r2
 133 00b6 0160     	    str         r1, [r0]
 134 00b8 1048     	    ldr         r0, =RCC_CR             /* enable main PLL */
 135 00ba 0168     	    ldr         r1, [r0]
 136 00bc 41F08071 	    orr         r1, PLLON
 137 00c0 0160     	    str         r1, [r0]
 138              	1:
 139 00c2 0168     	    ldr         r1, [r0]                /* wait for PLL to be ready */
 140 00c4 11F00071 	    ands        r1, PLLRDY 
 141 00c8 FBD0     	    beq         1b
 142 00ca 1548     	    ldr         r0, =FLASH_ACR
 143 00cc 0168     	    ldr         r1, [r0]
 144 00ce 154A     	    ldr         r2, =((ICEN) | (DCEN) | (ACR_LATENCY_5WS))
 145 00d0 41EA0201 	    orr         r1, r2
 146 00d4 0160     	    str         r1, [r0]
 147 00d6 0A48     	    ldr         r0, =RCC_CFGR           /* selecting PLL as a source */
 148 00d8 0168     	    ldr         r1, [r0]
 149 00da 41F00201 	    orr         r1, SW1
 150 00de 0160     	    str         r1, [r0]
 151              	1:
 152 00e0 0168     	    ldr         r1, [r0]
 153 00e2 01F00C01 	    and         r1, RCC_CFGR_SWS
 154 00e6 0829     	    cmp         r1, SWS1 
 155 00e8 FAD1     	    bne         1b
 156 00ea 7047     	    bx          lr
 157              	    .size       _reset, . - _reset
 158              	
 159              	
 160              	.section        .int_vector_table, "a", %progbits
 161              	    .type       basic_vectors, %object
 162              	basic_vectors:
 163 0000 00000000 	    .word       _estack
 164 0004 00000000 	    .word       _reset
 165              	
 166              	    .size       basic_vectors, . - basic_vectors
