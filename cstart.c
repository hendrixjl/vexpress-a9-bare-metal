#include <stdint.h>


int main() {
	const char* s = "Hello world from bare-metal!\n";
	register int register6 asm("r6");
	register6 = 0xDEADBEEF;
	//asm("mov r6, r7");
	while (1) {};

	return 0;
}
