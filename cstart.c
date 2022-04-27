#include <stdint.h>
#include "sp804.h"

int main() {
	register int register6 asm("r6");
	register6 = 0xDEADBEEF;
	
	timers_init();
	
	static char something_for_bss[100];
	int summation = 0;
	for (int i=0; i<100; ++i) {
	    summation += something_for_bss[i];
	}
	
	
	static const char* something_for_rodata = "This a read-only message.";
	for (int i=0; i<100; ++i) {
	    summation += something_for_rodata[i];
	}
	
	//timer_disable(TIMER_A);
	//timer_disable(TIMER_B);
	
	while (1) {};

	return 0;
}
