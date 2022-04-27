OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_Reset)

MEMORY
{
    RAM (rwx): ORIGIN = 0x60010000, LENGTH = 32M
}

SECTIONS
{
    .text : {
        startup.o (.vector_table)
        *(.text*)
        *(.rodata*)
     } > RAM
    _text_end = .;
    .data : AT(ADDR(.text) + SIZEOF(.text))
    {
        _data_start = .;
        *(.data)
        . = ALIGN(8);
    } > RAM
    _data_end = .;
    .bss : {
        _bss_start = .;
        *(.bss)
        . = ALIGN(8);
    } > RAM
    _bss_end = .;

    _fiq_stack_buffer = ADDR(.bss) + SIZEOF(.bss);
    _fiq_stack_start = _fiq_stack_buffer + 0x04;
    _fiq_stack_end = _fiq_stack_start + 0x020;

    _irq_stack_buffer = _fiq_stack_end;
    _irq_stack_start = _irq_stack_buffer + 0x04;
    _irq_stack_end = _irq_stack_start + 0x020;

    _svc_stack_buffer = _irq_stack_end;
    _svc_stack_start = _svc_stack_buffer + 0x04;
    _svc_stack_end = _svc_stack_start + 0x020;

    _usr_stack_buffer = _svc_stack_end;
    _usr_stack_start = _usr_stack_buffer + 0x04;
    _usr_stack_end = _usr_stack_start + 0x0200;
    
    _last_word_marker = _usr_stack_end + 4;

    _irq_stack_size = _irq_stack_end - _irq_stack_start;
    _fiq_stack_size = _fiq_stack_end - _fiq_stack_start;
}
