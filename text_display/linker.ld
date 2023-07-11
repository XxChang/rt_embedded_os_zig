ENTRY(start)
SECTIONS
{
    . = 0x10000;
    .text : { ts.o font.o *(.text) }
    .data : { *(.data) }    /* all data in .data section */
    .bss  : { *(.bss)  }    /* all bss in .bss section */
    
    . =ALIGN(8);
     . =. + 0x4000;         /* 4 KB stack space */
    stack_top =.;  /* stack_top is a symbol exported by linker */
}