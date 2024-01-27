ENTRY(reset_handler)
SECTIONS
{
    . = 0x10000;
    .text : { ts.o *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss) }
    . = ALIGN(8);
    . = . + 0x1000;
    svc_stack_top = .;
    . = . + 0x1000;
    irq_stack_top = .;
}
