#include <stdint.h>
#include "sp804.h"

int main() {
	register int register6 asm("r6");
	register6 = 0xDEADBEEF;
	
	timer_init();
	
	while (1) {};

	return 0;
}
