ENTRY(start)
SECTIONS
{
    . = 0x10000;
    .text : { *(.text) }
    .data : { *(.data) }    /* all data in .data section */
    .bss  : { *(.bss)  }    /* all bss in .bss section */
    . =ALIGN(8);
     . =. + 0xF000;         /* 8 KB stack space */
    stack_top =.;  /* stack_top is a symbol exported by linker */
}