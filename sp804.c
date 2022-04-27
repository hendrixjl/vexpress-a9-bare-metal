#include "sp804.h"


#include <stdint.h>

/* Flags for the timer control registers  */
#define SP804_TIMER_ENABLE       (1 << 7)
#define SP804_TIMER_FREE_RUNNING (0 << 6)
#define SP804_TIMER_PERIODIC     (1 << 6)
#define SP804_TIMER_INT_ENABLE   (1 << 5)
#define SP804_TIMER_PRESCALE_1   (0 << 2)
#define SP804_TIMER_PRESCALE_16  (1 << 2)
#define SP804_TIMER_PRESCALE_256 (2 << 2)
#define SP804_TIMER_32BIT        (1 << 1)
#define SP804_TIMER_16BIT        (0 << 1)
#define SP804_TIMER_ONESHOT      (1 << 0)

#define TIMER_BASE 0x10011000

typedef volatile struct {
    struct {
        uint32_t Load;     /* +0x00 */
        uint32_t Value;    /* +0x04 */
        uint32_t Control;  /* +0x08 */
        uint32_t IntClr;   /* +0x0C */
        uint32_t RIS;      /* +0x10 */
        uint32_t MIS;      /* +0x14 */
        uint32_t BGLoad;   /* +0x18 */
        uint32_t Reserved; /* +0x1C */
    } timers[2];
} timer804_t;

volatile timer804_t* const tregs = (timer804_t*)TIMER_BASE;


void timer_enable(timer_t timer){
    tregs->timers[timer].Control |= SP804_TIMER_ENABLE;
}

void timer_disable(timer_t timer){
    tregs->timers[timer].Control &= ~SP804_TIMER_ENABLE;
}


void timers_init(void){
    tregs->timers[TIMER_A].Control = SP804_TIMER_PERIODIC | SP804_TIMER_32BIT  | SP804_TIMER_PRESCALE_256; 
    tregs->timers[TIMER_A].Load = 0;
    tregs->timers[TIMER_A].Value = 0;
    tregs->timers[TIMER_A].RIS = 0;
    tregs->timers[TIMER_A].MIS = 0;
    tregs->timers[TIMER_A].BGLoad = 0x10000;
    timer_enable(TIMER_A);

    tregs->timers[TIMER_B].Control = SP804_TIMER_FREE_RUNNING | SP804_TIMER_32BIT  | SP804_TIMER_PRESCALE_256; 
    tregs->timers[TIMER_B].Load = 0;
    tregs->timers[TIMER_B].Value = 0;
    tregs->timers[TIMER_B].RIS = 0;
    tregs->timers[TIMER_B].MIS = 0;
    tregs->timers[TIMER_B].BGLoad = 0;
    timer_enable(TIMER_B);
}
