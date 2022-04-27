#ifndef __SP804_H__
#define __SP804_H__


typedef enum {
    TIMER_A,
    TIMER_B
} timer_t;

void timer_enable(timer_t timer);

void timer_disable(timer_t timer);

void timers_init(void);

#endif
