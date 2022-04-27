/* Some defines */
.equ MODE_USR, 0x10
.equ MODE_FIQ, 0x11
.equ MODE_IRQ, 0x12
.equ MODE_SVC, 0x13

.section .vector_table, "x"
.global _Reset
.global _start
_Reset:
    b Reset_Handler
    b Abort_Exception /* 0x4  Undefined Instruction */
    b . /* 0x8  Software Interrupt */
    b Abort_Exception  /* 0xC  Prefetch Abort */
    b Abort_Exception /* 0x10 Data Abort */
    b . /* 0x14 Reserved */
    b . /* 0x18 IRQ */
    b . /* 0x1C FIQ */

.section .text
Reset_Handler:

/*
   For each mode, set the stack pointer so we can call C functions.
   Put a tag right before each stack for identification via memory dump.
   Store 0xFEFEFEFE in every word of the stack so we can see how much has been used.
*/

    /* FIQ stack */
    msr cpsr_c, MODE_FIQ
    movw r2, #0x1111
    movt r2, #0x1111
    ldr r1, =_fiq_stack_buffer
    str r2, [r1], #4
    ldr sp, =_fiq_stack_end
    movw r0, #0xFEFE
    movt r0, #0xFEFE
fiq_loop: 
    cmp r1, sp
    strlt r0, [r1], #4
    blt fiq_loop

    /* IRQ stack */
    msr cpsr_c, MODE_IRQ
    ldr r1, =_irq_stack_buffer
    movw r2, #0x2222
    movt r2, #0x2222
    str r2, [r1], #4
    ldr sp, =_irq_stack_end

irq_loop:
    cmp r1, sp
    strlt r0, [r1], #4
    blt irq_loop

    /* Supervisor mode */
    msr cpsr_c, MODE_SVC
    ldr r1, =_svc_stack_buffer
    movw r2, #0x3333
    movt r2, #0x3333
    str r2, [r1], #4
    ldr sp, =_svc_stack_end

svc_stack_loop:
    cmp r1, sp
    strlt r0, [r1], #4
    blt svc_stack_loop

    /* User mode */
    msr cpsr_c, MODE_USR
    ldr r1, =_usr_stack_buffer
    movw r2, #0x4444
    movt r2, #0x4444
    str r2, [r1], #4
    ldr sp, =_usr_stack_end

usr_stack_loop:
    cmp r1, sp
    strlt r0, [r1], #4
    blt usr_stack_loop
    
    ldr r1, =_last_word_marker
    movw r2, #0xBEEF
    movt r2, #0xDEAD
    str r2, [r1], #4

    ldr r7,str1
    bl main
    b Abort_Exception

Abort_Exception:
    swi 0xFF

str1: .word 0xDEADBEEF

