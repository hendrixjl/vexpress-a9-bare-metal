#include "sp804.h"
// #include "interrupt.h"

volatile timer804_t* const tregs = (timer804_t*)TIMER_BASE;


void timer_init(void){
    tregs->timers[0].Control = SP804_TIMER_PERIODIC | SP804_TIMER_32BIT  | SP804_TIMER_PRESCALE_256; 
    tregs->timers[0].Load = 0;
    tregs->timers[0].Value = 0;
    tregs->timers[0].RIS = 0;
    tregs->timers[0].MIS = 0;
    tregs->timers[0].BGLoad = 0x10000;
    tregs->timers[0].Control |= SP804_TIMER_ENABLE;

    tregs->timers[1].Control = SP804_TIMER_FREE_RUNNING | SP804_TIMER_32BIT  | SP804_TIMER_PRESCALE_256; 
    tregs->timers[1].Load = 0;
    tregs->timers[1].Value = 0;
    tregs->timers[1].RIS = 0;
    tregs->timers[1].MIS = 0;
    tregs->timers[1].BGLoad = 0;
    tregs->timers[1].Control |= SP804_TIMER_ENABLE;

}
