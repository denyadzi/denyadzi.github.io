#include  "stm32f4_discovery.h"

extern void tim_2_init (void);
extern void tim_3_init (void);
extern void tim_4_init (void);
extern void tim_5_init (void);

void gpio_init (void);
void rcc_init (void);
void nvic_init (void);
void flash_green (void);
void flash_orange (void);
void flash_blue (void);
void flash_red (void);


/**
 * Main routine
 *
 * It consists of init stage and an endless loop.
 * Everything else is done in interrupts handlers,
 * which are in assembly
 * In this routine we enable peripherals' clock for timers and port,
 * setting up port D, globally enabling interrupts in NVIC
 * and initializing each timer
 */
int main (void)
{
    rcc_init ();
    gpio_init ();
    nvic_init ();
    tim_2_init ();
    tim_3_init ();
    tim_4_init ();
    tim_5_init ();

    while (1)
        ;

    return 0;
}

/**
 * Port D initialization
 *
 * Setting up pins 12-15 (with LEDS) as outputs
 */
void gpio_init ()
{
    GPIO_InitTypeDef gpio_init;
    gpio_init.GPIO_Pin = GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15;
    gpio_init.GPIO_Mode = GPIO_Mode_OUT;
    gpio_init.GPIO_Speed = GPIO_Speed_100MHz;
    gpio_init.GPIO_OType = GPIO_OType_PP;
    gpio_init.GPIO_PuPd = GPIO_PuPd_NOPULL;

    GPIO_Init (GPIOD, &gpio_init);
}

/**
 * Peripherals' clocks initialization
 *
 * Enabling clock for timers (APB1 bus) and port D (AHB1)
 */
void rcc_init ()
{
    RCC_APB1PeriphClockCmd (RCC_APB1Periph_TIM2 | RCC_APB1Periph_TIM3 | 
                            RCC_APB1Periph_TIM4 | RCC_APB1Periph_TIM5, 
                            ENABLE);
    RCC_AHB1PeriphClockCmd (RCC_AHB1Periph_GPIOD, ENABLE);
}

/**
 * Interrupts global enable
 */
void nvic_init ()
{
    NVIC_EnableIRQ (TIM2_IRQn);
    NVIC_EnableIRQ (TIM3_IRQn);
    NVIC_EnableIRQ (TIM4_IRQn);
    NVIC_EnableIRQ (TIM5_IRQn);
}

/**
 * Following routines are called from each timer interrupt
 * handler
 */
void flash_green () 
{
    GPIO_ToggleBits (GPIOD, GPIO_Pin_12);
}

void flash_orange () 
{
    GPIO_ToggleBits (GPIOD, GPIO_Pin_13);
}

void flash_blue () 
{
    GPIO_ToggleBits (GPIOD, GPIO_Pin_15);
}

void flash_red () 
{
    GPIO_ToggleBits (GPIOD, GPIO_Pin_14);
}
